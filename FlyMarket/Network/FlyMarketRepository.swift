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
    
    func fetchAllCustomerTypes(
            completion: @escaping (Result<[CustomerTypeRemote],  NetworkManager.NetworkError>) -> Void
        ) {
            NetworkManager.shared.get(.customerTypes) { (result: Result<CustomerTypesResponse, NetworkManager.NetworkError>) in
                switch result {
                case .success(let response):
                    completion(.success(response.customerTypes))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}
