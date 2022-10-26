//
//  AppAsiaMovieListViewModelTests.swift
//  AppAsia-TaskTests
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import Foundation
import Combine
@testable import AppAsia_Task

final class MockMoviesService: MovieServiceProtocol {
    
    let moviesResponseSubject = PassthroughSubject<MoviesResponse, Error>()
    let movieDetailsSubject = PassthroughSubject<MovieDetails, Error>()
    
    var mockServiceResult: MockServiceResult
    
    init(type: MockServiceResult) {
        self.mockServiceResult = type
    }
    
    func movieList(page: Int) -> AnyPublisher<AppAsia_Task.MoviesResponse, AppAsia_Task.Error> {
        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(1)) { [weak self] in
            guard let self = self else { return }
            switch self.mockServiceResult {
            case .error(let error):
                self.moviesResponseSubject.send(completion: .failure(error))
            case .data(let data):
                let response = MoviesResponse(totalResults: data.count, results: data)
                self.moviesResponseSubject.send(response)
            }
        }
        return moviesResponseSubject.eraseToAnyPublisher()
    }
    
    func movieDetails(id: Int) -> AnyPublisher<AppAsia_Task.MovieDetails, AppAsia_Task.Error> {
        DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(1)) { [weak self] in
            guard let self = self else { return }
            switch self.mockServiceResult {
            case .error(let error):
                self.movieDetailsSubject.send(completion: .failure(error))
            case .data(let data):
                guard let movie = data[safe: id-1] else {
                    self.movieDetailsSubject.send(completion: .failure(.parsing))
                    return
                }
                let movieDetails = MovieDetails(title: movie.title, posterPath: movie.posterPath, overview: "movie overview", genres: [.init(name: "Action"), .init(name: "Drama")], releaseDate: Date(), voteAverage: 7.2)
                self.movieDetailsSubject.send(movieDetails)
            }
        }
        return movieDetailsSubject.eraseToAnyPublisher()
    }
    
    enum MockServiceResult {
        case data([MovieDTO])
        case error(Error)
    }
    
}
