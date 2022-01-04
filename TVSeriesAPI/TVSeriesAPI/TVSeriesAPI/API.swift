//
//  ImdbAPI.swift
//  TVSeriesAPI
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

import Foundation

protocol API {
    var schema: String { get }
    var host: String { get }
    var version: String { get }
    var apiKey: URLQueryItem { get }
    var path: String { get }
    var queryItems: [String: String] { get }
}

extension API {
    
    var schema: String {
        "https"
    }
    
    var host: String {
        "api.themoviedb.org"
    }
    
    var version: String {
        "/3"
    }
    
    var apiKey: URLQueryItem {
        URLQueryItem(name: "api_key", value: "96c151da77643172f784ee17f262df9a")
    }
}

enum TVSeriesAPI: API {
    
    case topRated(page: Int), popular(page: Int)

    var path: String {
        switch self {
        case .popular(_):
            return "/tv/popular"
        case .topRated(_):
            return "/tv/top_rated"
        }
    }
    
    var queryItems: [String : String] {
        switch self {
        case .popular(let page):
            return ["page": "\(page)"]
        case .topRated(let page):
            return ["page": "\(page)"]
        }
    }
}
