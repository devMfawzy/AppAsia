//
//  Collection+SafeSubscript.swift
//  AppAsia-Task
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
