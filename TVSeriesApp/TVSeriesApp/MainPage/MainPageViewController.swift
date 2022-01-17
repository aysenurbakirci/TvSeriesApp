//
//  MainPageViewController.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

import UIKit
import TVSeriesAPI

final class MainPageViewController: UIViewController {

    //MARK: Properties
    private lazy var mainView: MainPageView = {
        let view = MainPageView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.prefetchDataSource = self
        view.segmentControl.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
        return view
    }()
    
    private var tvSeries: [TVSeries] = []
    private var loadStatement: Bool = false
    private var totalResults = 1
    
    var presenter: MainPagePresenterProtocol!

    //MARK: - Initalization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = mainView.segmentControl
        view = mainView
        
        loadPageWithSegmentIndex(index: mainView.segmentControl.selectedSegmentIndex)
    }
}

//MARK: - TableView Delegate, DataSource
extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalResults
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableCell.reuseIdentifier, for: indexPath) as? ListTableCell else {
            return UITableViewCell()
        }
        
        if isLoadingCell(for: indexPath) {
            cell.applyModel(.none)
        } else {
            let model = ListCellViewModel(tvSeries: tvSeries[indexPath.row])
            cell.applyModel(model)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isLoadingCell(for: indexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            presenter.selectTVSeries(to: indexPath.row)
        }
    }
}

extension MainPageViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            let selectedIndex = mainView.segmentControl.selectedSegmentIndex
            let selectedSegment = MainPageSegments.allCases[selectedIndex]
            presenter.startPagination(segment: selectedSegment)
        }
    }
}

extension MainPageViewController: MainPageViewProtocol {
    
    //MARK: - Presenter Output
    func handleOutput(_ output: MainPagePresenterOutput) {
        switch output {
        case .showLoading(let bool):
            print("Loading state is: \(bool)")
            loadStatement = bool
        case .showList(let tvSeries):
            self.tvSeries = tvSeries
            DispatchQueue.main.async { [weak self] in
                self?.mainView.tableView.reloadData()
            }
        case .reloadTableView(let total):
            self.totalResults = total
            DispatchQueue.main.async { [weak self] in
                self?.mainView.tableView.reloadData()
            }
        }
    }
    
    func fetchRows(indexPaths: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: indexPaths)
            self.mainView.tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        }
    }
}

private extension MainPageViewController {
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= tvSeries.count
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = mainView.tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func loadPageWithSegmentIndex(index: Int) {
        let segment = MainPageSegments.allCases[index]
        
        switch segment {
        case .popular(_):
            presenter.loadPopular()
        case .topRated(_):
            presenter.loadTopRated()
        }
    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        presenter.resetPagination()
        loadPageWithSegmentIndex(index: sender.selectedSegmentIndex)
    }
}
