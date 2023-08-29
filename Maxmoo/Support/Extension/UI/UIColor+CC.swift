//
//  UIColor+CC.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/25.
//

import UIKit

extension UIColor {
    
    class var randomColor: UIColor { randomColor() }
    
    class func randomColor(_ a: CGFloat = 1.0) -> UIColor {
        UIColor(red: CGFloat.random(in: 0...255) / 255.0,
                green: CGFloat.random(in: 0...255) / 255.0,
                blue: CGFloat.random(in: 0...255) / 255.0,
                alpha: a)
    }
    
    public func rgba() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
}
