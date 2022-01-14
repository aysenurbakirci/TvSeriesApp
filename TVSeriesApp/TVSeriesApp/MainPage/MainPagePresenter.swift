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

    //MARK: - Properties
    private unowned let view: MainPageViewProtocol
    private let interactor: MainPageInteractorProtocol
    private let router: MainPageRouterProtocol
    
    //MARK: - Initalization
    init(view: MainPageViewProtocol,
         interactor: MainPageInteractorProtocol,
         router: MainPageRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        
        self.interactor.delegate = self
    }

    //MARK: - Load
    func loadPopular(to page: Int) {
        interactor.loadPopular(to: page)
    }
    
    func loadTopRated(to page: Int) {
        interactor.loadTopRated(to: page)
    }
    
    func selectTVSeries(to index: Int) {
        interactor.selectTVSeries(to: index)
    }
}

extension MainPagePresenter: MainPageInteractorDelegate {
    
    //MARK: - Interactor Output
    func handleOutput(_ output: MainPageInteractorOutput) {
        switch output {
        case .setLoading(let bool):
            view.handleOutput(.setLoading(bool))
        case .setError(let error):
            router.navigate(to: .showError(error))
//            view.handleOutput(.setError(error))
        case .showList(let tvSeries):
            view.handleOutput(.showList(tvSeries))
        case .showDescription(title: let title, message: let message):
            router.navigate(to: .showDescription(title: title, message: message))
        }
    }
}
