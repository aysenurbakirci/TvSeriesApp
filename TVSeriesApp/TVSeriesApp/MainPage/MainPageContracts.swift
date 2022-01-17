//
//  MainPageContracts.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

import TVSeriesAPI

//MARK: - Interactor
protocol MainPageInteractorProtocol: AnyObject {
    var delegate: MainPageInteractorDelegate? { get set }
    func loadPopular()
    func loadTopRated()
    func selectTVSeries(to index: Int)
    func startPagination(segment: MainPageSegments)
    func resetPagination()
}

enum MainPageInteractorOutput {
    case setLoading(Bool)
    case setError(Error)
    case showList([TVSeries])
    case showDescription(title: String, message: String)
}

protocol MainPageInteractorDelegate: AnyObject {
    func handleOutput(_ output: MainPageInteractorOutput)
}

//MARK: - Presenter
protocol MainPagePresenterProtocol: AnyObject {
    func loadPopular()
    func loadTopRated()
    func selectTVSeries(to index: Int)
    func startPagination(segment: MainPageSegments)
    func resetPagination()
}

enum MainPagePresenterOutput {
    case showLoading(Bool)
    case showList([TVSeries])
}

//MARK: - View
protocol MainPageViewProtocol: AnyObject {
    func handleOutput(_ output: MainPagePresenterOutput)
}

//MARK: - Router
enum MainPageRoute {
    case showError(_ error: Error)
    case showDescription(title: String, message: String)
}

protocol MainPageRouterProtocol: AnyObject {
    func navigate(to route: MainPageRoute)
}
