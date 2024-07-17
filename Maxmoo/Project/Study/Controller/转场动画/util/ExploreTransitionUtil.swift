//
//  ExploreTransitionUtil.swift
//  Maxmoo
//
//  Created by 程超 on 2024/7/17.
//

/*demo
 ----------present----------
 let vc = ModalTransitionViewController()
 //设置转场代理(必须在跳转前设置)
 //与容器 VC 的转场的代理由容器 VC 自身的代理提供不同，Modal 转场的代理由 presentedVC 提供
 vc.transitioningDelegate = transitionUtil
 /*
 .FullScreen 的时候，presentingView 的移除和添加由 UIKit 负责，在 presentation 转场结束后被移除，dismissal 转场结束时重新回到原来的位置；
 .Custom 的时候，presentingView 依然由 UIKit 负责，但 presentation 转场结束后不会被移除。
 */
 vc.modalPresentationStyle = .custom
 //animated: 一定要给true，不然不会出现转场动画
 self.present(vc, animated: true, completion: nil)
 
 -----------push--------------
 let vc = NaviTransitionViewController()
 vc.hidesBottomBarWhenPushed = true
 //设置转场代理
 self.navigationController?.delegate = transitionUtil
 self.navigationController?.pushViewController(vc, animated: true)
 */

import Foundation
import UIKit

enum ExploreModalOperation {
    case presentation
    case dismissal
}

/// 转场类型
enum ExploreTransitionType {
    case push(_ operation: ExploreModalOperation)
    case present(_ operation: ExploreModalOperation)
}

/// 通用转场工具类
class ExploreTransitionUtil: NSObject {
    /// 过渡动画的时长
    public var duration: TimeInterval = 0.23
    /// 交互转场
    public var interactive = false
    /// 可交互对象
    public let interactionTransition = UIPercentDrivenInteractiveTransition()
    /// 导航模式时需要使用，需要在设置其导航的delegate之前赋值，保存之前的代理
    public weak var navigationController: UINavigationController? {
        didSet {
            _naviDelegate = navigationController?.delegate
        }
    }
    
    /// 缓存的导航代理
    private var _naviDelegate: UINavigationControllerDelegate?
    /// 转场类型
    var transitionType: ExploreTransitionType = .push(.presentation)
    
    override init() {
        super.init()
    }
    
    // MARK: - 不同类型的转场
    func transitionAnimation(transitionContext: UIViewControllerContextTransitioning) {
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
        
        let xOffset = containerView.frame.width
//        let yOffset = containerView.frame.height
        var fromTransform = CGAffineTransform.identity
        var toTransform = CGAffineTransform.identity
        
        switch transitionType {
        case .push(let operation):
            if operation == .presentation {
                fromTransform = CGAffineTransform(translationX: 0, y: 0)
                toTransform = CGAffineTransform(translationX: xOffset, y: 0)
                containerView.addSubview(toView)
            } else {
                fromTransform = CGAffineTransform(translationX: xOffset, y: 0)
                toTransform = CGAffineTransform(translationX: 0, y: 0)
                containerView.insertSubview(toView, at: 0)
            }
        case .present(let operation):
            let fromX = operation == .presentation ? 0 : xOffset
            fromTransform = CGAffineTransform(translationX: fromX, y: 0)
            let toX = operation == .presentation ? xOffset : 0
            toTransform = CGAffineTransform(translationX: toX, y: 0)
            if operation == .presentation {
                containerView.addSubview(toView)
            }
        }
        
        toView.transform = toTransform
        UIView.animate(withDuration: duration, animations: {
            fromView.transform = fromTransform
            toView.transform = .identity
        }) { (finished) in
            fromView.transform = .identity
            toView.transform = .identity
            //考虑到转场中途可能取消的情况，转场结束后，恢复视图状态。(通知是否完成转场)
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
    }
    
    func isPresentation() -> Bool {
        switch transitionType {
        case .push(let operation):
            return operation == .presentation
        case .present(let operation):
            return operation == .presentation
        }
    }
}

// MARK: - 动画控制器协议
extension ExploreTransitionUtil: UIViewControllerAnimatedTransitioning {
    // 控制转场动画执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    // 执行动画的地方，最核心的方法。
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionAnimation(transitionContext: transitionContext)
    }
    
    // 如果实现了，会在转场动画结束后调用，可以执行一些收尾工作。
    func animationEnded(_ transitionCompleted: Bool) {
        guard transitionCompleted else { return }
        switch transitionType {
            // 导航模式消失后需要将导航代理复原
        case .push(let operation):
            if operation == .dismissal {
                navigationController?.delegate = _naviDelegate
            }
        default:
            break
        }
    }
}

// MARK: -遵循转场代理方法
/// 自定义模态转场动画时使用
extension ExploreTransitionUtil: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionType = .present(.presentation)
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionType = .present(.dismissal)
        return self
    }
    
    // interactive false:非交互转场， true: 交互转场
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? self.interactionTransition : nil
    }
    
    // interactive false:非交互转场， true: 交互转场
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? self.interactionTransition : nil
    }
}

/// 自定义navigation转场动画时使用
extension ExploreTransitionUtil: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.transitionType = .push(operation == .pop ? .dismissal : .presentation)
        return self
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactive ? self.interactionTransition : nil
    }
}

