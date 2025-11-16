//
//  CustomerType.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 16/11/25.
//

import Foundation

struct CustomerTypesResponse: Decodable {
    let customerTypes: [CustomerTypeRemote]
}

struct CustomerTypeRemote: Decodable {
    let id: String
    let name: String
    let discountPercentage: Double
}
