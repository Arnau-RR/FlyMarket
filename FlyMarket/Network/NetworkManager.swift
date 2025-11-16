//
//  NetworkManager.swift
//  FlyMarket
//
//  Created by Arnau Rivas Rivas on 16/11/25.
//

import Foundation
import Alamofire

// Qué "DB" quiero consultar
enum FlyMarketEndpoint {
    case products
    case customerTypes
    
    var path: String {
        switch self {
        case .products:
            return "products.json"
        case .customerTypes:
            return "customerTypes.json"
        }
    }
}

final class NetworkManager {
    
    // MARK: - Singleton
    static let shared = NetworkManager()
    private init() {}
    
    // MARK: - Properties
    /// JSON alojados en el repo FlyMarketBD
    private let baseURL = "https://raw.githubusercontent.com/Arnau-RR/FlyMarketBD/master/"
    
    private let session: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 20
        config.timeoutIntervalForResource = 20
        return Session(configuration: config)
    }()
    
    // MARK: - Tipos de respuesta
    enum NetworkError: Error {
        case noData
        case decoding(Error)
        case server(String)
        case unknown
    }
    
    // MARK: - Helper principal
    private func request<T: Decodable>(
        _ method: HTTPMethod,
        _ endpoint: String,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let url = baseURL + endpoint
        
        session.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        .validate()
        .responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let decoded):
                completion(.success(decoded))
                
            case .failure(let afError):
                if let data = response.data,
                   let errorMsg = String(data: data, encoding: .utf8) {
                    completion(.failure(.server(errorMsg)))
                } else {
                    completion(.failure(.unknown))
                }
                print("❌ AF Error:", afError.localizedDescription)
            }
        }
    }
    
    // MARK: - Métodos públicos
    
    /// Versión cruda con String
    func get<T: Decodable>(
        _ endpoint: String,
        parameters: Parameters? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        request(
            .get,
            endpoint,
            parameters: parameters,
            encoding: URLEncoding.default,
            completion: completion
        )
    }
    
    /// Versión usando el enum FlyMarketEndpoint
    func get<T: Decodable>(
        _ endpoint: FlyMarketEndpoint,
        parameters: Parameters? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        request(
            .get,
            endpoint.path,
            parameters: parameters,
            encoding: URLEncoding.default,
            completion: completion
        )
    }
    
    func post<T: Decodable>(
        _ endpoint: String,
        parameters: Parameters? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        request(
            .post,
            endpoint,
            parameters: parameters,
            encoding: JSONEncoding.default,
            completion: completion
        )
    }
}
