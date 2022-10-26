//
//  ViewController.swift
//  AppAsia-Test
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import UIKit
import Combine

class MoviesViewController: UIViewController {
    private let widthRatio: CGFloat = 0.86
    private let heightToWidthRatio: CGFloat = 1.70
    private let itemSpacing: CGFloat = 6.0
    private let reloadThreshold = 0.75
    
    private let mainView = MovieListView()
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<Section, MovieBO>?
    
    let viewModel: MovieListViewModel
    
    init(viewModel: MovieListViewModel = MovieListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollectionView() {
        mainView.collectionView.register(MovieCollectionViewCell.self)
        mainView.collectionView.delegate = self
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionVieweView, indexPath, model in
            let cell = collectionVieweView.reuse(MovieCollectionViewCell.self, indexPath)
            cell.configure(model: model)
            return cell
        })
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
            self.viewModel.loadNextPage()
        }
        
        mainView.onPullToRefresh { [weak self] in
            guard let self = self else { return }
            self.viewModel.loadMovies()
        }
    }
    
    private lazy var stateHandler: (ViewState) -> Void = { [weak self] state in
        guard let self = self else { return }
        switch state {
        case .idle:
            self.viewModel.loadMovies()
        case .loading:
            self.mainView.startLoading()
        case .finishedLoading:
            self.mainView.stopLoading()
            self.mainView.hideErrorView()
            self.updateDataSource()
        case .error(let error):
            self.mainView.stopLoading()
            self.mainView.showError(error: error)
        case .showDetails(let details):
            self.showDetails(details)
        }
    }
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieBO>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.movies)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    private func showDetails(_ details: String) {
        let alertController = UIAlertController(title: "Info", message: details, preferredStyle: .alert)
        alertController.addAction(.init(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
}

// MARK: Collection View Delegate

extension MoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        //TODO: show details view
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collectionView = mainView.collectionView
        guard let lastCell = collectionView.visibleCells.last else { return }
        guard let lastRow = collectionView.indexPath(for: lastCell)?.row else { return }
        let loadedItemsCount = Double(viewModel.movies.count)
        let shouldLoadMore = Double(lastRow) >= (loadedItemsCount * reloadThreshold)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) { [weak self] in
            if shouldLoadMore {
                self?.scrollViewDidReachBottom(scrollView)
            }
        }
    }
    
    func scrollViewDidReachBottom(_ scrollView: UIScrollView) {
        viewModel.loadNextPage()
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = min(bounds.width, bounds.height) * widthRatio
        return CGSize(width: width, height: width*heightToWidthRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing*3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: itemSpacing, left: itemSpacing, bottom: itemSpacing, right: itemSpacing)
    }
    
}

