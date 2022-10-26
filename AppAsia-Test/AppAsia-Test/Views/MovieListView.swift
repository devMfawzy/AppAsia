//
//  MovieListView.swift
//  AppAsia-Test
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import UIKit

final class MovieListView: UIView {
    
    private var didSetupContrainsts = false
    private var pullToRefreshHandler: (() -> Void)?
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let refreshControl = UIRefreshControl()
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    let stackView = UIStackView()
    let errorView = ErrorView()
    
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
        if !refreshControl.isRefreshing {
            loadingIndicator.startAnimating()
        }
    }
    
    func stopLoading() {
        loadingIndicator.stopAnimating()
        refreshControl.endRefreshing()
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
        stackView.addArrangedSubview(errorView)
        stackView.addArrangedSubview(collectionView)
        [stackView, loadingIndicator]
            .forEach {
                addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        updateConstraintsIfNeeded()
    }
    
    private func setUpViews() {
        backgroundColor = .systemBackground

        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

        stackView.axis = .vertical
        stackView.spacing = 8
        
        errorView.isHidden = true
    }
    
    @objc private func refreshData(_ sender: Any) {
        pullToRefreshHandler?()
    }
    
    // MARK: Refresh Control Handing
    
    func onPullToRefresh(handler: @escaping () -> Void) {
        pullToRefreshHandler = handler
    }
    
    // MARK: - Auto layout

    override func updateConstraints() {
        if !didSetupContrainsts {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                
                loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
            
            didSetupContrainsts = true
        }
        super.updateConstraints()
    }
    
}
