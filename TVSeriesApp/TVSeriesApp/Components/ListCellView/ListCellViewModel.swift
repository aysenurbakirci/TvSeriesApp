//
//  ListCellViewModel.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 6.01.2022.
//

import UIKit
import struct TVSeriesAPI.TVSeries

struct ListCellViewModel {
    
    let image: UIImage
    let title: String
    let overview: String

    init(tvSeries: TVSeries) {
        self.image = tvSeries.posterPath
        guard let image =
        self.title = tvSeries.name
        self.overview = tvSeries.overview
    }
    
    private func fetchImage(_ path: String) {
        
    }
}
