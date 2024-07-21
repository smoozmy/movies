//
//  RestApiClient.swift
//  movies
//
//  Created by Александр Крапивин on 21.07.2024.
//

import Foundation

enum NetworkError: Error {
    case unknown
    case invalidMimeType
    case invalidStatusCode
    case client
    case server
    case emptyData
    case invalidURL
}

class RestApiClient {
    private let urlSession = URLSession.shared
    
    func performRequest(_ request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        urlSession.dataTask(with: request) { [weak self] data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            if let error = self?.validate(response: response) {
                completion(.failure(error))
                return
            }
            
            guard let data else {
                completion(.failure(NetworkError.emptyData))
                return
            }
            
            completion(.success(data))
            
        }.resume()
    }
    
    private func validate(response: URLResponse?) -> Error? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return NetworkError.unknown
        }
        
        guard httpResponse.mimeType == "application/json" else {
            return NetworkError.invalidMimeType
        }
        
        switch httpResponse.statusCode {
        case 100..<200, 300..<400:
            return NetworkError.invalidStatusCode
        case 400..<500:
            return NetworkError.client
        case 500..<600:
            return NetworkError.server
        default:
            break
        }
        
        return nil
    }
    
}
