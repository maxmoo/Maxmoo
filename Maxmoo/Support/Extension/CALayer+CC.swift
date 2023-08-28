//
//  CALayer+CC.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit

extension CALayer{
    
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
