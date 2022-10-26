//
//  MovieService.swift
//  AppAsia-Test
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import Foundation
import Combine

protocol MovieServiceProtocol {
    func movieList(page: Int) -> AnyPublisher<MoviesResponse, Error>
}

struct MovieService: MovieServiceProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = URLSession(configuration: configuration)
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    func movieList(page: Int) -> AnyPublisher<MoviesResponse, Error> {
        let url = Endpoints.Movies.nowPlayingURL(page: page)
        return publisher(url: url)
    }
    
    private func publisher<T: Decodable>(url: URL?) -> AnyPublisher<T, Error> {
        guard let url = url else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        return session
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error -> Error in
                switch error {
                case is URLError:
                    return .network
                case is DecodingError:
                    return .parsing
                default:
                    return .unknown
                }
            }
            .eraseToAnyPublisher()
    }
}
