//
//  MovieDetailsViewController.swift
//  AppAsia-Task
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import UIKit
import Combine

final class MovieDetailsViewController: UIViewController {
    
    private let mainView = MovieDetailsView()
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, MovieBO>?
    
    let viewModel: MovieDetailsViewModel
    
    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    // MARK: - Private methods

    private func bindViewModel() {
        viewModel
            .$state
            .sink(receiveValue: stateHandler)
            .store(in: &cancellables)
        
        mainView.errorView.onRetryButtonClick { [weak self] in
            guard let self = self else { return }
            self.mainView.hideErrorView()
            self.viewModel.loadMovie()
        }
        
    }
    
    private lazy var stateHandler: (ViewState) -> Void = { [weak self] state in
        guard let self = self else { return }
        switch state {
        case .idle:
            self.viewModel.loadMovie()
        case .loading:
            self.mainView.startLoading()
        case .finishedLoading:
            self.mainView.stopLoading()
            self.mainView.hideErrorView()
            self.mainView.showDetails(self.viewModel.movieDetails)
        case .error(let error):
            self.mainView.stopLoading()
            self.mainView.showError(error: error)
        }
    }
    
}

extension MovieDetailsView {
    func showDetails(_ details: MovieDetails) {
        imageView.sd_setImage(with: details.posterUrl, placeholderImage: .placeholder)
        releaseDateLabel.text = details.releaseDateString
        genresLabel.text = details.genresTitle
        titleLabel.text = details.title
        overviewLabel.text = details.overview
        voteLabel.text = details.votePercentage
    }
}
