//
//  MovieDetailsView.swift
//  AppAsia-Task
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import UIKit

final class MovieDetailsView: UIView {
    
    private var didSetupContrainsts = false
    private var pullToRefreshHandler: (() -> Void)?

    
    let imageView = UIImageView()
    let releaseDateLabel = UILabel()
    let titleLabel = UILabel()
    let overviewLabel = UILabel()
    let genresLabel = UILabel()
    let voteLabel = UILabel()
    let errorView = ErrorView()
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    let vStack = UIStackView()
    let hStack = UIStackView()
    let scrollView =  UIScrollView()
    
    // MARK: Initializers
    
    init() {
        super.init(frame: .zero)
        addSubviews()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoading() {
        loadingIndicator.startAnimating()
    }
    
    func stopLoading() {
        loadingIndicator.stopAnimating()
    }
    
    func showError(error: Error) {
        errorView.show(message: error.description)
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.errorView.isHidden = false
        }
    }
    
    func hideErrorView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.errorView.isHidden = true
        }
    }
    
    // MARK: - Private methods
    
    private func addSubviews() {
        vStack.addArrangedSubview(errorView)
        vStack.addArrangedSubview(imageView)
        vStack.addArrangedSubview(titleLabel)
        hStack.addArrangedSubview(releaseDateLabel)
        hStack.addArrangedSubview(genresLabel)
        vStack.addArrangedSubview(hStack)
        vStack.addArrangedSubview(voteLabel)
        vStack.addArrangedSubview(overviewLabel)
        vStack.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(vStack)
        
        [scrollView, loadingIndicator]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        updateConstraintsIfNeeded()
    }
    
    private func setUpViews() {
        backgroundColor = .systemBackground
        
        vStack.axis = .vertical
        vStack.spacing = 16
        
        hStack.axis = .horizontal
        hStack.spacing = 12
        
        errorView.isHidden = true
        
        [titleLabel, overviewLabel, genresLabel]
            .forEach { label in
                label.numberOfLines = .zero
            }
        releaseDateLabel.font = .preferredFont(forTextStyle: .callout)
        genresLabel.font = .preferredFont(forTextStyle: .caption1)
        voteLabel.font = .preferredFont(forTextStyle: .callout)
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        overviewLabel.font = .preferredFont(forTextStyle: .subheadline)
        
        imageView.contentMode = .scaleAspectFit
    }
    
    // MARK: - Auto layout
    
    override func updateConstraints() {
        if !didSetupContrainsts {
            let heightConstraint = vStack.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            heightConstraint.priority = UILayoutPriority(250)
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
                scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -9),
                scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                
                vStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
                vStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                vStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                vStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                vStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                heightConstraint,
                
                loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
            
            didSetupContrainsts = true
        }
        super.updateConstraints()
    }
    
}
