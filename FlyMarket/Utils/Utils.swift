//
//  Utils.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 14/11/25.
//

import Foundation
import SwiftUI


struct Utils {
    
    // MARK: - Price Utils
    // Helpers relacionados con el manejo de precios: parseo, formateo y cálculo de totales.
    
    /// Parsea un string de precio tipo "19,99 €" y devuelve un Double (19.99)
    static func parsePrice(_ price: String) -> Double {
        var clean = price
            .replacingOccurrences(of: "€", with: "")
            .replacingOccurrences(of: "$", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        clean = clean.replacingOccurrences(of: ",", with: ".")
        return Double(clean) ?? 0.0
    }
    
    /// Calcula el total en función de price y counter de cada producto
    /// Calcula el total en función de price y counter de cada producto
    static func totalFormatted(products: [ProductRemote]) -> String {
        let total = products.reduce(into: 0.0) { partial, item in
            let unitPrice = item.basePrice            // <- ahora es Double
            let count = item.units                // <- ahora es Int
            partial += unitPrice * Double(count)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        
        return formatter.string(from: NSNumber(value: total)) ?? "0,00 €"
    }
}

struct buttonBlackWhiteStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(
                LinearGradient(
                    colors: [Color.black, Color(.darkGray)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(14)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

