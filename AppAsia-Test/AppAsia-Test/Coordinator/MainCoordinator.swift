//
//  MainCoordinator.swift
//  AppAsia-Task
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import UIKit

final class MainCoordinator: Coordinator {
    let window: UIWindow
    var navigationController: UINavigationController?

    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let rootViewController = MoviesViewController()
        rootViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.navigationController = navigationController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension MainCoordinator: MoviesViewControllerDelegate {
    func showMovieDetails(id: Int) {
        let viewModel =  MovieDetailsViewModel(id: id)
        let viewController = MovieDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
