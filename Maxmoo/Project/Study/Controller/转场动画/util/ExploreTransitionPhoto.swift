//
//  ExploreTransitionAnimate.swift
//  Maxmoo
//
//  Created by 程超 on 2024/7/17.
//

import UIKit

struct ExploreTransitionPhotoImageModel {
    var image: UIImage?
    var originalFrame: CGRect = .zero
    var targetFrame: CGRect = .zero
}

class ExploreTransitionPhoto: ExploreTransitionUtil {
    var forwardPhoto: ExploreTransitionPhotoImageModel?
    
    override func transitionAnimation(transitionContext: UIViewControllerContextTransitioning) {
        guard let forwardPhoto else { return }
        
        // 获得容器视图（转场动画发生的地方）
        let containerView = transitionContext.containerView
        // 动画执行时间
        let duration = self.transitionDuration(using: transitionContext)
        // fromVC (即将消失的视图)
        let fromVC = transitionContext.viewController(forKey: .from)!
        let fromView = fromVC.view!
        // toVC (即将出现的视图)
        let toVC = transitionContext.viewController(forKey: .to)!
        let toView = toVC.view!
        
        let oriImageView = UIImageView(frame: forwardPhoto.originalFrame)
        oriImageView.image = forwardPhoto.image
        containerView.addSubview(oriImageView)
        
        var finalShowFrame = forwardPhoto.targetFrame
        switch transitionType {
        case .push(_):
            break
        case .present(let operation):
            if operation != .presentation {
                fromView.alpha = 0
                oriImageView.frame = forwardPhoto.targetFrame
                finalShowFrame = forwardPhoto.originalFrame
            } else {
                toView.alpha = 0
                containerView.insertSubview(toView, at: 0)
            }
        }

        UIView.animate(withDuration: duration) { [weak self] in
            guard let self else { return }
            if self.isPresentation() {
                toView.alpha = 1
            } else {
                fromView.alpha = 0
            }
            oriImageView.frame = finalShowFrame
        } completion: { [weak self] _ in
            guard let self else { return }
            oriImageView.removeFromSuperview()
            //考虑到转场中途可能取消的情况，转场结束后，恢复视图状态。(通知是否完成转场)
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}
