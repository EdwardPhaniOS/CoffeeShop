//
//  Webservice.swift
//  CoffeeShop
//
//  Created by Tan Vinh Phan on 4/28/20.
//  Copyright © 2020 PTV. All rights reserved.
//

import Foundation

enum NetworkErrors: Error {
    case decodingError
    case urlError
    case domainError
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
}

//
//MARK: - Resource
//
struct Resource<T: Codable> {
    let url: URL
    var httpMethod: HttpMethod = .get
    var body: Data? = nil
}

extension Resource {
    init(url: URL) {
        self.url = url
    }
}

//
//MARK: - Webservice
//
struct Webservice {

    func load<T>(resource: Resource<T>, completion: @escaping (Result<T, NetworkErrors>) -> Void){
        
        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue
        request.httpBody = resource.body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in

            guard let safeData = data, error == nil else {
                completion(.failure(.domainError))
                return
            }

            let orders = try? JSONDecoder().decode(T.self, from: safeData)

            if let safeOrders = orders {
                DispatchQueue.main.async {
                    completion(.success(safeOrders))
                }
            } else {
                completion(.failure(.decodingError))
            }
        }

        dataTask.resume()

    }
}
