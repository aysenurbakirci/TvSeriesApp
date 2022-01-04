//
//  TVSeriesService.swift
//  TVSeriesAPI
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

import Foundation

enum ServiceError: Error {
    case URLCreationError
    case RequestFailed
    case DataTaskError(_ message: String)
    case Unknown(_ statusCode: Int)
    case Information(_ code: Int)
    case Redirection(_ code: Int)
    case ClientError(_ code: Int)
    case ServerError(_ code: Int)
}

final class TVSeriesService {
    
    private func buildRequest(api: API) throws -> URLRequest {
        var urlComponents = URLComponents()
        var queryItems: [URLQueryItem] = []
        
        urlComponents.scheme = api.schema
        urlComponents.host = api.host
        urlComponents.path += api.path
        
        api.queryItems.forEach { (name, value) in
            queryItems.append(URLQueryItem(name: name, value: value))
        }
        
        let items = urlComponents.queryItems ?? []
        queryItems.append(contentsOf: items)
        
        urlComponents.queryItems = queryItems
        
        if let url = urlComponents.url {
            return URLRequest(url: url)
        } else {
            throw ServiceError.URLCreationError
        }
    }
    
    private func load<T: Decodable>(api: API,
                                    success: @escaping (T?) -> (),
                                    failure: @escaping (Error?) -> ()) {
        
        guard let request = try? buildRequest(api: api) else {
            completion(nil, ServiceError.RequestFailed)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let error == nil else {
                failure(ServiceError.DataTaskError(error.localizedDescription))
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == 100...200 {
                    failure(ServiceError.Information(response.statusCode))
                } else if response.statusCode == 200...300 {
                    let model = try? JSONDecoder().decode(T.self, from: data)
                    success(model)
                } else if response.statusCode == 300...400 {
                    failure(ServiceError.Redirection(response.statusCode))
                } else if response.statusCode = 400...500 {
                    failure(ServiceError.ClientError(response.statusCode))
                } else if response.statusCode = 500...600 {
                    failure(ServiceError.ServerError(response.statusCode))
                } else {
                    failure(ServiceError.Unknown(response.statusCode))
                }
            }
        }
        .resume()
    }
}
