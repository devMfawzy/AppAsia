//
//  UIView+Border.swift
//  AppAsia-Test
//
//  Created by Mohamed Fawzy on 26/10/2022.
//

import UIKit

extension UIView {
    
    func setBorder(width: CGFloat, color: UIColor, cornerRadius: CGFloat = 0) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
    
}
