//
//  CashPaymentViewModel.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 14/11/25.
//


import SwiftUI
import Combine

final class CashPaymentViewModel: ObservableObject {
    @Published var amountDue: Decimal
    @Published var cashReceivedText: String = ""
    
    @Published private(set) var cashReceived: Decimal = 0
    @Published private(set) var change: Decimal = 0
    @Published private(set) var remaining: Decimal = 0
    @Published private(set) var isEnoughCash: Bool = false
    
    private let formatter: NumberFormatter
    
    init(amountDue: Decimal) {
        self.amountDue = amountDue
        
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "EUR"
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 2
        self.formatter = f
        
        recalculate()
    }
    
    func formattedAmount(_ value: Decimal) -> String {
        formatter.string(from: value as NSDecimalNumber) ?? "€0.00"
    }
    
    func onCashReceivedChange() {
        // Permitir coma o punto como separador
        let normalized = cashReceivedText.replacingOccurrences(of: ",", with: ".")
        
        if let value = Decimal(string: normalized) {
            cashReceived = value
        } else {
            cashReceived = 0
        }
        
        recalculate()
    }
    
    private func recalculate() {
        if cashReceived >= amountDue {
            isEnoughCash = true
            change = cashReceived - amountDue
            remaining = 0
        } else {
            isEnoughCash = false
            change = 0
            remaining = amountDue - cashReceived
        }
    }
}
