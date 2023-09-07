//
//  CRSCusSpoDataScreenView.swift
//  Maxmoo
//
//  Created by 程超 on 2023/9/7.
//

import UIKit

class CRSCusSpoPageView<T: UIView>: UIView, UIScrollViewDelegate {

    var items: [T] = [] {
        didSet {
            refreshAllItems()
        }
    }
    
    var currentItemChanged: ((Int) -> Void)?
    
    var isShowShadow: Bool = false {
        didSet {
            showInsetsShadow(isShowShadow)
        }
    }
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.backgroundColor = .white
        scroll.isPagingEnabled = true
        scroll.clipsToBounds = false
        scroll.delegate = self
        return scroll
    }()
    
    private var itemAutoSize: CGSize = .zero
    private var direction: UIPageViewController.NavigationOrientation = .vertical
    private var shadowInsets: UIEdgeInsets = .zero
    private let shadowTag: CGFloat = 100

    // direction：依据方向生成倒影，只会存在一个方向
    convenience init(frame: CGRect,
                     shadowInsets: UIEdgeInsets = .zero,
                     direction: UIPageViewController.NavigationOrientation = .vertical) {
        self.init(frame: frame)
        self.clipsToBounds = true
        self.direction = direction
        self.shadowInsets = shadowInsets
        createSubviews()
        showInsetsShadow(isShowShadow)
    }
    

    private func createSubviews() {
        if direction == .horizontal {
            let width = self.width - shadowInsets.left - shadowInsets.right
            itemAutoSize = CGSize(width: width, height: self.height)
            scrollView.frame = CGRect(x: shadowInsets.left, y: 0,
                                      width: itemAutoSize.width, height: itemAutoSize.height)
        } else {
            let height = self.height - shadowInsets.top - shadowInsets.bottom
            itemAutoSize = CGSize(width: self.width, height: height)
            scrollView.frame = CGRect(x: 0, y: shadowInsets.top,
                                      width: itemAutoSize.width, height: itemAutoSize.height)
        }
        addSubview(scrollView)
    }
    
    private func showInsetsShadow(_ isShow: Bool) {
        if let layers = self.layer.sublayers {
            for layer in layers where layer.zPosition == shadowTag {
                layer.removeFromSuperlayer()
            }
        }
        if isShow {
            if direction == .horizontal {
                let leftGradient = CAGradientLayer()
                leftGradient.frame = CGRect(x: 0, y: 0, width: shadowInsets.left, height: height)
                leftGradient.startPoint = CGPoint(x: 0, y: 0.5)
                leftGradient.endPoint = CGPoint(x: 1, y: 0.5)
                leftGradient.locations = [0, 1]
                leftGradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
                layer.addSublayer(leftGradient)
                
                let rightGradient = CAGradientLayer()
                rightGradient.frame = CGRect(x: width - shadowInsets.right, y: 0,
                                             width: shadowInsets.right, height: height)
                rightGradient.startPoint = CGPoint(x: 0, y: 0.5)
                rightGradient.endPoint = CGPoint(x: 1, y: 0.5)
                rightGradient.locations = [0, 1]
                rightGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
                layer.addSublayer(rightGradient)
            } else {
                let topGradient = CAGradientLayer()
                topGradient.frame = CGRect(x: 0, y: 0, width: width, height: shadowInsets.top)
                topGradient.startPoint = CGPoint(x: 0.5, y: 0)
                topGradient.endPoint = CGPoint(x: 0.5, y: 1)
                topGradient.locations = [0, 1]
                topGradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
                layer.addSublayer(topGradient)
                
                let bottomGradient = CAGradientLayer()
                bottomGradient.frame = CGRect(x: 0, y: height - shadowInsets.bottom,
                                              width: width, height: shadowInsets.bottom)
                bottomGradient.startPoint = CGPoint(x: 0.5, y: 0)
                bottomGradient.endPoint = CGPoint(x: 0.5, y: 1)
                bottomGradient.locations = [0, 1]
                bottomGradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
                layer.addSublayer(bottomGradient)
            }
        }
    }
    
    
    private func sendCurrentChanged() {
        if let currentIndex = currentIndex(), let change = currentItemChanged {
            change(currentIndex)
        }
    }
    
    private func refreshAllItems() {
        scrollView.removeAllSubviews()
        for (index, view) in items.enumerated() {
            if direction == .horizontal {
                view.center = CGPoint(x: itemAutoSize.width * (CGFloat(index) + 0.5),
                                      y: itemAutoSize.height/2)
                scrollView.addSubview(view)
            } else {
                view.center = CGPoint(x: itemAutoSize.width/2,
                                      y: itemAutoSize.height * (CGFloat(index) + 0.5))
                scrollView.addSubview(view)
            }
        }
        
        if direction == .horizontal {
            scrollView.contentSize = CGSize(width: CGFloat(items.count) * itemAutoSize.width,
                                            height: itemAutoSize.height)
        } else {
            scrollView.contentSize = CGSize(width: itemAutoSize.width,
                                            height: CGFloat(items.count) * itemAutoSize.height)
        }
    }

    private func moveItems(moveItems: [T],
                           isForward: Bool,
                           alphaItems: [T],
                           toAlphaValue: CGFloat,
                           duration: TimeInterval = 0.2,
                           complete: @escaping () -> Void) {
        
        UIView.animate(withDuration: duration) {
            for item in moveItems {
                if self.direction == .horizontal {
                    if isForward {
                        item.left = item.left - self.itemAutoSize.width
                    } else {
                        item.left = item.left + self.itemAutoSize.width
                    }
                } else {
                    if isForward {
                        item.top = item.top - self.itemAutoSize.height
                    } else {
                        item.top = item.top + self.itemAutoSize.height
                    }
                }
            }
            for item in alphaItems {
                item.alpha = toAlphaValue
            }
        } completion: { _ in
            complete()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        sendCurrentChanged()
    }
}

