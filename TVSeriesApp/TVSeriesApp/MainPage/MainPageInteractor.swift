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
    
    //MARK: - Initalization
    init(service: TVSeriesServiceProtocol) {
        self.service = service
    }
    
    //MARK: - Load
    func load(page: Int, segment: MainPageSegments) {
        
        switch segment {
        case .popular(_):
            delegate?.handleOutput(.setLoading(true))
            
            service.getPopularTVSeries(page: page) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case let .failure(error):
                    self.delegate?.handleOutput(.setLoading(false))
                    self.delegate?.handleOutput(.setError(error))
                case let .success(model):
                    self.delegate?.handleOutput(.setLoading(false))
                    self.delegate?.handleOutput(.showList(.popular(model.results)))
                }
            }
        case .topRated(_):
            delegate?.handleOutput(.setLoading(true))
            
            service.getTopRatedTVSeries(page: page) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case let .failure(error):
                    self.delegate?.handleOutput(.setLoading(false))
                    self.delegate?.handleOutput(.setError(error))
                case let .success(model):
                    self.delegate?.handleOutput(.setLoading(false))
                    self.delegate?.handleOutput(.showList(.topRated(model.results)))
                }
            }
        }
    }
}
