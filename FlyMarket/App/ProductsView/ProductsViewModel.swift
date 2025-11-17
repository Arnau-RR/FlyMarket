//
//  ProductsViewModel.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 15/11/25.
//

import SwiftUI
import Combine

// MARK: - ViewModel
@MainActor
class ProductsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var products: [ProductRemote] = []
    @Published var productsWithDiscounts: [ProductRemote] = []
    @Published var customerTypes: [CustomerTypeRemote] = []
    @Published var selectedCustomerType: CustomerTypeRemote = CustomerTypeRemote(id: "", name: "", discountPercentage: 0.0) {
        didSet {
            recalculatePriceEachProductByType()
        }
    }
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
    @Published var productsSelected: [ProductRemote] = []
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Computed Properties
    var selectedSaleTypeAttributed: AttributedString {
        AttributedString(selectedCustomerType.name)
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
    
    var getAllCustomerTypesNames: [String] {
        customerTypes.map { $0.name }
    }
    
    // MARK: - Initializer
    init() {
        self.loadProducts()
        self.loadCustomerTypes()
    }
    
    //    // MARK: - Data Loading
    //    private func loadProducts() {
    //        products = MockData.sampleProducts
    //    }
    
    private func loadProducts() {
        isLoading = true
        errorMessage = nil
        
        FlyMarketRepository.shared.fetchProducts { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let remoteProducts):
                    self.products = remoteProducts
                    self.productsWithDiscounts = remoteProducts
                case .failure(let error):
                    print("Error fetching products: \(error)")
                    self.products = []
                    self.errorMessage = "Error fetching products: \(error)"
                    print(error)
                }
            }
        }
    }
    
    private func loadCustomerTypes() {
        isLoading = true
        errorMessage = nil
        
        FlyMarketRepository.shared.fetchAllCustomerTypes { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let allCustomerTypes):
                    self.customerTypes = allCustomerTypes
                    self.selectedCustomerType = allCustomerTypes.first ?? MockData.mockCustomerTypes.first!
                case .failure(let error):
                    print("Error fetching customer types: \(error)")
                    self.products = []
                    self.errorMessage = "Error fetching products: \(error)"
                    print(error)
                }
            }
        }
        
    }
    
    // MARK: - Actions
    func selectCustomerType(_ typeName: String) {
        if let type = customerTypes.first(where: { $0.name == typeName }) {
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
    
    func addProduct(_ product: ProductRemote) {
        // Buscar si el producto ya existe en el array
        if let index = productsSelected.firstIndex(where: { $0.id == product.id }) {
            // Si existe, incrementar la cantidad
            productsSelected[index].quantity += 1
            
            if let index1 = productsWithDiscounts.firstIndex(where: { $0.id == product.id }) {
                productsWithDiscounts[index1].quantity += 1
            }
            
        } else {
            // Si no existe, crear una copia del producto con cantidad 1 y agregarlo
            var productSelected = product
            productSelected.quantity = 1
            productsSelected.append(productSelected)
            
            if let index = productsWithDiscounts.firstIndex(where: { $0.id == product.id }) {
                productsWithDiscounts[index].quantity = 1
            }
        }
        
        recalculateTotal()
    }
    
    func removeProduct(_ product: ProductRemote) {
        if let index = productsSelected.firstIndex(where: { $0.id == product.id }) {
            // Si la cantidad es mayor a 1, solo decrementar
            if productsSelected[index].quantity > 1 {
                productsSelected[index].quantity -= 1
                
                if let index1 = productsWithDiscounts.firstIndex(where: { $0.id == product.id }) {
                    productsWithDiscounts[index1].quantity -= 1
                }
            } else {
                // Si la cantidad es 1, eliminar el producto completamente
                productsSelected.remove(at: index)
                if let index = productsWithDiscounts.firstIndex(where: { $0.id == product.id }) {
                    productsWithDiscounts[index].quantity = 0
                }
            }
        }
        
        recalculateTotal()
    }
    
    func selectCustomerType(item: String) {
        if let found = self.customerTypes.first(where: { $0.name == item }) {
            self.selectedCustomerType = found
        }
    }
    
    func recalculatePriceEachProductByType() {
        for i in products.indices {
            let originalPrice = Decimal(products[i].basePrice)
            
            let discountedPrice = calculateDiscountedPrice(
                for: selectedCustomerType,
                baseAmount: originalPrice
            )
            
            let convertedPrice = currency.convertFromBase(discountedPrice)
            
            productsWithDiscounts[i].basePrice = NSDecimalNumber(decimal: convertedPrice).doubleValue
        }
    }
    
    
    func recalculateTotal() {
        // 1. Suma en moneda base multiplicando precio por cantidad
        let baseTotal = productsSelected.reduce(Decimal.zero) { partial, item in
            partial + (Decimal(item.basePrice) * Decimal(item.quantity))
        }
        
        // 3. Convierte a la moneda seleccionada
        totalAmount = currency.convertFromBase(baseTotal)
    }
    
    
    func calculateDiscountedPrice(for customerType: CustomerTypeRemote,
                                  baseAmount: Decimal? = nil) -> Decimal {
        let amount = baseAmount ?? totalAmount
        
        let discount = Decimal(customerType.discountPercentage) / 100
        
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
    
    func getReceiptProductsUpdated(updateProducts: [ProductRemote]) {
        self.productsSelected = updateProducts
        
        for product in updateProducts {
            if let index = productsWithDiscounts.firstIndex(where: { $0.id == product.id }) {
                //productsWithDiscounts[index].quantity = qu
            }
        }
    }
    
}
