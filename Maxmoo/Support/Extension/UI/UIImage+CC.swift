//
//  UIImage+CC.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit

extension UIImage {
    // 图片裁剪
    func clipImage(rect: CGRect) -> UIImage? {
        let realRect = CGRect(x: rect.origin.x * self.scale,
                              y: rect.origin.y * self.scale,
                              width: rect.size.width * self.scale,
                              height: rect.size.height * self.scale)
        if let imageRectRef = self.cgImage?.cropping(to: realRect) {
            return UIImage(cgImage: imageRectRef,
                           scale: self.scale,
                           orientation: .up)
        }
        return nil
    }
    
    // image圆角
    func round(radius: CGFloat, corners: UIRectCorner = .allCorners) -> UIImage? {
        let imageRect = CGRect(origin: CGPoint.zero, size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)

        let context = UIGraphicsGetCurrentContext()
        guard context != nil else {
            return nil
        }
        context?.setShouldAntialias(true)
        let bezierPath = UIBezierPath(roundedRect: imageRect,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: radius, height: radius))
        bezierPath.close()
        bezierPath.addClip()
        self.draw(in: imageRect)

        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return finalImage
    }
    
    // 转化为png image
    func png() -> UIImage? {
        if let imageData = self.pngData() {
            let imagePng = UIImage(data: imageData)
            return imagePng
        }
        return nil
    }

}
