//
//  Currency.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 14/11/25.
//

import Foundation

enum Currency: String, CaseIterable, Identifiable {
    case eur = "EUR"
    case usd = "USD"
    case gbp = "GBP"
    
    var id: String { self.rawValue }
    
    var symbol: String {
        switch self {
        case .eur: return "€"
        case .usd: return "$"
        case .gbp: return "£"
        }
    }
    
    /// Factor para convertir desde la moneda base (EUR) a esta moneda
    var factorFromBase: Decimal {
        switch self {
        case .eur: return 1
        case .usd: return 1.08   // ejemplo
        case .gbp: return 0.86   // ejemplo
        }
    }
    
    func convertFromBase(_ amountInBase: Decimal) -> Decimal {
        return amountInBase * factorFromBase
    }
}

