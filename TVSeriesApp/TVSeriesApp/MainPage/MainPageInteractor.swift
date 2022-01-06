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
    func load() {
        delegate?.handleOutput(.setLoading(true))
        
        service.getPopularTVSeries(page: 1) { [weak self] data in
            guard let self = self, let list = data?.results else { return }
            self.delegate?.handleOutput(.setLoading(false))
            self.delegate?.handleOutput(.showList(list))
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.delegate?.handleOutput(.setLoading(false))
            print(error?.localizedDescription ?? "ERROR")
        }

    }
}
