//
//  MovieCollectionViewCell.swift
//  AppAsia-Test
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import UIKit
import SDWebImage

final class MovieCollectionViewCell: UICollectionViewCell {
    
    private var didSetupContrainsts = false
    private let movieView = MovieCellView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: MovieBO) {
        movieView.label.text = model.releaseDate
        resetImage()
        if let imageUrl = model.posterUrl {
            movieView.imageView.sd_setImage(with: imageUrl, placeholderImage: .placeholder)
        }
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        contentView.addSubview(movieView)
        movieView.translatesAutoresizingMaskIntoConstraints = false
        setNeedsUpdateConstraints()
        updateConstraintsIfNeeded()
    }

    private func resetImage() {
        movieView.imageView.sd_cancelCurrentImageLoad()
        movieView.imageView.image = nil
    }
    
    // MARK: - Auto layout

    override func updateConstraints() {
        if !didSetupContrainsts {
            NSLayoutConstraint.activate([
                movieView.topAnchor.constraint(equalTo: contentView.topAnchor),
                movieView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                movieView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                movieView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

            ])
            
            didSetupContrainsts = true
        }
        super.updateConstraints()
    }
    
}
