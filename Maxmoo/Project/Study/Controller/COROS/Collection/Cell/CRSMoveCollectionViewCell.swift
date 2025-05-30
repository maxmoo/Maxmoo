//
//  CRSMoveCollectionViewCell.swift
//  Maxmoo
//
//  Created by 程超 on 2025/5/26.
//

import UIKit

class CRSMoveCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!

    @IBOutlet weak var moveImageView: UIImageView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var bottomLineView: UIView!
    
    public var isAdd: Bool = true {
        didSet {
            remakeConstraints()
        }
    }
    
    public var rightAction: ((Bool) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    private func setupUI() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        backView.backgroundColor = .white
        backView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        moveImageView.backgroundColor = .randomColor
        moveImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        iconImageView.backgroundColor = .randomColor
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(68)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.backgroundColor = .randomColor
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }
        
        rightImageView.backgroundColor = .randomColor
        rightImageView.isUserInteractionEnabled = true
        rightImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-32)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        rightImageView.addTapGesture { [weak self] in
            self?.rightAction?(self?.isAdd ?? true)
        }
        
        bottomLineView.backgroundColor = .randomColor
        bottomLineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(32)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

    func remakeConstraints() {
        if isAdd {
            moveImageView.isHidden = false
            iconImageView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(68)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(24)
            }
        } else {
            moveImageView.isHidden = true
            iconImageView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(32)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(24)
            }
        }
    }
}
