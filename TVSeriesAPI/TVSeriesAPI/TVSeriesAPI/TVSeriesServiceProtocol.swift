//
//  TVSeriesServiceProtocol.swift
//  TVSeriesAPI
//
//  Created by Ayşenur Bakırcı on 6.01.2022.
//

import Foundation

public protocol TVSeriesServiceProtocol {
    func getPopularTVSeries(page: Int, success: @escaping (APIModel?) -> (), failure: @escaping (Error?) -> ())
    func getTopRatedTVSeries(page: Int, success: @escaping (APIModel?) -> (), failure: @escaping (Error?) -> ())
}
