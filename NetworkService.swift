//
//  NetworkService.swift
//  WebViewCommucation
//
//  Created by ranjith kumar reddy b perkampally on 11/14/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case encodingError
    case serverError(Int)
}

struct NetworkService {
    static func request<T: Decodable, U: Encodable>(
        urlString: String,
        method: HTTPMethod,
        parameters: U? = nil,  // Make parameters optional
        headers: [String: String]? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Add headers if any
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Encode parameters if any for POST or PUT requests
        if let parameters = parameters, method == .post || method == .put {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                request.httpBody = try JSONEncoder().encode(parameters)
            } catch {
                completion(.failure(.encodingError))
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network Error: \(error)")
                completion(.failure(.noData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }
            
            if (200...299).contains(httpResponse.statusCode) {
                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    print("Decoding Error: \(error)")
                    completion(.failure(.decodingError))
                }
            } else {
                completion(.failure(.serverError(httpResponse.statusCode)))
            }
        }
        task.resume()
    }
}


//struct NetworkService {
//    static func request<T: Decodable, U: Encodable>(
//        urlString: String,
//        method: HTTPMethod,
//        parameters: U? = nil,
//        headers: [String: String]? = nil,
//        completion: @escaping (Result<T, NetworkError>) -> Void
//    ) {
//        guard let url = URL(string: urlString) else {
//            completion(.failure(.invalidURL))
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//        
//        // Add headers if any
//        if let headers = headers {
//            for (key, value) in headers {
//                request.setValue(value, forHTTPHeaderField: key)
//            }
//        }
//        
//        // Encode parameters if any for POST or PUT requests
//        if let parameters = parameters, method == .post || method == .put {
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            do {
//                request.httpBody = try JSONEncoder().encode(parameters)
//            } catch {
//                completion(.failure(.encodingError))
//                return
//            }
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Network Error: \(error)")
//                completion(.failure(.noData))
//                return
//            }
//            
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(.failure(.noData))
//                return
//            }
//            
//            if (200...299).contains(httpResponse.statusCode) {
//                guard let data = data else {
//                    completion(.failure(.noData))
//                    return
//                }
//                
//                do {
//                    let decodedData = try JSONDecoder().decode(T.self, from: data)
//                    completion(.success(decodedData))
//                } catch {
//                    print("Decoding Error: \(error)")
//                    completion(.failure(.decodingError))
//                }
//            } else {
//                completion(.failure(.serverError(httpResponse.statusCode)))
//            }
//        }
//        task.resume()
//    }
//}
