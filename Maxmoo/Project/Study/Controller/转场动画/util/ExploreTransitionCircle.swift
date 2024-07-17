//
//  ExploreTransitionCircle.swift
//  Maxmoo
//
//  Created by 程超 on 2024/7/17.
//

import UIKit

class ExploreTransitionCircle: ExploreTransitionUtil {
    var centerPoint: CGPoint = .zero
    var circleColor: UIColor = .white
    
    override func transitionAnimation(transitionContext: UIViewControllerContextTransitioning) {
        //获得容器视图（转场动画发生的地方）
        let containerView = transitionContext.containerView
        
        //动画执行时间
        let duration = self.transitionDuration(using: transitionContext)
        
        //fromVC (即将消失的视图)
        let fromVC = transitionContext.viewController(forKey: .from)!
        let fromView = fromVC.view!
        //toVC (即将出现的视图)
        let toVC = transitionContext.viewController(forKey: .to)!
        let toView = toVC.view!
        let originalSize = toView.frame.size
        
        let maskView = UIView(frame: toView.bounds)
        maskView.backgroundColor = circleColor
        toVC.view.addSubview(maskView)
        UIView.animate(withDuration: duration) {
            maskView.alpha = 0
        } completion: { _ in
            maskView.removeFromSuperview()
        }
        
        //半径
        let radius = self.getRadius(startPoint: centerPoint, originalSize: originalSize)
        var maskAnim: TransitionMaskAnimation
        if isPresentation() {
            containerView.addSubview(toView)
            maskAnim = TransitionMaskAnimation(layer: toView.layer, center: centerPoint, startRadius: 0, endRadius: radius, duration: duration)
        } else {
            maskAnim = TransitionMaskAnimation(layer: fromView.layer, center: centerPoint, startRadius: radius, endRadius: 0, duration: duration)
        }
        maskAnim.completion = { finished in
            transitionContext.completeTransition(true)
        }
    }
    
    ///获得半径 (不明白的自己画个图，看一下哪一条应该是半径)
    private func getRadius(startPoint: CGPoint, originalSize: CGSize) -> CGFloat {
        let horizontal = max(startPoint.x, originalSize.width - startPoint.x)
        let vertical = fmax(startPoint.y, originalSize.height - startPoint.y)
        //勾股定理计算半径
        let radius = sqrt(horizontal*horizontal + vertical*vertical)
        return radius
    }
}

class TransitionMaskAnimation: NSObject {
    weak var layer: CALayer?
    var completion: ((_ finished: Bool) -> Void)?
    
    init(layer: CALayer, center: CGPoint, startRadius: CGFloat, endRadius: CGFloat, duration: TimeInterval = 0.5) {
        super.init()
        self.layer = layer
        
        let f1 = CGRect(x: center.x, y: center.y, width: startRadius, height: startRadius)
        let startRect = f1.insetBy(dx: -startRadius, dy: -startRadius)
        let startPath = UIBezierPath(ovalIn: startRect)
        
        //创建一个 CAShapeLayer 来负责展示圆形遮盖
        let f2 = CGRect(x: center.x, y: center.y, width: endRadius, height: endRadius)
        let endRect = f2.insetBy(dx: -endRadius, dy: -endRadius)
        let endPath = UIBezierPath(ovalIn: endRect)
        //用 CAShapeLayer 作为 mask
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.cgPath
        maskLayer.fillColor = UIColor.black.cgColor
        layer.mask = maskLayer
        
        //对 CAShapeLayer 的 path 属性进行动画
        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
        maskLayerAnimation.delegate = self
        maskLayerAnimation.fromValue = startPath.cgPath
        maskLayerAnimation.toValue = endPath.cgPath
        maskLayerAnimation.duration = duration
        //maskLayerAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        maskLayer.add(maskLayerAnimation, forKey: "path")
    }
}

extension TransitionMaskAnimation: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //清除 fromVC 的 mask,这里一定要清除,否则会影响响应者链
        self.layer?.mask = nil
        self.layer = nil
        completion?(flag)
    }
}
