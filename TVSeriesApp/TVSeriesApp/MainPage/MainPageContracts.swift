//
//  MainPageContracts.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

import TVSeriesAPI

enum MainPageSegments {
    //Use CaseIterable
    case popular([TVSeries]), topRated([TVSeries])
    
    static var allCases = ["Popular", "Top Rated"]
    static var selectedSegment = 0
}

//MARK: - Interactor
protocol MainPageInteractorProtocol: AnyObject {
    var delegate: MainPageInteractorDelegate? { get set }
    func loadPopular(to page: Int)
    func loadTopRated(to page: Int)
    func selectTVSeries(to index: Int)
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
    func loadPopular(to page: Int)
    func loadTopRated(to page: Int)
    func selectTVSeries(to index: Int)
}

enum MainPagePresenterOutput {
    case setLoading(Bool)
    case setError(Error)
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
