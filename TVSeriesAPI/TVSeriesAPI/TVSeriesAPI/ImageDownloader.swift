//
//  ImageDownloader.swift
//  TVSeriesAPI
//
//  Created by Ayşenur Bakırcı on 11.01.2022.
//

import Foundation
import UIKit


final public class ImageDownloader {
    
    private func buildRequest(imagePath: String) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "image.tmdb.org"
        urlComponents.path = "/t/p/w500" + imagePath
        
        if let url = urlComponents.url {
            print("URL: \(url)")
            return URLRequest(url: url)
        } else {
            throw ServiceError.urlCreationError
        }
    }
    
    func downloader(imagePath: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        guard let request = try? buildRequest(imagePath: imagePath) else {
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(ServiceError.dataTaskError(error?.localizedDescription ?? "Error")))
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse {
                if (200...299).contains(response.statusCode) {
                    guard let image = UIImage(data: data) else {
                        completion(.failure(ServiceError.decodeError))
                        return
                    }
                    completion(.success(image))
                } else {
                    completion(.failure(ServiceError.decideError(response.statusCode)))
                }
            }
        }
        .resume()
    }
}
