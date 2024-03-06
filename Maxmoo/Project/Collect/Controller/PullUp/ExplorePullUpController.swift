//
//  ExplorePullUpController.swift
//  MapboxDemo
//
//  Created by 程超 on 2022/7/18.
//  下方弹出视图的父视图，增加了手势动画
// swiftlint:disable all

import UIKit

open class ExplorePullUpController: UIViewController, UIGestureRecognizerDelegate {
    
    public enum Action {
        case add
        case remove
        case move
    }

    open var pullUpControllerPreferredSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 400)
    }
    
    open var pullUpControllerPreferredLandscapeFrame: CGRect {
        return CGRect(x: 10, y: 10, width: 300, height: UIScreen.main.bounds.height - 20)
    }
    
    open var pullUpControllerMiddleStickyPoints: [CGFloat] = []
    
    open var pullUpControllerBounceOffset: CGFloat {
        return 0
    }
    
    open var pullUpControllerCurrentPointOffset: CGFloat {
        guard
            let parentViewHeight = parent?.view.frame.height
            else { return 0 }
        return parentViewHeight - (topConstraint?.constant ?? 0)
    }

    open var pullUpControllerSkipPointVerticalVelocityThreshold: CGFloat {
        return 700
    }
    
    open var isShow = false
    
    open var panGestureEnable = true
    
    open var animationDuration: TimeInterval = 0.28
    
    open var tempHeight: CGFloat = 0 {
        didSet {
            if let superView = view.superview {
                let height = superView.frame.height - tempHeight
                if !pullUpControllerMiddleStickyPoints.contains(height) {
                    pullUpControllerMiddleStickyPoints.append(height)
                }
                setTempTopOffset(tempHeight, animationDuration: animationDuration)
            }
        }
    }
    
    open func removeTempHeight(_ height: CGFloat) {
        if let superView = view.superview {
            let hei = superView.frame.height - height
            pullUpControllerMiddleStickyPoints = pullUpControllerMiddleStickyPoints.filter {
               $0 != hei
            }
        }
    }
    
    open func recoveryHeight() {
        if let initHeight = initialStickyPointOffset {
            if let superView = view.superview {
                let height = superView.frame.height - initHeight
                setTopOffset(height, animationDuration: animationDuration)
            }
        }
    }
    
    // MARK: - Public properties
    public final var pullUpControllerAllStickyPoints: [CGFloat] {
        var sc_allStickyPoints = [initialStickyPointOffset, pullUpControllerPreferredSize.height].compactMap { $0 }
        sc_allStickyPoints.append(contentsOf: pullUpControllerMiddleStickyPoints)
        return sc_allStickyPoints.sorted()
    }
    
    private var leftConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var panGestureRecognizer: UIPanGestureRecognizer?
    
    private var isPortrait: Bool {
        return UIScreen.main.bounds.height > UIScreen.main.bounds.width
    }
    
    private var portraitPreviousStickyPointIndex: Int?
    
    fileprivate weak var internalScrollView: UIScrollView?
    
    private var initialInternalScrollViewContentOffset: CGPoint = .zero
    var initialStickyPointOffset: CGFloat? = kScreenHeight
    
    private let nearlyScale: CGFloat = 0.7
    private var currentStickyPointIndex: Int {
        let stickyPointTreshold = (self.parent?.view.frame.height ?? 0) - (topConstraint?.constant ?? 0)
        for index in 0..<pullUpControllerAllStickyPoints.count {
            let point = pullUpControllerAllStickyPoints[index]
            if point > stickyPointTreshold {
                let downPoint = pullUpControllerAllStickyPoints[index-1]
                if stickyPointTreshold - downPoint > (point - downPoint)*nearlyScale  {
                    return index
                }else{
                    return index - 1
                }
            }
        }
        return pullUpControllerAllStickyPoints.count-1
        //距离谁最近靠向谁
//        let stickyPointsLessCurrentPosition = pullUpControllerAllStickyPoints.map { abs($0 - stickyPointTreshold) }
//        guard let minStickyPointDifference = stickyPointsLessCurrentPosition.min() else { return 0 }
//        return stickyPointsLessCurrentPosition.firstIndex(of: minStickyPointDifference) ?? 0
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isShow = true
    }
    
    // 即将显示
    open func pullUpControllerWillShow(){}
    // 已经显示
    open func pullUpControllerDidShow(){}
    // 临时状态，收缩到底部但未消失
    open func pullUpControllerWillShrink(){}
    // 临时状态，收缩恢复显示
    open func pullUpControllerShrinkRecovery(){}
    // MARK: - Open methods
    open func pullUpControllerWillMove(to point: CGFloat) { }

    open func pullUpControllerDidMove(to point: CGFloat) { }

    open func pullUpControllerDidDrag(to point: CGFloat) { }
    
    open func pullUpControllerWillRemove() {}
    
    open func pullUpControllerDidRemove() {}

    open func pullUpControllerMoveToVisiblePoint(_ visiblePoint: CGFloat, animated: Bool, completion: (() -> Void)?) {
        guard
            isPortrait,
            let parentViewHeight = parent?.view.frame.height
            else { return }
        topConstraint?.constant = parentViewHeight - visiblePoint
        pullUpControllerWillMove(to: visiblePoint)
        pullUpControllerAnimate(
            action: .move,
            withDuration: animated ? animationDuration : 0,
            animations: { [weak self] in
                self?.parent?.view?.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                self?.pullUpControllerDidMove(to: visiblePoint)
                completion?()
        })
    }
    
    open func updatePreferredFrameIfNeeded(animated: Bool) {
        guard
            let parentView = parent?.view
            else { return }
        refreshConstraints(newSize: parentView.frame.size,
                           customTopOffset: parentView.frame.size.height - (pullUpControllerAllStickyPoints.first ?? 0))
        
        pullUpControllerAnimate(
            action: .move,
            withDuration: animated ? 0.3 : 0,
            animations: { [weak self] in
                self?.view.layoutIfNeeded()
            },
            completion: nil)
    }
    
    open func pullUpControllerAnimate(action: Action,
                                      withDuration duration: TimeInterval,
                                      animations: @escaping () -> Void,
                                      completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: duration, animations: animations, completion: completion)
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let isNewSizePortrait = size.height > size.width
        var targetStickyPoint: CGFloat?
        
        if !isNewSizePortrait {
            portraitPreviousStickyPointIndex = currentStickyPointIndex
        } else if
            let portraitPreviousStickyPointIndex = portraitPreviousStickyPointIndex,
            portraitPreviousStickyPointIndex < pullUpControllerAllStickyPoints.count
        {
            targetStickyPoint = pullUpControllerAllStickyPoints[portraitPreviousStickyPointIndex]
            self.portraitPreviousStickyPointIndex = nil
        }
        
        coordinator.animate(alongsideTransition: { [weak self] coordinator in
            self?.refreshConstraints(newSize: size)
            if let targetStickyPoint = targetStickyPoint {
                self?.pullUpControllerMoveToVisiblePoint(targetStickyPoint, animated: true, completion: nil)
            }
        })
    }
    
    // MARK: - Setup
    
    fileprivate func setup(superview: UIView, initialStickyPointOffset: CGFloat) {
        isShow = true
        self.initialStickyPointOffset = initialStickyPointOffset
        view.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(view)
        view.frame = CGRect(origin: CGPoint(x: view.frame.origin.x,
                                            y: superview.bounds.height),
                            size: CGSize(width: view.frame.size.width,
                                         height: view.frame.size.height))
        
        setupPanGestureRecognizer()
        setupConstraints()
        refreshConstraints(newSize: superview.frame.size,
                           customTopOffset: superview.frame.height - initialStickyPointOffset)
    }
    
    fileprivate func addInternalScrollViewPanGesture() {
        internalScrollView?.panGestureRecognizer.addTarget(self, action: #selector(handleScrollViewGestureRecognizer(_:)))
    }
    
    fileprivate func removeInternalScrollViewPanGestureRecognizer() {
        internalScrollView?.panGestureRecognizer.removeTarget(self, action: #selector(handleScrollViewGestureRecognizer(_:)))
    }
    
    private func setupPanGestureRecognizer() {
        addInternalScrollViewPanGesture()
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(_:)))
        panGestureRecognizer?.delegate = self
        panGestureRecognizer?.minimumNumberOfTouches = 1
        panGestureRecognizer?.maximumNumberOfTouches = 1
        if let panGestureRecognizer = panGestureRecognizer {
            view.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view is ExplorePullUpContentProtocol {
            let pullUpContent = touch.view as! ExplorePullUpContentProtocol
            if pullUpContent.isCutPullUpTouches {
                return false
            } else {
                return true
            }
        }
        return true
    }
    
    private func setupConstraints() {
        guard
            let parentView = parent?.view
            else { return }
        
        topConstraint = view.topAnchor.constraint(equalTo: parentView.topAnchor)
        leftConstraint = view.leftAnchor.constraint(equalTo: parentView.leftAnchor)
        widthConstraint = view.widthAnchor.constraint(equalToConstant: pullUpControllerPreferredSize.width)
        heightConstraint = view.heightAnchor.constraint(equalToConstant: pullUpControllerPreferredSize.height)
        heightConstraint?.priority = .defaultLow
        bottomConstraint = parentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        let constraintsToActivate = [topConstraint,
                                     leftConstraint,
                                     widthConstraint,
                                     heightConstraint,
                                     bottomConstraint].compactMap { $0 }
        NSLayoutConstraint.activate(constraintsToActivate)
    }
    
    private func refreshConstraints(newSize: CGSize, customTopOffset: CGFloat? = nil) {
        if newSize.height > newSize.width {
            setPortraitConstraints(parentViewSize: newSize, customTopOffset: customTopOffset)
        } else {
            setLandscapeConstraints()
        }
    }
    
    private func nearestStickyPointY(yVelocity: CGFloat) -> CGFloat {
        var currentStickyPointIndex = self.currentStickyPointIndex
        if abs(yVelocity) > pullUpControllerSkipPointVerticalVelocityThreshold {
            if yVelocity > 0 {
                currentStickyPointIndex = max(currentStickyPointIndex - 1, 0)
            } else {
                currentStickyPointIndex = min(currentStickyPointIndex + 1, pullUpControllerAllStickyPoints.count - 1)
            }
        }
        
        return (parent?.view.frame.height ?? 0) - pullUpControllerAllStickyPoints[currentStickyPointIndex]
    }
    
    @objc private func handleScrollViewGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard
            isPortrait,
            let scrollView = internalScrollView,
            let topConstraint = topConstraint,
            let lastStickyPoint = pullUpControllerAllStickyPoints.last,
            let parentViewHeight = parent?.view.bounds.height
            else { return }
        
        scrollView.bounces = false
        
        let isFullOpened = topConstraint.constant <= parentViewHeight - lastStickyPoint
        let yTranslation = gestureRecognizer.translation(in: scrollView).y
        let isScrollingDown = gestureRecognizer.velocity(in: scrollView).y > 0
        
        let shouldDragViewDown = isScrollingDown && scrollView.contentOffset.y <= 0
        
        let shouldDragViewUp = !isScrollingDown && !isFullOpened
        let shouldDragView = shouldDragViewDown || shouldDragViewUp
        
        if shouldDragView {
            scrollView.bounces = false
            scrollView.setContentOffset(.zero, animated: false)
        }
        
        switch gestureRecognizer.state {
        case .began:
            initialInternalScrollViewContentOffset = scrollView.contentOffset
        case .changed:
            guard
                shouldDragView
                else { break }
            setTopOffset(topConstraint.constant + yTranslation - initialInternalScrollViewContentOffset.y)
            gestureRecognizer.setTranslation(initialInternalScrollViewContentOffset, in: scrollView)
            
        case .ended:
            if scrollView.contentOffset.y <= 30 {
                goToNearestStickyPoint(verticalVelocity: gestureRecognizer.velocity(in: view).y)
            }
            
        default:
            break
        }
        
    }
    
    @objc private func handlePanGestureRecognizer(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard panGestureEnable else { return }
        guard isPortrait, let topConstraint = topConstraint else { return }
        
        let yTranslation = gestureRecognizer.translation(in: view).y
        
        switch gestureRecognizer.state {
        case .changed:
            setTopOffset(topConstraint.constant + yTranslation, allowBounce: true)
            gestureRecognizer.setTranslation(.zero, in: view)
            
        case .ended:
            goToNearestStickyPoint(verticalVelocity: gestureRecognizer.velocity(in: view).y)
            
        default:
            break
        }
    }
    
    private func goToNearestStickyPoint(verticalVelocity: CGFloat) {
        guard
            isPortrait,
            let topConstraint = topConstraint
            else { return }
        let targetTopOffset = nearestStickyPointY(yVelocity: verticalVelocity)  // v = px/s
        let distanceToConver = topConstraint.constant - targetTopOffset // px
        let animationDuration = max(0.08, min(0.3, TimeInterval(abs(distanceToConver/verticalVelocity)))) // s = px/v
        setTopOffset(targetTopOffset, animationDuration: animationDuration)
    }
    
    private func setTempTopOffset(_ value: CGFloat,
                                  animationDuration: TimeInterval? = nil,
                                  allowBounce: Bool = false) {
        guard
            let parentViewHeight = parent?.view.frame.height
            else { return }
   
        topConstraint?.constant = value
        
        let targetPoint = parentViewHeight - value

        let shouldNotifyObserver = animationDuration != nil
        topConstraint?.constant = value
        pullUpControllerDidDrag(to: targetPoint)
        if shouldNotifyObserver {
            pullUpControllerWillMove(to: targetPoint)
        }
        pullUpControllerAnimate(
            action: .move,
            withDuration: animationDuration ?? 0,
            animations: { [weak self] in
                self?.parent?.view.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                if shouldNotifyObserver {
                    self?.pullUpControllerDidMove(to: targetPoint)
                }
            }
        )
    }
    
    func setTopOffset(_ value: CGFloat,
                              animationDuration: TimeInterval? = nil,
                              allowBounce: Bool = false) {
        guard
            let parentViewHeight = parent?.view.frame.height
            else { return }
        let value: CGFloat = {
            guard
                let firstStickyPoint = pullUpControllerAllStickyPoints.first,
                let lastStickyPoint = pullUpControllerAllStickyPoints.last
                else {
                    return value
                }
            let bounceOffset = allowBounce ? pullUpControllerBounceOffset : 0
            let minValue = parentViewHeight - lastStickyPoint - bounceOffset
            let maxValue = parentViewHeight - firstStickyPoint + bounceOffset
            return max(min(value, maxValue), minValue)
        }()
        let targetPoint = parentViewHeight - value

        let shouldNotifyObserver = animationDuration != nil
        topConstraint?.constant = value
        pullUpControllerDidDrag(to: targetPoint)
        if shouldNotifyObserver {
            pullUpControllerWillMove(to: targetPoint)
        }
        pullUpControllerAnimate(
            action: .move,
            withDuration: animationDuration ?? 0,
            animations: { [weak self] in
                self?.parent?.view.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                if shouldNotifyObserver {
                    self?.pullUpControllerDidMove(to: targetPoint)
                }
            }
        )
    }
    
    private func setPortraitConstraints(parentViewSize: CGSize, customTopOffset: CGFloat? = nil) {
        if let customTopOffset = customTopOffset {
            topConstraint?.constant = customTopOffset
        } else {
            topConstraint?.constant = nearestStickyPointY(yVelocity: 0)
        }
        leftConstraint?.constant = (parentViewSize.width - min(pullUpControllerPreferredSize.width, parentViewSize.width))/2
        widthConstraint?.constant = pullUpControllerPreferredSize.width
        heightConstraint?.constant = pullUpControllerPreferredSize.height
        heightConstraint?.priority = .defaultLow
        bottomConstraint?.constant = -1
    }
    
    private func setLandscapeConstraints() {
        guard
            let parentViewHeight = parent?.view.frame.height
            else { return }
        let landscapeFrame = pullUpControllerPreferredLandscapeFrame
        topConstraint?.constant = landscapeFrame.origin.y
        leftConstraint?.constant = landscapeFrame.origin.x
        widthConstraint?.constant = landscapeFrame.width
        heightConstraint?.constant = landscapeFrame.height
        heightConstraint?.priority = .defaultHigh
        bottomConstraint?.constant = parentViewHeight - landscapeFrame.height - landscapeFrame.origin.y
    }
    
    func hide() {
        guard
            let parentViewHeight = parent?.view.frame.height
            else { return }
        topConstraint?.constant = parentViewHeight
        
        if let parent = self.parent {
            parent.pullUpControllers = parent.pullUpControllers.filter{$0 != self}
        }
    }
    
    open func removeHeight(_ height: CGFloat) {
        if let superView = view.superview {
            let h = superView.frame.height - height
            pullUpControllerMiddleStickyPoints = pullUpControllerMiddleStickyPoints.filter {$0 != h}
        }
    }

}

