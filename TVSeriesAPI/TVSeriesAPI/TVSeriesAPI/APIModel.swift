//
//  TVSeriesModel.swift
//  TVSeriesAPI
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

import Foundation

// MARK: - TvSeries
public struct APIModel: Codable {
    public let page: Int
    public let results: [TVSeries]
    public let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}

// MARK: - Result
public struct TVSeries: Codable {
    let id: Int
    public let name: String
    public let overview: String
    public let posterPath: String
    public let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
}
