//
//  MainPageViewController.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

import UIKit
import TVSeriesAPI

final class MainPageViewController: UIViewController, MainPageViewProtocol {

    //MARK: Properties
    private lazy var mainView: MainPageView = {
        let view = MainPageView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.segmentControl.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
        return view
    }()
    
    private var tvSeries: [TVSeries] = []
    var presenter: MainPagePresenterProtocol!

    //MARK: - Initalization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = mainView.segmentControl
        view = mainView
        
        loadPageWithSegmentIndex(page: 1, index: mainView.segmentControl.selectedSegmentIndex)
    }
}

//MARK: - TableView Delegate, DataSource
extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tvSeries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableCell.reuseIdentifier, for: indexPath) as? ListTableCell else {
            return UITableViewCell()
        }
        
        let model = ListCellViewModel(tvSeries: tvSeries[indexPath.row])
        cell.applyModel(model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.selectTVSeries(to: indexPath.row)
    }
}

extension MainPageViewController {
    
    //MARK: - Presenter Output
    func handleOutput(_ output: MainPagePresenterOutput) {
        switch output {
        case .setLoading(let bool):
            print("Loading state is: \(bool)")
        case .setError(let error):
            print("Error is: \(error.localizedDescription)")
        case .showList(let tvSeries):
            self.tvSeries = tvSeries
            DispatchQueue.main.async {
                self.mainView.tableView.reloadData()
            }
        }
    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        loadPageWithSegmentIndex(page: 1, index: sender.selectedSegmentIndex)
    }
    
    private func loadPageWithSegmentIndex(page: Int, index: Int) {
        switch index {
        case 0:
            presenter.loadPopular(to: page)
        case 1:
            presenter.loadTopRated(to: page)
        default:
            break
        }
    }
}
