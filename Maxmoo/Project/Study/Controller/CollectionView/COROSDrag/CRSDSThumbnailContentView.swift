//
//  CRSDSThumbnailContentView.swift
//  Maxmoo
//
//  Created by 程超 on 2024/12/17.
//

import UIKit
import SnapKit

class CRSDSThumbnailContentView: UIView {

    enum ContentStyle {
        case watch
        case dura
    }
    
    enum ItemType {
        case normal
        case empty
        case add
    }
    
    public var isSelect: Bool = false {
        didSet {
            refreshSelect()
        }
    }
    
    public var index: Int = 0 {
        didSet {
            refreshIndex()
        }
    }
    
    public var type: ItemType = .normal
    
    public var contentView: UIView = {
        let content = UIView(frame: .zero)
        content.backgroundColor = .clear
        return content
    }()
    
    private var leftIconView: UIImageView = {
        let icon = UIImageView(frame: .zero)
        icon.backgroundColor = .red
        return icon
    }()
    
    private var indexLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.backgroundColor = .darkGray
        return label
    }()
    
    private var contentSize: CGSize = .zero
    private var style: ContentStyle = .watch
    
    convenience init(frame: CGRect, contentSize: CGSize, style: ContentStyle, type: ItemType = .normal) {
        self.init(frame: frame)
        self.contentSize = contentSize
        self.style = style
        self.type = type
        if type != .empty {
            self.setupUI()
        }
    }

    public func setupUI() {
        addSubview(leftIconView)
        leftIconView.snp.makeConstraints { make in
            make.left.equalTo(5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(14)
        }
        
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(contentSize.width)
            make.height.equalTo(contentSize.height)
            make.right.equalToSuperview()
        }
        contentView.setNeedsLayout()
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.borderWidth = 0
        
        addSubview(indexLabel)
        switch style {
        case .watch:
            indexLabel.snp.makeConstraints { make in
                make.left.equalTo(contentView.snp.left)
                make.top.equalTo(contentView.snp.top)
                make.width.height.equalTo(20)
            }
            indexLabel.setNeedsLayout()
            indexLabel.allCorner(radius: 10)
        case .dura:
            indexLabel.snp.makeConstraints { make in
                make.left.equalTo(contentView.snp.left)
                make.top.equalTo(contentView.snp.top)
                make.width.height.equalTo(20)
            }
            indexLabel.setNeedsLayout()
            indexLabel.allCorner(radius: 4)
        }
    }
    
    private func refreshSelect() {
        guard type != .empty else { return }
        
        if isSelect {
            switch style {
            case .watch:
                contentView.layer.cornerRadius = contentView.height / 2.0
            case .dura:
                contentView.layer.cornerRadius = 4
            }
            contentView.layer.borderColor = UIColor.blue.cgColor
            contentView.layer.borderWidth = 2
            indexLabel.backgroundColor = .blue
        } else {
            contentView.layer.borderColor = UIColor.clear.cgColor
            contentView.layer.borderWidth = 0
            indexLabel.backgroundColor = .darkGray
        }
    }
    
    private func refreshIndex() {
        guard type != .empty else { return }

        indexLabel.text = "\(index)"
    }
}
