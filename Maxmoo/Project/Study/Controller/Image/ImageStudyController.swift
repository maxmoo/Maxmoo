//
//  ImageStudyController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/9/15.
//

import UIKit

class ImageStudyController: UIViewController {

    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 100, y: 200, width: 100, height: 120))
        imageView.backgroundColor = .randomColor
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .randomColor

        // 截图
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
//        view.backgroundColor = .red
//        
//        let imageView = UIImageView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
//        imageView.backgroundColor = .blue
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = view.image()?.png()
//        self.view.addSubview(imageView)
        
        view.addSubview(imageView)
        
        // 显示视频第一帧
//        imageView.fetchOnlineVideoCoverImage(fromURL: URL(string: "https://alivc-demo-vod.aliyuncs.com/7324abc905c7431f885f168846876dd3/7cd3b03f315f6d40b9323274bfcd7527-fd.mp4"))
        
        let imagePath = UIBezierPath()
        imagePath.move(to: CGPoint(x: 40, y: 100))
        imagePath.addLine(to: CGPoint(x: 25, y: 100))
        imagePath.addArc(withCenter: CGPoint(x: 25, y: 75), radius: 25, startAngle: 0.5 * .pi, endAngle: .pi, clockwise: true)
//        imagePath.move(to: CGPoint(x: 0, y: 75))
        imagePath.addLine(to: CGPoint(x: 0, y: 25))
        imagePath.addArc(withCenter: CGPoint(x: 25, y: 25), radius: 25, startAngle: .pi, endAngle: 1.5 * .pi, clockwise: true)
        imagePath.addLine(to: CGPoint(x: 75, y: 0))
        imagePath.addArc(withCenter: CGPoint(x: 75, y: 25), radius: 25, startAngle: 1.5 * .pi, endAngle: 0, clockwise: true)
        imagePath.addLine(to: CGPoint(x: 100, y: 75))
        imagePath.addArc(withCenter: CGPoint(x: 75, y: 75), radius: 25, startAngle: 0, endAngle: 0.5 * .pi, clockwise: true)
        imagePath.addLine(to: CGPoint(x: 60, y: 100))
        imagePath.addLine(to: CGPoint(x: 50, y: 120))
        imagePath.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = imagePath.cgPath
        imageView.layer.mask = shapeLayer
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = imagePath.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.white.cgColor // 边框为白色
        borderLayer.lineWidth = 3 // 设置边框宽度
        imageView.layer.addSublayer(borderLayer)
    }

}
