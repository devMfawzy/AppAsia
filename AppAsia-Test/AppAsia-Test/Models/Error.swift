//
//  Error.swift
//  AppAsia-Test
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import Foundation

enum Error: Swift.Error, CustomStringConvertible, Equatable {
    
    case invalidURL
    case network
    case parsing
    case unknown
  
    var description: String {
        switch self {
        case .network:
            return "Request to server failed"
        case .invalidURL:
            return "Invalid URL"
        case .parsing:
            return "Unexpected data format"
        case .unknown:
            return "An unknown error occurred"
        }
    }
    
}
