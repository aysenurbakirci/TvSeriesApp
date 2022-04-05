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
    let vote: String

    init(_ record: ImageRecord) {
        self.image = record.image
        self.title = record.model.name
        self.vote = "Vote: " + "\(record.model.voteAverage)"
    }
}
