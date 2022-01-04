//
//  TVSeriesService.swift
//  TVSeriesAPI
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

import Foundation

public enum ServiceError: Error {
    case URLCreationError
    case RequestFailed
    case DataTaskError(_ message: String)
    case Unknown(_ statusCode: Int)
    case Information(_ code: Int)
    case Redirection(_ code: Int)
    case ClientError(_ code: Int)
    case ServerError(_ code: Int)
}

final public class TVSeriesService {
    
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
            throw ServiceError.URLCreationError
        }
    }
    
    private func load<T: Decodable>(api: API,
                                    model: T.Type,
                                    success: @escaping (T?) -> (),
                                    failure: @escaping (Error?) -> ()) {
        
        guard let request = try? buildRequest(api: api) else {
            failure(ServiceError.RequestFailed)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                failure(ServiceError.DataTaskError(error?.localizedDescription ?? "Error"))
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                if (100...199).contains(response.statusCode) {
                    failure(ServiceError.Information(response.statusCode))
                } else if (200...299).contains(response.statusCode) {
                    let model = try? JSONDecoder().decode(T.self, from: data)
                    success(model)
                } else if (300...399).contains(response.statusCode) {
                    failure(ServiceError.Redirection(response.statusCode))
                } else if (400...499).contains(response.statusCode) {
                    failure(ServiceError.ClientError(response.statusCode))
                } else if (500...599).contains(response.statusCode) {
                    failure(ServiceError.ServerError(response.statusCode))
                } else {
                    failure(ServiceError.Unknown(response.statusCode))
                }
            }
        }
        .resume()
    }
}

public extension TVSeriesService {
    
    static func getPopularTVSeries(page: Int, success: @escaping (Decodable?) -> (), failure: @escaping (Error?) -> ()) {
        let service = TVSeriesService()
        
        service.load(api: TVSeriesAPI.popular(page: page), model: TvSeries.self) { data in
            success(data)
        } failure: { error in
            failure(error)
        }
    }
    
    static func getTopRatedTVSeries(page: Int, success: @escaping (Decodable?) -> (), failure: @escaping (Error?) -> ()) {
        let service = TVSeriesService()
        
        service.load(api: TVSeriesAPI.topRated(page: page), model: TvSeries.self) { data in
            success(data)
        } failure: { error in
            failure(error)
        }
    }
}
