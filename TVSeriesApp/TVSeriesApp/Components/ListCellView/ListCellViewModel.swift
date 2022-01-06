//
//  ListCellViewModel.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 6.01.2022.
//

import Foundation
import UIKit

struct ListCellViewModel {
    
    let image: UIImage
    let title: String
    let overview: String
    
    init(image: UIImage, title: String, description: String) {
        self.image = image
        self.title = title
        self.overview = description
    }
}