// MARK: - public

extension CRSCusSpoPageView {
        
    public func currentInsert(item: T, animate: Bool = true) {
        var insertIndex: Int = 0
        if let currentIndex = currentIndex() {
            insertIndex = currentIndex
        }
                        
        if direction == .horizontal {
            item.center = CGPoint(x: (CGFloat(insertIndex) + 0.5) * itemAutoSize.width,
                                  y: itemAutoSize.height/2)
        } else {
            item.center = CGPoint(x: itemAutoSize.width/2,
                                  y: (CGFloat(insertIndex) + 0.5) * itemAutoSize.height)
        }
        item.alpha = 0
        scrollView.insertSubview(item, at: 0)
        
        var moveItems: [T] = []
        if let currentItem = currentItem() {
            moveItems.append(currentItem)
        }
        if let nextItem = nextItem() {
            moveItems.append(nextItem)
        }
        
        let duration: TimeInterval = animate ? 0.2 : 0
        self.moveItems(moveItems: moveItems,
                       isForward: false,
                       alphaItems: [item],
                       toAlphaValue: 1,
                       duration: duration) {
            [weak self] in
            guard let self = self else { return }
            self.items.insert(item, at: insertIndex)
            self.refreshAllItems()
            self.sendCurrentChanged()
        }
    }
    
    public func currentDelete(animate: Bool = true,
                              complete: @escaping (T?) -> Void) {
        
        guard let index = currentIndex() else {
            complete(nil)
            return
        }
        guard let currentItem = self.item(index: index) else {
            complete(nil)
            return
        }
        
        let duration: TimeInterval = animate ? 0.2 : 0
        
        var moveItems: [T] = []
        if let nextItem = nextItem() {
            moveItems.append(nextItem)
            if let nextnextItem = item(index: (currentIndex() ?? 100) + 2) {
                moveItems.append(nextnextItem)
            }
            self.moveItems(moveItems: moveItems,
                           isForward: true,
                           alphaItems: [currentItem],
                           toAlphaValue: 0,
                           duration: duration) {
                moveComplete()
            }
        } else if let preItem = previousItem() {
            moveItems.append(preItem)
            if let prepreItem = item(index: (currentIndex() ?? -100) - 2) {
                moveItems.append(prepreItem)
            }
            self.moveItems(moveItems: moveItems,
                           isForward: false,
                           alphaItems: [currentItem],
                           toAlphaValue: 0, duration: duration) {
                moveComplete()
            }
        } else {
            self.moveItems(moveItems: [],
                           isForward: true,
                           alphaItems: [currentItem],
                           toAlphaValue: 0,
                           duration: duration) {
                moveComplete()
            }
        }
        
        // 动画结束
        func moveComplete() {
            if index >= 0 && index < items.count {
                items.remove(at: index)
            }
            refreshAllItems()
            complete(currentItem)
            sendCurrentChanged()
        }
    }
    
    public func currentIndex() -> Int? {
        if items.count == 0 {
            return nil
        }
        
        if direction == .horizontal {
            let offsetX = scrollView.contentOffset.x
            let index = offsetX/itemAutoSize.width
            return Int(index + 0.5)
        } else {
            let offsetY = scrollView.contentOffset.y
            let index = offsetY/itemAutoSize.height
            return Int(index + 0.5)
        }
    }
    
    public func currentItem() -> T? {
        return item(index: currentIndex())
    }
    
    public func previousItem() -> T? {
        if let currentIndex = currentIndex() {
            return item(index: currentIndex - 1)
        } else {
            return nil
        }
    }
    
    public func nextItem() -> T? {
        if let currentIndex = currentIndex() {
            return item(index: currentIndex + 1)
        } else {
            return nil
        }
    }
    
    public func item(index: Int?) -> T? {
        guard let index = index else { return nil }
        guard index >= 0 && index < items.count else { return nil }
        return items[index]
    }
}
