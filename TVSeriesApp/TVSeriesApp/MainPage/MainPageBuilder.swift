//
//  MainPageBuilder.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

import UIKit

final class MainPageBuilder {
    
    static func build() -> UIViewController {
        let vc = MainPageViewController()
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }
}
