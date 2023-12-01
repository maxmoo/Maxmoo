//
//  CRSCusSpoPageIndicator.swift
//  Maxmoo
//
//  Created by 程超 on 2023/9/7.
//

import UIKit

class CRSCusSpoPageIndicator: UIView {

    lazy var totalCount: Int = 0
    
    lazy var selectIndex: Int = 0 {
        didSet {
            selectAt(index: selectIndex)
        }
    }
    
    private lazy var backView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var itemSize: CGSize = CGSize(width: 8, height: 8) {
        didSet {
            refreshSubviews()
        }
    }
    
    lazy var gap: CGFloat = 8 {
        didSet {
            refreshSubviews()
        }
    }
    
    lazy var selectColor: UIColor = .blue {
        didSet {
            selectIndex = selectIndex
        }
    }
    
    lazy var normalColor: UIColor = .darkGray {
        didSet {
            selectIndex = selectIndex
        }
    }
    
    private lazy var items: [UIView] = []
    
    convenience init(frame: CGRect, count: Int) {
        self.init(frame: frame)
        totalCount = count
        addSubview(backView)
        refreshSubviews()
        selectAt(index: 0)
    }

    private func refreshSubviews() {
        items.removeAll()
        backView.removeAllSubviews()
        
        var totalHei: CGFloat = 0
        for index in 0..<totalCount {
            let y = CGFloat(index) * (itemSize.height + gap)
            let view = UIView(frame: CGRect(x: 0, y: y, width: itemSize.width, height: itemSize.height))
            view.backgroundColor = normalColor
            backView.addSubview(view)
            items.append(view)
            totalHei = view.bottom
        }
        
        backView.frame = CGRect(x: 0, y: 0, width: itemSize.width, height: totalHei)
        backView.center = self.bounds.center
    }
    
    private func selectAt(index: Int) {
        for (ind, item) in items.enumerated() {
            if ind == index {
                item.backgroundColor = selectColor
            } else {
                item.backgroundColor = normalColor
            }
        }
    }
    
    public func refresh(total: Int, selectIndex: Int) {
        if total != totalCount {
            self.totalCount = total
            refreshSubviews()
        }
        self.selectIndex = selectIndex
    }
    
}
