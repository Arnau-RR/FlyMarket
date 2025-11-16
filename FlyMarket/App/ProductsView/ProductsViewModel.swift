//
//  ProductsViewModel.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 15/11/25.
//

import SwiftUI
import Combine

enum CustomerType: String, CaseIterable {
    case retail = "Retail"
    case crew = "Crew"
    case happyHour = "Happy hour"
    case businessInvitation = "Business invitation"
    case touristInvitation = "Tourist invitation"
    
    var displayName: String {
        return self.rawValue
    }
}

// MARK: - ViewModel
@MainActor
class ProductsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var products: [ProductItem] = []
    @Published var selectedCustomerType: CustomerType = .retail
    @Published var showSaleTypeMenu: Bool = false
    @Published var showListPopup: Bool = false
    @Published var showCurrencyPopup: Bool = false
    @Published var totalAmount: Decimal = 0
    @Published var currency: Currency = .eur {
        didSet {
            recalculateTotal()
        }
    }
    @Published var navigateToReceiptScreen = false
    @Published var productsSelected: [ProductItem] = []
    
    // MARK: - Computed Properties
    var selectedSaleTypeAttributed: AttributedString {
        AttributedString(selectedCustomerType.displayName)
    }
    
    var attributedPrice: AttributedString {
        let text = AttributedString("_Pay ")
        var boldText = AttributedString(formattedAmount)
        let normalText = AttributedString(" \(currency.symbol)")
        boldText.font = .system(size: 20, weight: .bold)
        return text + boldText + normalText
    }
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: totalAmount as NSDecimalNumber) ?? "0.00"
    }
    
    var customerTypes: [String] {
        CustomerType.allCases.map { $0.displayName }
    }
    
    // MARK: - Initializer
    init() {
        loadProducts()
    }
    
    // MARK: - Data Loading
    private func loadProducts() {
        products = MockData.sampleProducts
    }
    
    // MARK: - Actions
    func selectCustomerType(_ typeName: String) {
        if let type = CustomerType.allCases.first(where: { $0.displayName == typeName }) {
            selectedCustomerType = type
            showListPopup = false
        }
    }
    
    func toggleListPopup() {
        showListPopup.toggle()
    }
    
    func toggleCurrencyPopup() {
        showCurrencyPopup.toggle()
    }
    
    func applyFilter() {
        // Implementar lógica de filtrado
        print("Applying filter...")
    }
    
    func updateTotalAmount(_ newAmount: Decimal) {
        totalAmount = newAmount
    }
    
    func updateCurrency(_ newCurrency: Currency) {
        currency = newCurrency
    }
    
    func addProduct(_ product: ProductItem) {
        productsSelected.append(product)
        recalculateTotal()
    }
    
    func removeProduct(_ product: ProductItem) {
        if let index = productsSelected.firstIndex(where: { $0.id == product.id }) {
            productsSelected.remove(at: index)
        }
        recalculateTotal()
    }
    
    func recalculateTotal() {
        // 1. suma en moneda base
        let baseTotal = productsSelected.reduce(Decimal.zero) { partial, item in
            partial + Decimal(item.basePrice)
        }
        
        // 2. aplica descuento según tipo de cliente
        let discountedBaseTotal = calculateDiscountedPrice(for: selectedCustomerType, baseAmount: baseTotal)
        
        // 3. convierte a la moneda seleccionada
        totalAmount = currency.convertFromBase(discountedBaseTotal)
    }
    
    func calculateDiscountedPrice(for customerType: CustomerType,
                                  baseAmount: Decimal? = nil) -> Decimal {
        let amount = baseAmount ?? totalAmount
        
        let discount: Decimal
        switch customerType {
        case .retail:
            discount = 0
        case .crew:
            discount = 0.15
        case .happyHour:
            discount = 0.20
        case .businessInvitation:
            discount = 0.10
        case .touristInvitation:
            discount = 0.05
        }
        
        return amount * (1 - discount)
    }
    
    func returnTotalAmountString() -> String {
        let number = totalAmount as NSDecimalNumber
        
        // Redondea a 2 decimales usando .bankers o .plain según prefieras
        let rounded = number.rounding(accordingToBehavior:
                                        NSDecimalNumberHandler(
                                            roundingMode: .plain,
                                            scale: 2,
                                            raiseOnExactness: false,
                                            raiseOnOverflow: false,
                                            raiseOnUnderflow: false,
                                            raiseOnDivideByZero: false
                                        )
        )
        
        return rounded.stringValue
    }
    
}
