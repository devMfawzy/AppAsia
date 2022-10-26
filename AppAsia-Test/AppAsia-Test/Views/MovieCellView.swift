//
//  MovieCellView.swift
//  AppAsia-Test
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import UIKit

final class MovieCellView: UIView {
    
    private var didSetupContrainsts = false
    
    let label = UILabel()
    let imageView = UIImageView()
    
    // MARK: Initializers
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup

    private func addSubviews() {
        [imageView, label]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        updateConstraintsIfNeeded()
    }
    
    override func updateConstraints() {
        if !didSetupContrainsts {
            
            let constraint = imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1.5)
            constraint.priority = UILayoutPriority(rawValue: 999)

            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
                imageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -4),
                constraint,
                
                label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
            ])
            
            didSetupContrainsts = true
        }
        super.updateConstraints()
    }
    
    // MARK: setUp Views
    
    private func setUpViews() {
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = .zero
        
        contentMode = .scaleAspectFit
        setBorder(width: 0.7, color: .lightGray, cornerRadius: 10)
    }
}
