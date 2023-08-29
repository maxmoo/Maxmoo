//
//  UIView+CC.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit

extension UIView {
    
    // 移除所有的子视图
    func removeAllSubviews() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }
    
    // 转图片
    // 将某个view 转换成图像
    func image(rect: CGRect? = nil) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        guard let _ = context else {return nil}

        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let rect = rect {
            image = image?.clipImage(rect: rect)
        }
        
        return image
    }
    
    func gesturesEnable(_ enable: Bool) {
        if let gests = self.gestureRecognizers {
            for ges in gests {
                ges.isEnabled = enable
            }
        }
    }

    // 边界与区域的转换
    func rect(from edgeInsets: UIEdgeInsets) -> CGRect {
        return CGRect(x: edgeInsets.left,
                      y: edgeInsets.top,
                      width: self.frame.size.width - edgeInsets.right - edgeInsets.left,
                      height: self.frame.size.height - edgeInsets.bottom - edgeInsets.top)
    }
    
    func insets(from rect: CGRect) -> UIEdgeInsets {
        return UIEdgeInsets(top: rect.origin.y,
                            left: rect.origin.x,
                            bottom: self.frame.size.height - (rect.origin.y + rect.size.height),
                            right: self.frame.size.width - (rect.origin.x + rect.size.width))
    }
    
}

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
