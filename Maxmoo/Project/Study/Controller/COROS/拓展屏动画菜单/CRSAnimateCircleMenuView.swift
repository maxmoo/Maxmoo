//
//  CRSAnimateCircleMenuView.swift
//  Maxmoo
//
//  Created by 程超 on 2024/9/18.
//

import UIKit

protocol CRSAnimateCircleMenuDelegate: NSObjectProtocol {
    func didSelect(index: Int, circleView: CRSAnimateCircleMenuView)
}

class CRSAnimateCircleMenuView: UIView {

    weak var delegate: CRSAnimateCircleMenuDelegate?
    
    private var items: [UIView] = []
    private let itemRadius = 80.0
    private var isShowingItems = false {
        didSet {
            animateItems()
        }
    }
    
    private var backView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.alpha = 0.3
        return view
    }()
    
    private lazy var centerImageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        imageView.image = UIImage(named: "add")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(centerImageView)
        createItems()
        addTapGesture { [weak self] in
            self?.isShowingItems.toggle()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for item in items {
            if !item.isHidden, item.alpha == 1, item.bounds.contains(item.convert(point, from: self)) {
                return item
            }
        }
        return super.hitTest(point, with: event)
    }
    
    private func createItems() {
        items.removeAll()
        
        let icons = ["icon_maleAvatar", "icon_maleAvatar", "icon_maleAvatar"]
        for (index, icon) in icons.enumerated() {
            let item = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            item.center = CGPoint(x: width / 2, y: height / 2)
            item.isUserInteractionEnabled = true
            item.isHidden = true
            item.image = UIImage(named: icon)
            item.addTapGesture { [weak self] in
                guard let self else { return }
                print("index: \(index)")
                if let delegate = self.delegate {
                    delegate.didSelect(index: index, circleView: self)
                }
                self.isShowingItems = false
            }
            insertSubview(item, at: 0)
            items.append(item)
        }
    }
    
    private func animateItems() {
        if isShowingItems {
            if let superview = self.superview {
                backView.frame = superview.bounds
                superview.addSubview(backView)
                superview.bringSubviewToFront(self)
            }
            
            centerImageView.image = UIImage(named: "delete")
            let itemCenters = calculateMenuPoints(centerPoint: CGPoint(x: width / 2, y: height / 2), radius: itemRadius, count: items.count)
            for (item, center) in zip(items, itemCenters)  {
                item.isHidden = false
                item.alpha = 0
                UIView.animate(withDuration: 0.23) {
                    item.alpha = 1
                    item.center = center
                }
            }
        } else {
            backView.removeFromSuperview()
            
            centerImageView.image = UIImage(named: "add")
            for item in items  {
                UIView.animate(withDuration: 0.23) { [weak self] in
                    guard let self else { return }
                    item.center = CGPoint(x: self.width / 2, y: self.height / 2)
                    item.alpha = 0
                } completion: { success in
                    if success {
                        item.isHidden = true
                    }
                }
            }
        }
    }
    
    private func calculateMenuPoints(centerPoint: CGPoint,
                                     radius: Double,
                                     count: Int) -> [CGPoint] {
        let topPoint = CGPoint(x: centerPoint.x, y: centerPoint.y - radius)
        switch count {
        case 1:
            return [topPoint]
        case 2:
            let p1 = circlePoint(center: centerPoint, radius: radius, angle: -30)
            let p2 = circlePoint(center: centerPoint, radius: radius, angle: 30)
            return [p2, p1]
        case 3:
            let p1 = circlePoint(center: centerPoint, radius: radius, angle: 40)
            let p3 = circlePoint(center: centerPoint, radius: radius, angle: -40)
            return [p1, topPoint, p3]
        default:
            break
        }
        
        return []
    }
    
    
    private func circlePoint(center: CGPoint, radius: Double, angle: Double) -> CGPoint {
        // 圆心和初始点
        let circleCenter = center
        let startingPoint = CGPoint(x: center.x, y: center.y - radius)

        // 将点平移到以圆心为原点的坐标系
        let shiftedPoint = CGPoint(x: startingPoint.x - circleCenter.x, y: startingPoint.y - circleCenter.y)

        // 将30度转换为弧度
        let degrees: CGFloat = angle
        let radians = degrees * .pi / 180

        // 旋转矩阵中使用的正弦和余弦值，使用负角度以表示顺时针旋转
        let cosTheta = cos(-radians)
        let sinTheta = sin(-radians)

        // 应用旋转矩阵
        let rotatedX = shiftedPoint.x * cosTheta - shiftedPoint.y * sinTheta
        let rotatedY = shiftedPoint.x * sinTheta + shiftedPoint.y * cosTheta

        // 将旋转后的点平移回原始坐标系
        let finalPoint = CGPoint(x: rotatedX + circleCenter.x, y: rotatedY + circleCenter.y)

        return finalPoint
    }
}