extension UIViewController {
    
    private static var pullUpControllersId: Void?
    var pullUpControllers: [UIViewController] {
        get {
            (objc_getAssociatedObject(self, &Self.pullUpControllersId) as? [UIViewController]) ?? []
        }
        set {
            (objc_setAssociatedObject(self, &Self.pullUpControllersId, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }

    public func containsController(_ controller: UIViewController) -> Bool {
        for child in children {
            if child == controller { return true }
        }
         return false
    }
    
    public func addPullUpController(_ pullUpController: ExplorePullUpController,
                                  initialStickyPointOffset: CGFloat,
                                  animated: Bool,
                                  completion: ((Bool) -> Void)? = nil) {
        assert(!(self is UITableViewController), "It's not possible to attach a PullUpController to a UITableViewController")
        
        if containsController(pullUpController) {
            pullUpControllers = pullUpControllers.filter{$0 != pullUpController}
            removePullUpController(pullUpController, animated: false)
        }

        pullUpControllers.append(pullUpController)
        
        addChild(pullUpController)
        pullUpController.setup(superview: view, initialStickyPointOffset: initialStickyPointOffset)
        pullUpController.pullUpControllerWillShow()
        if animated {
            pullUpController.pullUpControllerAnimate(
                action: .add,
                withDuration: pullUpController.animationDuration,
                animations: { [weak self] in
                    self?.view.layoutIfNeeded()
                },
                completion: { didComplete in
                    pullUpController.didMove(toParent: self)
                    completion?(didComplete)
                    pullUpController.pullUpControllerDidShow()
                }
            )
        } else {
            view.layoutIfNeeded()
            pullUpController.didMove(toParent: self)
            completion?(true)
            pullUpController.pullUpControllerDidShow()
        }
    }
    
    public func removePullUpController(_ pullUpController: ExplorePullUpController,
                                     animated: Bool,
                                     isNoti: Bool = true,
                                     completion: ((Bool) -> Void)? = nil) {
        
        if isNoti {
            pullUpController.pullUpControllerWillRemove()
        }

        pullUpController.hide()
        if animated {
            pullUpController.pullUpControllerAnimate(
                action: .remove,
                withDuration: pullUpController.animationDuration,
                animations: { [weak self] in
                    self?.view.layoutIfNeeded()
                },
                completion: { [weak self] didComplete in
                    pullUpController.willMove(toParent: nil)
                    pullUpController.view.removeFromSuperview()
                    pullUpController.removeFromParent()
                    pullUpController.isShow = false
                    if isNoti {
                        pullUpController.pullUpControllerDidRemove()
                    }
                    completion?(didComplete)
                    guard let self = self else {return}
            })
        } else {
            view.layoutIfNeeded()
            pullUpController.willMove(toParent: nil)
            pullUpController.view.removeFromSuperview()
            pullUpController.removeFromParent()
            if isNoti {
                pullUpController.pullUpControllerDidRemove()
            }
            completion?(true)
        }
    }
    
}

extension UIScrollView {
    
    public func attach(to pullUpController: ExplorePullUpController) {
        pullUpController.internalScrollView?.detach(from: pullUpController)
        pullUpController.internalScrollView = self
        pullUpController.addInternalScrollViewPanGesture()
    }
    
    public func detach(from pullUpController: ExplorePullUpController) {
        pullUpController.removeInternalScrollViewPanGestureRecognizer()
        pullUpController.internalScrollView = nil
    }

}

protocol ExplorePullUpContentProtocol: NSObjectProtocol {
    var isCutPullUpTouches: Bool {get set}
}
