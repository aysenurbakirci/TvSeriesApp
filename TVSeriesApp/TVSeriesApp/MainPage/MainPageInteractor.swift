//
//  MainInteractor.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

/** Interactor is manipulates entities or models and fetches and stores data. **/

import TVSeriesAPI

final class MainPageInteractor: MainPageInteractorProtocol {

    //MARK: - Properties
    weak var delegate: MainPageInteractorDelegate?
    
    private let service: TVSeriesServiceProtocol
    private var tvSeries: [TVSeries] = []
    private var currentPage = 1
    private var totalPages = 1
    
    //MARK: - Initalization
    init(service: TVSeriesServiceProtocol) {
        self.service = service
    }
    
    //MARK: - Load
    func loadPopular() {
        delegate?.handleOutput(.setLoading(true))
        
        service.getPopularTVSeries(page: currentPage) { [weak self] result in
            self?.load(result: result)
        }
    }
    
    func loadTopRated() {
        delegate?.handleOutput(.setLoading(true))
        
        service.getTopRatedTVSeries(page: currentPage) { [weak self] result in
            self?.load(result: result)
        }
    }
    
    func selectTVSeries(to index: Int) {
        let selected = tvSeries[index]
        delegate?.handleOutput(.showDescription(title: selected.name,
                                                message: selected.overview))
    }
    
    func startPagination(segment: MainPageSegments) {
        guard currentPage <= totalPages else { return }
        
        switch segment {
        case .popular(_):
            loadPopular()
        case .topRated(_):
            loadTopRated()
        }
    }
    
    func resetPagination() {
        currentPage = 1
        tvSeries = []
    }
}

private extension MainPageInteractor {
    
    func calculateIndexPathsToReload(from newList: [TVSeries]) -> [IndexPath] {
        let startIndex = tvSeries.count - newList.count
        let endIndex = startIndex + newList.count
        
        return (startIndex..<endIndex).map { index in
            IndexPath(row: index, section: 0)
        }
    }
    
    func load(result: Result<APIModel, Error>) {
        switch result {
        case let .failure(error):
            self.delegate?.handleOutput(.setLoading(false))
            self.delegate?.handleOutput(.setError(error))
        case let .success(model):
            self.currentPage += 1
            self.delegate?.handleOutput(.setLoading(false))
            self.tvSeries += model.results
            self.totalPages = model.totalPages
            self.delegate?.handleOutput(.totalResult(model.totalResults))
            self.delegate?.handleOutput(.showList(self.tvSeries))
            
            if model.page > 1 {
                let indexPathsToReload = self.calculateIndexPathsToReload(from: model.results)
                self.delegate?.handleOutput(.fetchRows(indexPathsToReload))
            }
        }
    }
}
