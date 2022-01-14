//
//  MainPageBuilder.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

import UIKit
import TVSeriesAPI

final class MainPageBuilder {
    
    static func build() -> UIViewController {
        let view = MainPageViewController()
        let router = MainPageRouter(viewController: view)
        let interactor = MainPageInteractor(service: TVSeriesService())
        let presenter = MainPagePresenter(view: view,
                                          interactor: interactor,
                                          router: router)
        view.presenter = presenter
        let navigation = UINavigationController(rootViewController: view)
        return navigation
    }
}
