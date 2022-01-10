//
//  TVSeriesServiceProtocol.swift
//  TVSeriesAPI
//
//  Created by Ayşenur Bakırcı on 6.01.2022.
//

public protocol TVSeriesServiceProtocol {
    func getPopularTVSeries(page: Int, completion: @escaping (Result<APIModel, Error>) -> ())
    func getTopRatedTVSeries(page: Int, completion: @escaping (Result<APIModel, Error>) -> ())
}
