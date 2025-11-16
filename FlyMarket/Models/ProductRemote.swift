//
//  ProductItem.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 13/11/25.
//

import Foundation

// Opcional: para filtros
enum ProductCategory: String, CaseIterable {
    case sandwiches = "Sandwiches"
    case pizzas = "Pizzas"
    case salads = "Salads"
    case sides = "Sides"
    case drinks = "Drinks"
    case pasta = "Pasta"
    case desserts = "Desserts"
    case breakfast = "Breakfast"
    case all = "All"
}

// MARK: - Remote Models (JSON)

struct ProductsResponse: Decodable {
    let products: [ProductRemote]
}

struct ProductRemote: Decodable, Identifiable {
    var id = UUID()
    let imageUrl: String
    let name: String
    let units: Int
    var basePrice: Double
    var quantity: Int = 0
    let category: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl, name, units, basePrice, category
    }
}
