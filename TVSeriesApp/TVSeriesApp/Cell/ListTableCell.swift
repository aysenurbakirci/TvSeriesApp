//
//  ListTableCell.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

import UIKit

final class ListTableCell: UITableViewCell {
    
    static let reuseIdentifier = "ListTableCell"
    
    private lazy var cellView = ListCellView(imageSize: .init(x: 0.0, y: 0.0, width: 80.0, height: 80.0))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellView)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
