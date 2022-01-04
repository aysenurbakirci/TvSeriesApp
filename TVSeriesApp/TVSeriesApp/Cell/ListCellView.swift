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
        imageView.image = UIImage(named: "tree")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var overview: UILabel = {
        let overview = UILabel()
        overview.text = "Overview"
        overview.font = .systemFont(ofSize: 12)
        overview.textColor = .darkGray
        return overview
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(overview)
        stack.axis = .vertical
        return stack
    }()
    
    init(imageSize: CGRect) {
        super.init(frame: .zero)
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10.0).isActive = true
        stackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
