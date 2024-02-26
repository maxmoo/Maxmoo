//
//  CRSClimbProChartHeaderView.swift
//  Maxmoo
//
//  Created by 程超 on 2024/2/22.
//

import UIKit
import SnapKit

class CRSClimbProChartHeaderView: UIView {

    lazy var angleIconImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "add")
        return imageView
    }()
    
    lazy var angleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.text = "14%"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(angleIconImage)
        angleIconImage.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        addSubview(angleLabel)
        angleLabel.snp.makeConstraints { make in
            make.left.equalTo(angleIconImage.snp.right)
            make.centerY.equalTo(angleIconImage)
            make.width.equalTo(100)
            make.height.equalTo(24)
        }
    }
    
}
