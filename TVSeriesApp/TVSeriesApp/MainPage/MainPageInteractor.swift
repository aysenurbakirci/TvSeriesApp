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
    private var tvSeries: [ImageRecord] = []
    
    //MARK: - Initalization
    init(service: TVSeriesServiceProtocol) {
        self.service = service
    }
    
    //MARK: - Load
    func loadPopular() {
        tvSeries.removeAll()
        delegate?.handleOutput(.setLoading(true))
        service.getPopularTVSeries(page: 1) { [weak self] result in
            self?.load(result: result)
        }
    }
    
    func loadTopRated() {
        tvSeries.removeAll()
        delegate?.handleOutput(.setLoading(true))
        service.getTopRatedTVSeries(page: 1) { [weak self] result in
            self?.load(result: result)
        }
    }
    
    func selectTVSeries(to index: Int) {
        let selected = tvSeries[index]
        delegate?.handleOutput(.showDescription(title: selected.model.name,
                                                message: selected.model.overview))
    }
}

private extension MainPageInteractor {
    
    func load(result: Result<[ImageRecord], Error>) {
        switch result {
        case let .failure(error):
            self.delegate?.handleOutput(.setLoading(false))
            self.delegate?.handleOutput(.setError(error))
        case let .success(model):
            self.delegate?.handleOutput(.setLoading(false))
            self.tvSeries += model
            self.delegate?.handleOutput(.showList(self.tvSeries))
        }
    }
}
