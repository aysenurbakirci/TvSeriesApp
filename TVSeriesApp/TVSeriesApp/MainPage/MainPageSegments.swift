//
//  MainPageSegments.swift
//  TVSeriesApp
//
//  Created by Ayşe Nur Bakırcı on 17.01.2022.
//

import TVSeriesAPI

enum MainPageSegments: CaseIterable {
    static var allCases: [MainPageSegments] {
        return [.popular([]), .topRated([])]
    }
    case popular([TVSeries]), topRated([TVSeries])
    
    var caseTitle: String {
        switch self {
        case .popular(_):
            return "Popular"
        case .topRated(_):
            return "Top Rated"
        }
    }
    
    static func segmentControlItems() -> [String] {
        var items: [String] = []
        MainPageSegments.allCases.forEach { segment in
            items.append(segment.caseTitle)
        }
        return items
    }
}
