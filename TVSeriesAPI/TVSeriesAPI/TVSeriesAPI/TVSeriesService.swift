//
//  TVSeriesService.swift
//  TVSeriesAPI
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

import Foundation

public protocol TVSeriesServiceProtocol {
    func getPopularTVSeries(page: Int, completion: @escaping (Result<APIModel, Error>) -> ())
    func getTopRatedTVSeries(page: Int, completion: @escaping (Result<APIModel, Error>) -> ())
}

final public class TVSeriesService {
    
    public init() {}
    
    private func buildRequest(api: API) throws -> URLRequest {
        var urlComponents = URLComponents()
        var queryItems: [URLQueryItem] = []
        
        urlComponents.scheme = api.schema
        urlComponents.host = api.host
        urlComponents.path += api.version
        urlComponents.path += api.path
        
        queryItems.append(api.apiKey)
        
        api.queryItems.forEach { (name, value) in
            queryItems.append(URLQueryItem(name: name, value: value))
        }
        
        let items = urlComponents.queryItems ?? []
        queryItems.append(contentsOf: items)
        
        urlComponents.queryItems = queryItems
        
        if let url = urlComponents.url {
            print("URL: \(url)")
            return URLRequest(url: url)
        } else {
            throw ServiceError.urlCreationError
        }
    }
    
    private func load<T: Decodable>(_ tType: T.Type,
                                    api: API,
                                    completion: @escaping (Result<T, Error>) -> ()) {
        
        guard let request = try? buildRequest(api: api) else {
            completion(.failure(ServiceError.requestFailed))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(ServiceError.dataTaskError(error?.localizedDescription ?? "Error")))
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                if (200...299).contains(response.statusCode) {
                    guard let model = try? JSONDecoder().decode(T.self, from: data) else {
                        completion(.failure(ServiceError.decodeError))
                        return
                    }
                    completion(.success(model))
                } else {
                    completion(.failure(ServiceError.decideError(response.statusCode)))
                }
            }
        }
        .resume()
    }
}

extension TVSeriesService: TVSeriesServiceProtocol {
    
    public func getPopularTVSeries(page: Int, completion: @escaping (Result<APIModel, Error>) -> ()) {
        load(APIModel.self, api: TVSeriesAPI.popular(page: page)) { result in
            completion(result)
        }
    }
    
    public func getTopRatedTVSeries(page: Int, completion: @escaping (Result<APIModel, Error>) -> ()) {
        load(APIModel.self, api: TVSeriesAPI.topRated(page: page)) { result in
            completion(result)
        }
    }
}
