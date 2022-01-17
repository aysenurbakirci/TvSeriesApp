//
//  MainRouter.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

/** Router is andles navigation in the module or application.
 It creates the View and wires the Presenter to act as output to the Interactor.
 Contacts the Presenter in order to route requests. **/

import Foundation
import UIKit

final class MainPageRouter: MainPageRouterProtocol {
    
    //MARK: - Properties
    unowned let viewController: UIViewController
    
    //MARK: - Initalization
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    //MARK: - Navigation
    func navigate(to route: MainPageRoute) {
        switch route {
        case .showError(let error):
            makeAlert(title: "Error!", message: error.localizedDescription)
        case .showDescription(let title, let message):
            makeAlert(title: title, message: message)
        }
    }
}

extension MainPageRouter {
    
    private func makeAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
