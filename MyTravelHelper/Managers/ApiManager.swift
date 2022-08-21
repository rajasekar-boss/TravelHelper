//
//  ApiManager.swift
//  MyTravelHelper
//
//  Created by Raj on 20/08/22.
//  Copyright © 2022 Sample. All rights reserved.
//

import Foundation
import XMLParsing

class ApiManager {

    enum ManagerErrors: Error {
        case invalidResponse
        case invalidStatusCode(Int)
    }

    enum HttpMethod: String {
        case get
        var method: String { rawValue.uppercased() }
    }

    func request<T: Decodable>(fromURL url: URL, httpMethod: HttpMethod = .get, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard Reach().isNetworkReachable() else {
            return completion(.failure(ManagerErrors.invalidStatusCode(-1009)))
        }

        let completionOnMain: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.method
        let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
            print("Network response: \(String(describing: response))")

            if let error = error {
                return completionOnMain(.failure(error))
            }

            guard let urlResponse = response as? HTTPURLResponse else { return completionOnMain(.failure(ManagerErrors.invalidResponse)) }
            
            if !(200..<300).contains(urlResponse.statusCode) {
                return completionOnMain(.failure(ManagerErrors.invalidStatusCode(urlResponse.statusCode)))
            }

            guard let data = data else { return }
            
            do {
                let responseData = try XMLDecoder().decode(T.self, from: data)
                completionOnMain(.success(responseData))
            } catch {
                debugPrint("The data could not be converted into the requested type. Reason: \(error)")
                completionOnMain(.failure(error))
            }
        }

        urlSession.resume()
    }
}
