//
//  UIView+CC.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit

extension UIView {
    
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }

    var top: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.y = newValue
        }
    }

    var bottom: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
            frame.y = newValue - frame.height
        }
    }

    var right: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            frame.x = newValue - frame.width
        }
    }

    var left: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.x = newValue
        }
    }

    var center: CGPoint {
        get {
            return frame.center
        }
        set {
            centerX = newValue.x
            centerY = newValue.y
        }
    }

    var centerX: CGFloat {
        get {
            return frame.origin.x + frame.size.width / 2
        }
        set {
            frame.x = newValue - frame.size.width / 2
        }
    }

    var centerY: CGFloat {
        get {
            return frame.origin.y + frame.size.height / 2
        }
        set {
            frame.y = newValue - frame.size.height / 2
        }
    }

    var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }

    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }

    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
}

extension CGRect {
    
    var centerX: CGFloat {
        get { return midX }
        set { origin.x = newValue - width * 0.5 }
    }

    var centerY: CGFloat {
        get { return midY }
        set { origin.y = newValue - height * 0.5 }
    }

    var center: CGPoint {
        get {
            let x = x + (width / 2)
            let y = y + (height / 2)
            return CGPoint(x: x, y: y)
        }
        set {
            origin.x = newValue.x - size.width / 2
            origin.y = newValue.y - size.height / 2
        }
    }

    var x: CGFloat {
        get {
            return origin.x
        }
        set {
            origin.x = newValue
        }
    }

    var right: CGFloat {
        get {
            return origin.x + size.width
        }
        set {
            x = newValue - width
        }
    }

    var y: CGFloat {
        get {
            return origin.y
        }
        set {
            origin.y = newValue
        }
    }

    var width: CGFloat {
        get {
            return size.width
        }
        set {
            size.width = newValue
        }
    }

    var height: CGFloat {
        get {
            return size.height
        }
        set {
            size.height = newValue
        }
    }

    var top: CGFloat {
        get {
            return minY
        }
        set {
            origin.y = newValue
        }
    }

    var bottom: CGFloat {
        get {
            return maxY
        }
        set {
            origin.y = newValue - size.height
        }
    }

    var rightTop: CGPoint {
        return CGPoint(x: minX + width, y: minY)
    }

    var rightBottom: CGPoint {
        return CGPoint(x: minX + width, y: maxY)
    }

    var leftBottom: CGPoint {
        return CGPoint(x: minX, y: maxY)
    }

    var leftTop: CGPoint {
        return CGPoint(x: minX, y: minY)
    }
}
