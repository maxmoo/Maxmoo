//
//  UIViewController+CC.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit

func rootController() -> UIViewController? {
    let controller = UIApplication.shared.delegate?.window??.rootViewController
    return controller
}

func currentShowingController() -> UIViewController? {
    return rootController()?.currentShowingViewController()
}

extension UIViewController {
    
    // 寻找当前显示的viewController
    func currentShowingViewController() -> UIViewController? {
        var currentShowingVC: UIViewController?
        if let vc = self.presentedViewController {
            currentShowingVC = vc.currentShowingViewController()
        } else if self is UITabBarController {
            let root = self as! UITabBarController
            currentShowingVC = root.selectedViewController?.currentShowingViewController()
        } else if self is UINavigationController {
            let root = self as! UINavigationController
            currentShowingVC = root.visibleViewController?.currentShowingViewController()
        } else {
            currentShowingVC = self
        }
        return currentShowingVC
    }
    
    // 兼容present和push Back to pre
    // isTotalBack：如果present是navi，是否dismiss navi
    func compatibleBack(isTotalBack: Bool = false,
                        animated: Bool = true,
                        completion: (() -> Void)? = nil) {
         if let navi = self.navigationController {
            if navi.presentingViewController != nil {
                // 导航控制器为present
                if isTotalBack {
                    // 全部返回
                    navi.dismiss(animated: animated, completion: completion)
                } else {
                    // 逐个返回
                    if navi.viewControllers.count > 1 {
                        navi.popViewController(animated: animated)
                        if let completion = completion {
                            completion()
                        }
                    } else {
                        navi.dismiss(animated: animated, completion: completion)
                    }
                }
            } else {
                // 导航控制器不是present直接pop
                navi.popViewController(animated: animated)
                if let completion = completion {
                    completion()
                }
            }
        } else if self.presentingViewController != nil {
            // 为present直接dismiss返回
            self.dismiss(animated: animated, completion: completion)
        }
    }
}

extension UIViewController {

    var hasSafeArea: Bool {
        guard
            #available(iOS 11.0, tvOS 11.0, *)
            else {
                return false
            }
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
    
    var safeAreaInsets: UIEdgeInsets? {
        return UIApplication.shared.delegate?.window??.safeAreaInsets
    }
    
    // bottom safeArea
    var safeAreaBottom: CGFloat {
        get {
            if let area = safeAreaInsets {
                return area.bottom
            } else {
                return 0
            }
        }
    }
    
    // top safeArea
    var safeAreaTop: CGFloat {
        get {
            if let area = safeAreaInsets {
                return area.top
            } else {
                return 20
            }
        }
    }
}
