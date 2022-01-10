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

    //MARK: - Load
    func load(page: Int) {
        
    }
}

extension MainPagePresenter: MainPageInteractorDelegate {
    
    //MARK: - Interactor Output
    func handleOutput(_ output: MainPageInteractorOutput) {
        
    }
}
