//
//  MainView.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

/** View is both displays information for the user and detects user interaction.
 The Presenter is the only module the View module has contact with.
 In this project, view and viewcontroller classes are View together. **/

import UIKit

final class MainPageView: UIView {
    
    //MARK: - Properties
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListTableCell.self, forCellReuseIdentifier: ListTableCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: MainPageSegments.segmentControlItems())
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    //MARK: - Initalization
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
