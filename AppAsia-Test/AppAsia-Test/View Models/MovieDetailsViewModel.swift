//
//  MovieDetailsViewModel.swift
//  AppAsia-Task
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import Foundation
import Combine

final class MovieDetailsViewModel {
    private let id: Int
    private let service: MovieServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var movieDetails = MovieDetails.default
    @Published private(set) var state: ViewState = .idle
    
    init(id: Int, service: MovieServiceProtocol = MovieService()) {
        self.service = service
        self.id = id
    }
    
    func loadMovie() {
        state = .loading
        service
            .movieDetails(id: id)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] compeletion in
                    guard let self = self else { return }
                    if case let .failure(error) = compeletion {
                        self.state = .error(error)
                    }
                },
                receiveValue: { [weak self] model  in
                    guard let self = self else { return }
                    self.movieDetails = model
                    self.state = .finishedLoading
                })
            .store(in: &cancellables)
    }
    
}
