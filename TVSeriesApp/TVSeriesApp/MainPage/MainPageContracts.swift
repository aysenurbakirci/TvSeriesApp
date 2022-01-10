//
//  MainPageContracts.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

import TVSeriesAPI

enum MainPageSegments {
    case popular([TVSeries]), topRated([TVSeries])
}

//MARK: - Interactor
protocol MainPageInteractorProtocol: AnyObject {
    var delegate: MainPageInteractorDelegate? { get set }
    func load(page: Int, segment: MainPageSegments)
}

enum MainPageInteractorOutput {
    case setLoading(Bool)
    case showList(MainPageSegments)
}

protocol MainPageInteractorDelegate: AnyObject {
    func handleOutput(_ output: MainPageInteractorOutput)
}

//MARK: - Presenter
protocol MainPagePresenterProtocol: AnyObject {
    func load(page: Int, segment: MainPageSegments)
}

struct MainPagePresenterOutput {
    var setLoading: Bool
    var showList: MainPageSegments
}

//MARK: - View
protocol MainPageViewProtocol: AnyObject {
    func handleOutput(_ output: MainPagePresenterOutput)
}

//MARK: - Router
enum MainPageRoute {
    case showError(_ error: Error)
}

protocol MainPageRouterProtocol: AnyObject {
    func navigate(to route: MainPageRoute)
}
