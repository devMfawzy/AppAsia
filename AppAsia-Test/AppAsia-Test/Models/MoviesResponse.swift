//
//  MoviesResponse.swift
//  AppAsia-Test
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import Foundation

struct MoviesResponse: Decodable {
    
    let totalResults: Int
    let results: [MovieDTO]
    
}
