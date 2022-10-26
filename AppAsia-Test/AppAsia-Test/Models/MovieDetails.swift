//
//  MovieDetails.swift
//  AppAsia-Task
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import Foundation

struct MovieDetails: Decodable {
    let title: String
    let posterPath: String?
    let overview: String
    let genres: [Genre]
    let releaseDate: Date?
    let voteAverage: Double

    struct Genre: Decodable {
        let name: String
    }
}


extension MovieDetails {
    
    static var `default`: MovieDetails {
        MovieDetails(title: "", posterPath: nil, overview: "", genres: [], releaseDate: nil, voteAverage: 0)
    }
    
    var posterUrl: URL? {
        guard let path = posterPath else { return nil }
        return Endpoints.Movies.posterURL(path: path)
    }
    
    var releaseDateString: String? {
        guard let date = releaseDate else { return nil }
        return MovieBO.releaseDate(date: date)
    }
    
    var genresTitle: String {
        return genres.map({ $0.name}).joined(separator: " | ")
    }
    
    var votePercentage: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        guard let string = numberFormatter.string(from: NSNumber(value: voteAverage/10)) else {
            return nil
        }
        return "User score: \(string)"
    }
    
}
