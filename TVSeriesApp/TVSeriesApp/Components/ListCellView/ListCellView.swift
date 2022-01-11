//
//  ListCellView.swift
//  TVSeriesApp
//
//  Created by Ayşenur Bakırcı on 4.01.2022.
//

import Foundation
import UIKit

final class ListCellView: UIView {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var overview: UILabel = {
        let overview = UILabel()
        overview.font = .systemFont(ofSize: 12)
        overview.textColor = .darkGray
        overview.numberOfLines = 0
        return overview
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(overview)
        stack.axis = .vertical
        return stack
    }()
    
    init(cellHight: Float, cellRatio: Float) {
        super.init(frame: .zero)
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor
            .constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor
            .constraint(equalTo: bottomAnchor).isActive = true
        imageView.leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 10.0).isActive = true
        imageView.widthAnchor
            .constraint(equalToConstant: CGFloat(cellHight * cellRatio)).isActive = true
        imageView.heightAnchor
            .constraint(equalToConstant: CGFloat(cellHight)).isActive = true
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor
            .constraint(equalTo: imageView.trailingAnchor, constant: 10.0).isActive = true
        stackView.centerYAnchor
            .constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyModel(_ model: ListCellViewModel) {
        imageView.image = model.image
        title.text = model.title
        overview.text = model.overview
    }
}
