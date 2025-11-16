//
//  ProductItem.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 13/11/25.
//

import Foundation

// MARK: - Models
struct ProductItem: Identifiable, Hashable {
    let id = UUID()
    let imageUrl: String
    let name: String
    let units: Int
    let basePrice: Double
    var quantity: Int = 0
    
//    func price(for currency: Currency) -> Decimal {
//            currency.convertFromBase(basePrice)
//        }
    
    // Inicializador principal usando Decimal
    init(imageUrl: String, name: String, units: Int, basePrice: Double) {
        self.imageUrl = imageUrl
        self.name = name
        self.units = units
        self.basePrice = basePrice
    }
}

