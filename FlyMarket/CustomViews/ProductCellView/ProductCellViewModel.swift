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
    @Published var product: ProductRemote
    @Published var currency: Currency
    
    init(
        product: ProductRemote,
        currency: Currency,
    ) {
        self.product = product
        self.currency = currency
    }
    
    func showPriceWithCurrency() -> String {
        let number = NSDecimalNumber(value: product.basePrice)

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
        
        return rounded.stringValue + currency.symbol
    }
    
    func returnProductQuantity() -> Int{
        return product.quantity
    }
    
//    func increment() {
//        product.quantity += 1
//    }
//    
//    func decrement() {
//        if product.quantity > 0 {
//            product.quantity -= 1
//        }
//    }
}
