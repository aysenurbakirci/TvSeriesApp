//
//  MainView.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

import UIKit

final class MainPageView: UIView {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListTableCell.self, forCellReuseIdentifier: ListTableCell.reuseIdentifier)
        return tableView
    }()
    
    let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        return segment
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
