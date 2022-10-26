//
//  MovieBO.swift
//  AppAsia-Task
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import Foundation

// MARK: Business Object

struct MovieBO: Identifiable, Hashable {
    
    private static var dateFormater = DateFormatter()

    let id: Int
    let title: String
    var posterUrl: URL?
    var releaseDate: String
    
    init(dto: MovieDTO) {
        self.id = dto.id
        self.title = dto.title
        self.releaseDate = Self.releaseDate(date: dto.releaseDate)
        if let path = dto.posterPath {
            self.posterUrl = Endpoints.Movies.posterURL(path: path)
        }
    }

    static func releaseDate(date: Date) -> String {
        dateFormater.dateStyle = .medium
        return dateFormater.string(from: date)
    }
    
}
