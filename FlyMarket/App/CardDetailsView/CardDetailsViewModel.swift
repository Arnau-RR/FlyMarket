//
//  CardDetailsViewModel.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 14/11/25.
//

import Foundation
import Combine

final class CardDetailsViewModel: ObservableObject {
    
    // MARK: - Published fields
    @Published var cardNumber: String = "" {
        didSet { formatCardNumber() }
    }
    
    @Published var cardHolder: String = ""
    
    @Published var expiryDate: String = "" {
        didSet { formatExpiry() }
    }
    
    @Published var cvv: String = ""
    
    @Published var cardBrand: String = ""
    
    // MARK: - Computed
    /// Número sin espacios
    var rawCardNumber: String {
        cardNumber.replacingOccurrences(of: " ", with: "")
    }
    
    var isCardNumberValid: Bool {
        luhnCheck(rawCardNumber)
    }

    var isCardHolderValid: Bool {
        cardHolder.trimmingCharacters(in: .whitespaces).count > 3
    }
    
    var isExpiryValid: Bool {
        validateExpiry(expiryDate)
    }
    
    var isCVVValid: Bool {
        let trimmed = cvv.trimmingCharacters(in: .whitespaces)
        return trimmed.count >= 3 && trimmed.count <= 4 && trimmed.allSatisfy { $0.isNumber }
    }
    
    var canPay: Bool {
        isCardNumberValid &&
        isCardHolderValid &&
        isExpiryValid &&
        isCVVValid
    }
    
    // MARK: - Initializer
    init() {}
    
    // MARK: - Formatting
    
    func formatCardNumber() {
        let digits = cardNumber.filter { $0.isNumber }
        let limited = String(digits.prefix(16))
        
        var formatted = ""
        for (index, character) in limited.enumerated() {
            if index != 0 && index % 4 == 0 { formatted.append(" ") }
            formatted.append(character)
        }
        
        if formatted != cardNumber {
            cardNumber = formatted
        }
        
        detectCardBrand()
    }
    
    func formatExpiry() {
        let digits = expiryDate.filter { $0.isNumber }
        
        var result = digits
        if digits.count > 2 {
            result = "\(digits.prefix(2))/\(digits.dropFirst(2))"
        }
        
        if result.count > 5 { result = String(result.prefix(5)) }
        
        if result != expiryDate {
            expiryDate = result
        }
    }
    
    // MARK: - Validation
    
    func validateExpiry(_ value: String) -> Bool {
        let parts = value.split(separator: "/")
        guard parts.count == 2,
              let month = Int(parts[0]),
              let year = Int(parts[1]),
              (1...12).contains(month)
        else { return false }
        
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentYearShort = currentYear % 100
        let currentMonth = Calendar.current.component(.month, from: Date())
        
        let fullYear = 2000 + year
        
        if fullYear < currentYear { return false }
        if fullYear == currentYear && month < currentMonth { return false }
        
        return true
    }
    
    // Detectar Visa / Mastercard / Amex
    func detectCardBrand() {
        let n = rawCardNumber
        
        if n.hasPrefix("4") {
            cardBrand = "Visa"
        } else if (51...55).map({ String($0) }).contains(where: { n.hasPrefix($0) }) {
            cardBrand = "Mastercard"
        } else if n.hasPrefix("34") || n.hasPrefix("37") {
            cardBrand = "American Express"
        } else {
            cardBrand = ""
        }
    }
    
    // Algoritmo de Luhn
    func luhnCheck(_ number: String) -> Bool {
        guard !number.isEmpty, number.allSatisfy({ $0.isNumber }) else { return false }
        
        let reversed = number.reversed().compactMap { Int(String($0)) }
        var sum = 0
        
        for (index, digit) in reversed.enumerated() {
            if index % 2 == 1 {
                let doubled = digit * 2
                sum += doubled > 9 ? doubled - 9 : doubled
            } else {
                sum += digit
            }
        }
        
        return sum % 10 == 0
    }
    
    // MARK: - Mock Action
    
    func pay() {
        print("⚡️ Payment executed with card: \(rawCardNumber)")
    }
}
