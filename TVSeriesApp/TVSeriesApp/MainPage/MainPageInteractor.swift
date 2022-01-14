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
    
    //MARK: - Initalization
    init(service: TVSeriesServiceProtocol) {
        self.service = service
    }
    
    //MARK: - Load
    func loadPopular(to page: Int) {
        delegate?.handleOutput(.setLoading(true))
        
        service.getPopularTVSeries(page: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                self.delegate?.handleOutput(.setLoading(false))
                self.delegate?.handleOutput(.setError(error))
            case let .success(model):
                self.delegate?.handleOutput(.setLoading(false))
                self.tvSeries = model.results
                self.delegate?.handleOutput(.showList(self.tvSeries))
            }
        }
    }
    
    func loadTopRated(to page: Int) {
        delegate?.handleOutput(.setLoading(true))
        
        service.getTopRatedTVSeries(page: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .failure(error):
                self.delegate?.handleOutput(.setLoading(false))
                self.delegate?.handleOutput(.setError(error))
            case let .success(model):
                self.delegate?.handleOutput(.setLoading(false))
                self.tvSeries = model.results
                self.delegate?.handleOutput(.showList(self.tvSeries))
            }
        }
    }
    
    func selectTVSeries(to index: Int) {
        let selected = tvSeries[index]
        delegate?.handleOutput(.showDescription(title: selected.name,
                                                message: selected.overview))
    }
}
