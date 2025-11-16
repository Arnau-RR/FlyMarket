//
//  FlyMarketRepository.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 16/11/25.
//

import Foundation

final class FlyMarketRepository {
    
    static let shared = FlyMarketRepository()
    private init() {}
    
    // MARK: - Productos
    
    func fetchProducts(
        completion: @escaping (Result<[ProductRemote], NetworkManager.NetworkError>) -> Void
    ) {
        NetworkManager.shared.get(.products) { (result: Result<ProductsResponse, NetworkManager.NetworkError>) in
            switch result {
            case .success(let response):
                completion(.success(response.products))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Customer types / descuentos
    
    func fetchCustomerDiscounts(
        completion: @escaping (Result<[CustomerType: Double], NetworkManager.NetworkError>) -> Void
    ) {
        NetworkManager.shared.get(.customerTypes) { (result: Result<CustomerTypesResponse, NetworkManager.NetworkError>) in
            switch result {
            case .success(let response):
                var discounts: [CustomerType: Double] = [:]
                
                for remote in response.customerTypes {
                    if let type = CustomerType(rawValue: remote.name) {
                        discounts[type] = remote.discountPercentage
                    } else if let typeFromId = CustomerType(rawValue: remote.id.capitalized) {
                        discounts[typeFromId] = remote.discountPercentage
                    }
                }
                
                completion(.success(discounts))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
