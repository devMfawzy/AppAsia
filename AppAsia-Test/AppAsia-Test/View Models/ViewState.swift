//
//  ViewState.swift
//  AppAsia-Test
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import Foundation

enum ViewState: Equatable {
    case idle
    case loading
    case finishedLoading
    case error(Error)
    case showDetails(String)
}
