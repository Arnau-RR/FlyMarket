//
//  ReceiptViewModel.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 14/11/25.
//

import SwiftUI

enum ActivePaymentOverlay {
    case cash
    case card
}

final class ReceiptViewModel: ObservableObject {
    
    // Productos del recibo
    @Published var products: [ProductRemote]
    
    @Published var currency: Currency
    
    // Asiento seleccionado
    @Published var selectedSeat: String? = nil
    
    @Published var showingSeatMap = false
    
    @Published var activePaymentOverlay: ActivePaymentOverlay? = nil
    
    init(products: [ProductRemote], currency: Currency) {
        self.products = products
        self.currency = currency
    }
    
    var totalFormatted: String {
        return Utils.totalFormatted(products: products)
    }
        
    func selectSeat(_ seat: String?) {
        selectedSeat = seat
    }
    
    func parsePrice(_ price: String) -> Double {
        return Utils.parsePrice(price)
    }
    
    func removeProducts(at indexSet: IndexSet) {
        products.remove(atOffsets: indexSet)
    }
}
