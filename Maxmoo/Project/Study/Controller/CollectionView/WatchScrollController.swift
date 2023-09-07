//
//  WatchScrollController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/9/7.
//

import UIKit
import SnapKit

class WatchScrollController: UIViewController {

    let itemWidth: CGFloat = 250
    let itemHeight: CGFloat = 250
    
    lazy var items: [UIView] = []
    
    lazy var addButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .randomColor
        button.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .randomColor
        button.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        return button
    }()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.backgroundColor = .white
        scroll.isPagingEnabled = true
        scroll.clipsToBounds = false
        return scroll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configData()
    }
    
    // current index
    func currentIndex() -> Int {
        let offsetY = scrollView.contentOffset.y
        let index = offsetY/itemHeight
        return Int(index + 0.5)
    }
    
    
    // current view
    func currentView() -> UIView? {
        let cIndex = currentIndex()
        guard cIndex >= 0 && cIndex < items.count else { return nil }
        return items[cIndex]
    }
    
    // next view
    func nextView() -> UIView? {
        let nIndex = currentIndex() + 1
        guard nIndex >= 0 && nIndex < items.count else { return nil }
        return items[nIndex]
    }
    
    // last view
    func lastView() -> UIView? {
        let lIndex = currentIndex() - 1
        guard lIndex >= 0 && lIndex < items.count else { return nil }
        return items[lIndex]
    }
    
    // refresh
    func refreshAllItems() {
        scrollView.removeAllSubviews()
        var bottom: CGFloat = 0
        for (index, view) in items.enumerated() {
            view.frame = CGRect(x: 0, y: CGFloat(index) * itemHeight,
                                width: itemWidth, height: itemHeight)
            scrollView.addSubview(view)
            bottom = view.bottom
        }
        scrollView.contentSize = CGSize(width: itemWidth, height: bottom)
    }
}

extension WatchScrollController {
    
    func configData() {
        for index in 0...5 {
            let view = UIView(frame: CGRect(x: 0, y: CGFloat(index) * itemHeight,
                                            width: itemWidth, height: itemHeight))
            view.backgroundColor = .randomColor
            view.addSubview(textLabel(text: "\(index)"))
            scrollView.addSubview(view)
            scrollView.contentSize = CGSize(width: itemWidth, height: view.bottom)
            items.append(view)
        }
    }
    
    func setupUI() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(120)
            make.width.height.equalTo(100)
        }
        
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.top.equalTo(120)
            make.width.height.equalTo(100)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.width.height.equalTo(itemWidth)
            make.center.equalToSuperview()
        }
    }
    
    func textLabel(text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: itemHeight/2 - 20, width: itemWidth, height: 40))
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return label
    }
    
    func moveUpViews(_ views: [UIView], isUp: Bool = true, complete: @escaping () -> Void) {
        UIView.animate(withDuration: 0.2) {
            for view in views {
                if isUp {
                    view.top = view.top - self.itemHeight
                } else {
                    view.top = view.top + self.itemHeight
                }
            }
        } completion: { _ in
            complete()
        }
    }
        
    @objc
    func addItem() {
        let index = currentIndex() + 1
        guard let currentView = currentView() else { return }
        let view = UIView(frame: CGRect(x: 0, y: CGFloat(index) * itemHeight,
                                        width: itemWidth, height: itemHeight))
        view.backgroundColor = .randomColor
        view.addSubview(textLabel(text: "\(Int.random(in: 10...100))"))
        scrollView.addSubview(view)
        moveUpViews([currentView, view]) {
            [weak self] in
            guard let self = self else { return }
            self.items.insert(view, at: index)
            self.refreshAllItems()
            self.scrollView.contentOffset.y += self.itemHeight
        }
    }
    
    @objc
    func deleteItem() {
        let index = currentIndex()
        guard let currentView = currentView() else { return }
        if let nextView = nextView() {
            moveUpViews([currentView, nextView]) {
                [weak self] in
                guard let self = self else { return }
                self.items.remove(at: index)
                self.refreshAllItems()
            }
        } else if let lastView = lastView() {
            moveUpViews([lastView, currentView], isUp: false) {
                [weak self] in
                guard let self = self else { return }
                self.items.remove(at: index)
                self.refreshAllItems()
            }
        } else {
            items.remove(at: index)
            refreshAllItems()
        }
    }
}
