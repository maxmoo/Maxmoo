//
//  CRSClimbProListHeaderView.swift
//  Maxmoo
//
//  Created by 程超 on 2024/2/22.
//

import UIKit
import SnapKit

class CRSClimbProListHeaderView: UIView {

    lazy var climbDistanceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.backgroundColor = .randomColor
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "坡段距离"
        return label
    }()
    
    lazy var climbLengthLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.backgroundColor = .randomColor
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "爬坡长度"
        return label
    }()
    
    lazy var averageSlopeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.backgroundColor = .randomColor
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "平均坡度"
        return label
    }()
    
    lazy var totalClimbLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.backgroundColor = .randomColor
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "累计爬升"
        return label
    }()
    
    // 每个标题之间的间隔
    let itemGap: CGFloat = kScreenWidth * 0.02
    let leftGap: CGFloat = kScreenWidth * (16/412.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(climbDistanceLabel)
        climbDistanceLabel.snp.makeConstraints { make in
            make.height.centerY.equalToSuperview()
            make.left.equalTo(leftGap)
            make.width.equalToSuperview().multipliedBy(0.19)
        }
        
        addSubview(climbLengthLabel)
        climbLengthLabel.snp.makeConstraints { make in
            make.left.equalTo(climbDistanceLabel.snp.right).offset(itemGap)
            make.height.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.24)
        }
        
        addSubview(averageSlopeLabel)
        averageSlopeLabel.snp.makeConstraints { make in
            make.left.equalTo(climbLengthLabel.snp.right).offset(itemGap)
            make.height.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.17)
        }
        
        addSubview(totalClimbLabel)
        totalClimbLabel.snp.makeConstraints { make in
            make.left.equalTo(averageSlopeLabel.snp.right).offset(itemGap)
            make.height.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.19)
        }
    }

}
