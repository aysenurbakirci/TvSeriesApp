//
//  MainPageViewController.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

import UIKit

final class MainPageViewController: UIViewController, MainPageViewProtocol {

    //MARK: Properties
    private lazy var mainView: MainPageView = {
        let view = MainPageView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        return view
    }()

    //MARK: - Initalization
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = mainView.segmentControl
        view = mainView
    }
}

//MARK: - TableView Delegate, DataSource
extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableCell.reuseIdentifier, for: indexPath) as? ListTableCell else {
            return UITableViewCell()
        }
        return cell
    }
}

extension MainPageViewController {
    
    //MARK: - Presenter Output
    func handleOutput(_ output: MainPagePresenterOutput) {
        
    }
}
