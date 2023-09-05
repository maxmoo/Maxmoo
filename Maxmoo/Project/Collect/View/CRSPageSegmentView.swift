//
//  CRSPageSegment.swift
//  Maxmoo
//
//  Created by 程超 on 2023/9/5.
//

import UIKit

protocol CRSPageSegmentProtocol: NSObjectProtocol {
    var isSelect: Bool { get set }
}

class CRSPageSegmentItem: UIView, CRSPageSegmentProtocol {
    
    var isSelect: Bool {
        get {
            return _isSelect
        }
        
        set {
            _isSelect = newValue
        }
    }
    
    private var _isSelect: Bool = false {
        didSet {
            setStyle(select: _isSelect)
        }
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private var title: String = ""
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.title = title
        createSubviews()
    }
    
    private func createSubviews() {
        let titleWidth = title.width(font: titleLabel.font)
        titleLabel.text = title
        titleLabel.frame = CGRect(x: 16, y: 4, width: titleWidth, height: 24)
        self.addSubview(titleLabel)
        self.frame = CGRect(x: 0, y: 0, width: titleLabel.width + 32, height: titleLabel.height + 8)
        titleLabel.centerX = self.width/2
        self.layer.cornerRadius = self.height/2
        setStyle(select: false)
    }
    
    private func setStyle(select: Bool) {
        if select {
            backgroundColor = .red
            titleLabel.textColor = .white
        } else {
            backgroundColor = .black
            titleLabel.textColor = .lightGray
        }
    }
    
}

class CRSPageSegmentView: UIView {

    var insets: UIEdgeInsets = .zero {
        didSet {
            refreshItems()
        }
    }
    
    var gap: CGFloat = 16 {
        didSet {
            refreshItems()
        }
    }
    
    private lazy var orientation: UIPageViewController.NavigationOrientation = .horizontal
    private lazy var items: [UIView] = []
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: self.bounds)
        scroll.showsHorizontalScrollIndicator = false
        scroll.backgroundColor = .clear
        return scroll
    }()
    
    convenience init<T: UIView>(frame: CGRect,
                                orientation: UIPageViewController.NavigationOrientation,
                                items: [T]) where T: CRSPageSegmentProtocol {
        self.init(frame: frame)
        self.orientation = orientation
        self.items = items
        self.addSubview(scrollView)
        refreshItems()
    }
    
    private func refreshItems() {
        var offset: CGFloat = 0
        switch orientation {
        case .horizontal:
            offset += insets.left
            for item in items {
                item.left = offset
                item.centerY = scrollView.height/2
                scrollView.addSubview(item)
                let tap = UITapGestureRecognizer(target: self, action: #selector(itemTap))
                item.addGestureRecognizer(tap)
                offset = (item.right + gap)
            }
            offset = offset - gap + insets.right
            scrollView.contentSize = CGSize(width: offset, height: scrollView.height)
        case .vertical:
            offset += insets.top
            for item in items {
                item.top = offset
                item.centerX = scrollView.width/2
                scrollView.addSubview(item)
                let tap = UITapGestureRecognizer(target: self, action: #selector(itemTap))
                item.addGestureRecognizer(tap)
                offset = (item.bottom + gap)
            }
            offset = offset - gap + insets.bottom
            scrollView.contentSize = CGSize(width: scrollView.width, height: offset)
        default:
            break
        }
    }
    
    @objc
    private func itemTap(_ tap: UITapGestureRecognizer) {
        for itemView in scrollView.subviews {
            if let view = itemView as? CRSPageSegmentProtocol {
                view.isSelect = false
            }
        }
        
        if let tapView = tap.view as? CRSPageSegmentProtocol {
            tapView.isSelect = true
            scrollToCenter(tap.view?.center)
        }
    }
    
    private func scrollToCenter(_ point: CGPoint?) {
        guard let point = point else { return }
        let rect = CGRect(x: point.x - scrollView.width/2, y: 0, width: scrollView.width, height: scrollView.height)
        scrollView.scrollRectToVisible(rect, animated: true)
    }
}
