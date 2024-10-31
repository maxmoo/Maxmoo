//
//  CRSSegmentMemberSelectView.swift
//  Maxmoo
//
//  Created by 程超 on 2024/8/20.
//

import UIKit
import SnapKit

protocol CRSSegmentMemberSelectDelegate: NSObjectProtocol {
    func didSelectItem()
}

class CRSSegmentMemberSelectView: UIView {

    weak var selectDelegate: CRSSegmentMemberSelectDelegate?
    
    // title
    lazy var titleLabel = {
        let label = UILabel(frame: .zero)
        label.text = "选择挑战对象"
        return label
    }()
    
    // tip
    lazy var tipImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .red
        return imageView
    }()
    
    // scroll
    lazy var memberScrollView: UIScrollView = {
        let memberScroll = UIScrollView(frame: .zero)
        return memberScroll
    }()
    
    // item
    private var items: [CRSSegmentMemberSelectItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        refreshItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(14)
            make.top.equalTo(0)
            make.height.equalTo(20)
        }
        
        addSubview(tipImageView)
        tipImageView.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.width.height.equalTo(16)
        }
        
        addSubview(memberScrollView)
        memberScrollView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.right.equalToSuperview()
            make.height.equalTo(self.height - 20 - 14)
        }
    }
    
    private func refreshItems() {
        var tempItems: [CRSSegmentMemberSelectItem] = []
        for index in 0..<10 {
            let item = CRSSegmentMemberSelectItem()
            item.backgroundColor = .randomColor
            item.tag = index + 100
            item.addTapGesture { [weak self] in
                guard let self else { return }
                self.itemClicked(item: item)
            }
            tempItems.append(item)
        }
        
        let itemWidth: CGFloat = 128
        let leftRightGap: CGFloat = 14
        let gap: CGFloat = 8
        var contentY: CGFloat = leftRightGap
        for (index, item) in tempItems.enumerated() {
            memberScrollView.addSubview(item)
            item.snp.makeConstraints { make in
                make.left.equalTo(contentY)
                make.height.equalToSuperview()
                make.width.equalTo(itemWidth)
            }
            item.layer.cornerRadius = 8
            item.layer.masksToBounds = true
            contentY = CGFloat((index + 1)) * (itemWidth + gap) + leftRightGap
        }
        
        memberScrollView.contentSize = CGSizeMake(contentY - gap + leftRightGap, self.height - 20 - 14)
        
        items = tempItems
    }
    
    private func itemClicked(item: CRSSegmentMemberSelectItem) {
        for it in items {
            if it == item {
                it.isSelect = true
            } else {
                it.isSelect = false
            }
        }
        
        if let selectDelegate {
            selectDelegate.didSelectItem()
        }
    }
    
}


class CRSSegmentMemberSelectItem: UIView {
    
    lazy var identityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "  PR  "
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Tom sesasdada!"
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "19:90 908:9090'"
        return label
    }()
    
    lazy var cornerImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .red
        imageView.isHidden = true
        return imageView
    }()
    
    public var isSelect: Bool = false {
        didSet {
            if isSelect {
                layer.borderColor = UIColor.blue.cgColor
                layer.borderWidth = 3
                cornerImageView.isHidden = false
            } else {
                layer.borderColor = UIColor.clear.cgColor
                layer.borderWidth = 0
                cornerImageView.isHidden = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(identityLabel)
        identityLabel.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.top.equalTo(7)
            make.height.equalTo(20)
            make.width.lessThanOrEqualToSuperview().offset(-20)
        }
        identityLabel.layer.cornerRadius = 10
        identityLabel.layer.masksToBounds = true
        identityLabel.layer.borderColor = UIColor.lightGray.cgColor
        identityLabel.layer.borderWidth = 2
                
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(identityLabel.snp.left)
            make.height.equalTo(25)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().offset(-20)
        }
        
        addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.left.equalTo(identityLabel.snp.left)
            make.bottom.equalToSuperview().offset(-7)
            make.height.equalTo(25)
            make.width.lessThanOrEqualToSuperview().offset(-20)
        }
        
        addSubview(cornerImageView)
        cornerImageView.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.height.equalTo(20)
        }
    }
    
}
