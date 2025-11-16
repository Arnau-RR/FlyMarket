//
//  ProductCellViewModel.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 13/11/25.
//

import Foundation
import SwiftUI

enum QuantityChange {
    case increment
    case decrement
}

final class ProductCellViewModel: ObservableObject {
    @Published var product: ProductItem
    @Published var currency: Currency
    @Published var quantity: Int
    
    init(
        product: ProductItem,
        currency: Currency,
        initialQuantity: Int = 0
    ) {
        self.product = product
        self.currency = currency
        self.quantity = initialQuantity
    }
    
    func showPriceWithCurrency() -> String {
        return String(product.basePrice) + currency.symbol
    }
    
    func increment() {
        quantity += 1
    }
    
    func decrement() {
        if quantity > 0 {
            quantity -= 1
        }
    }
}
