//
//  MovieDTO.swift
//  AppAsia-Test
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import Foundation

// MARK: Data Transfer Object

struct MovieDTO: Decodable {
    
    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: Date
    
}
