//
//  MovieListViewModel.swift
//  AppAsia-Test
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import Foundation
import Combine

final class MovieListViewModel {
    
    private let service: MovieServiceProtocol
    private var nextPage = 1
    private var cancellables = Set<AnyCancellable>()
    private var totalResults = Int.max
    
    private(set) var movies = [MovieBO]()
    @Published private(set) var state: ViewState = .idle
    
    init(service: MovieServiceProtocol = MovieService()) {
        self.service = service
    }
    
    func loadMovies() {
        fetchMovieList(page: 1)
    }
    
    func loadNextPage() {
        guard totalResults > movies.count else { return }
        guard state != .loading else { return }
        fetchMovieList(page: nextPage)
    }
    
    private func fetchMovieList(page: Int) {
        state = .loading
        service
            .movieList(page: page)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] compeletion in
                    guard let self = self else { return }
                    if case let .failure(error) = compeletion {
                        self.state = .error(error)
                    }},
                receiveValue: { [weak self] model  in
                    guard let self = self else { return }
                    self.totalResults = model.totalResults
                    let movies =  model.results.map { MovieBO(dto: $0) }
                    if page > 1 {
                        movies.forEach { movie in
                            if !self.movies.contains(movie) {
                                self.movies.append(movie)
                            }
                        }
                    } else {
                        self.movies = movies
                    }
                    self.nextPage = page+1
                    self.state = .finishedLoading
                })
            .store(in: &cancellables)
    }
    
}
