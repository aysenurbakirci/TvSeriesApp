//
//  MainPresenter.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

/** Presenter is contains the user interface and prepares data for presentation.
 The Presenter contacts the Interactor for data requests,
 the View to present prepared data to the user and the Router in order to hand off objects. **/

import Foundation

final class MainPagePresenter: MainPagePresenterProtocol {
    
    private unowned let view: MainPageViewProtocol
    private let interactor: MainPageInteractorProtocol
    private let router: MainPageRouterProtocol
    
    init(view: MainPageViewProtocol,
         interactor: MainPageInteractorProtocol,
         router: MainPageRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        self.interactor.delegate = self
    }

    //MARK: - Load
    func load(page: Int) {
        interactor.load(page: page)
    }
}

extension MainPagePresenter: MainPageInteractorDelegate {
    
    //MARK: - Interactor Output
    func handleOutput(_ output: MainPageInteractorOutput) {
        switch output {
        case .setLoading(let bool):
            view.handleOutput(.setLoading(bool))
        case .setError(let error):
            view.handleOutput(.setError(error))
        case .showList(let mainPageSegments):
            view.handleOutput(.showList(mainPageSegments))
        }
    }
}
