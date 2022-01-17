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

    //MARK: - Interactor Methods
    func loadPopular() {
        interactor.loadPopular()
    }
    
    func loadTopRated() {
        interactor.loadTopRated()
    }
    
    func selectTVSeries(to index: Int) {
        interactor.selectTVSeries(to: index)
    }
    
    func startPagination(segment: MainPageSegments) {
        interactor.startPagination(segment: segment)
    }
    
    func resetPagination() {
        interactor.resetPagination()
    }
}

extension MainPagePresenter: MainPageInteractorDelegate {
    
    //MARK: - Interactor Output
    func handleOutput(_ output: MainPageInteractorOutput) {
        switch output {
        case .setLoading(let bool):
            view.handleOutput(.showLoading(bool))
        case .setError(let error):
            router.navigate(to: .showError(error))
        case .showList(let tvSeries):
            view.handleOutput(.showList(tvSeries))
        case .showDescription(title: let title, message: let message):
            router.navigate(to: .showDescription(title: title, message: message))
        case .fetchRows(let indexPaths):
            view.fetchRows(indexPaths: indexPaths)
        case .totalResult(let total):
            view.handleOutput(.reloadTableView(total))
        }
    }
}
