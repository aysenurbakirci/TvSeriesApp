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
        view.segmentControl.addTarget(self, action: #selector(segmentedValueChanged), for: .valueChanged)
        return view
    }()
    
    private var tvSeries: [ImageRecord] = []
    private var loadStatement: Bool = false
    
    var presenter: MainPagePresenterProtocol!
    let pendingOperations = PendingOperations()

    //MARK: - ViewDidLoad
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
        return tvSeries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableCell.reuseIdentifier, for: indexPath) as? ListTableCell else {
            return UITableViewCell()
        }
        
        if cell.accessoryView == nil {
            let indicator = UIActivityIndicatorView(style: .medium)
            cell.accessoryView = indicator
        }
        let indicator = cell.accessoryView as! UIActivityIndicatorView
        
        let tvSeries = self.tvSeries[indexPath.row]
        let model = ListCellViewModel(tvSeries)
        cell.applyModel(model)
        
        switch tvSeries.state {
        case .ready:
            indicator.startAnimating()
            if !tableView.isDragging && !tableView.isDecelerating {
                startOperations(for: tvSeries, at: indexPath)
            }
        case .succeed:
            indicator.stopAnimating()
        case .failed:
            indicator.stopAnimating()
            print("FAILED")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.selectTVSeries(to: indexPath.row)
    }
}

//MARK: - MainPageViewProtocol
extension MainPageViewController: MainPageViewProtocol {
    
    func handleOutput(_ output: MainPagePresenterOutput) {
        switch output {
        case .showLoading(let bool):
            loadStatement = bool
        case .showList(let tvSeries):
            self.tvSeries = tvSeries
            DispatchQueue.main.async { [weak self] in
                self?.mainView.tableView.reloadData()
            }
        }
    }
}

//MARK: - Segment Control Sender
private extension MainPageViewController {
    
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
        loadPageWithSegmentIndex(index: sender.selectedSegmentIndex)
    }
}

//MARK: - Scroll View Delegate
extension MainPageViewController {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnscreenCells()
            pendingOperations.downloadQueue.isSuspended = false
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnscreenCells()
        pendingOperations.downloadQueue.isSuspended = false
    }
}

//MARK: - Operation
extension MainPageViewController {
    
    func loadImagesForOnscreenCells() {
        if let pathsArray = self.mainView.tableView.indexPathsForVisibleRows {

            let allPendingOperations = Set(pendingOperations.downloadsInProgress.keys)
            let visiblePaths = Set(pathsArray)

            var toBeCancelled = allPendingOperations
            var toBeStarted = visiblePaths

            toBeCancelled.subtract(visiblePaths)
            toBeStarted.subtract(allPendingOperations)

            for indexPath in toBeCancelled {
                if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                    pendingDownload.cancel()
                }
                pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            }

            for indexPath in toBeStarted {
                let selectedModel = tvSeries[indexPath.row]
                startOperations(for: selectedModel, at: indexPath)
            }
        }
    }
    
    func startOperations(for photoRecord: ImageRecord, at indexPath: IndexPath) {
        guard photoRecord.state == .ready else { return }
        startDownload(for: photoRecord, at: indexPath)
    }
    
    func startDownload(for photoRecord: ImageRecord, at indexPath: IndexPath) {
        guard pendingOperations.downloadsInProgress[indexPath] == nil else {
            return
        }
        
        let downloadOperation = ImageDownloader(photoRecord)
        downloadOperation.completionBlock = {
            guard !downloadOperation.isCancelled else { return }
            
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.mainView.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
        pendingOperations.downloadsInProgress[indexPath] = downloadOperation
        pendingOperations.downloadQueue.addOperation(downloadOperation)
    }
}

