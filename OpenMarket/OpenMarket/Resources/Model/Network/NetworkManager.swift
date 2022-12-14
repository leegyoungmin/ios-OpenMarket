//
//  NetworkManager.swift
//  OpenMarket
//
//  Copyright (c) 2022 Minii All rights reserved.

import Foundation

enum NetworkError: Error {
    case invalidStatusCode
    case canNotDecodeData
}

struct NetworkManager {
    func fetchData<T: Decodable>(
        endPoint: TargetAPI,
        model: T.Type,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        guard let request = endPoint.generateRequest() else { return }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...300) ~= response.statusCode else {
                completion(.failure(.invalidStatusCode))
                return
            }
            
            guard let data = data,
                  let decodeString = try? String(data: data, encoding: .utf8) else {
                completion(.failure(.canNotDecodeData))
                return
            }
            
            // TODO: - Json Decoding Type 생성후 JsonDecoder 적용하기
//            guard let data = data,
//                  let decodeData = try? JSONDecoder().decode(model, from: data) else {
//                completion(.failure(.canNotDecodeData))
//                return
//            }
            
            completion(.success(decodeString))
        }
        
        task.resume()
    }
}
