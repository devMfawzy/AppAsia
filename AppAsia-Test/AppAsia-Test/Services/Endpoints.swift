//
//  Endpoints.swift
//  AppAsia-Test
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import Foundation

struct Endpoints {
    
    struct Movies {
        private static let apiKey = "89a571acaf96541bdee2b19060fc9980"
        private static let language = "en-US"
        private static let imageBaseURL = "https://image.tmdb.org/t/p/w400"
        
        static func nowPlayingURL(page: Int) -> URL? {
            var components = urlComponents()
            components.path += "now_playing"
            components.setQueryItems(with: ["api_key": Self.apiKey,
                                            "page": String(page),
                                            "language": Self.language
                                           ])
            return components.url
        }
        
        static func movieDetailsURL(id: String) -> URL? {
            var components = urlComponents()
            components.path += id
            components.setQueryItems(with: ["api_key": Self.apiKey])
            return components.url
        }
        
        static func posterURL(path: String) -> URL? {
            URL(string: "\(imageBaseURL)\(path)")
        }
        
        private static func urlComponents() -> URLComponents {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.themoviedb.org"
            components.path = "/3/movie/"
            return components
        }
        
        
    }
    
}
