//
//  ListCellViewModel.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 6.01.2022.
//

import UIKit
import TVSeriesAPI

struct ListCellViewModel {
    
    var image: UIImage?
    let title: String
    let overview: String

    init(tvSeries: TVSeries) {
        self.image = UIImage(named: "tree")
        self.title = tvSeries.name
        self.overview = "Vote: " + "\(tvSeries.voteAverage)"
    }
}
