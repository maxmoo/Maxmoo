//
//  CRSWaterConditionHeaderView.swift
//  Maxmoo
//
//  Created by 程超 on 2025/5/16.
//

import UIKit
import SnapKit

class CRSTopAlignedLabel: UILabel {
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        textRect.origin.y = bounds.origin.y
        return textRect
    }
    
    override func drawText(in rect: CGRect) {
        let actualRect = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: actualRect)
    }
}

class CRSWaterConditionHeaderView: UIView {

    var titleBackView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .randomColor
        return view
    }()
    
    var depthColorView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .randomColor
        return view
    }()
    
    var depathTitleLabel: CRSTopAlignedLabel = {
        let label = CRSTopAlignedLabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .randomColor
        label.text = "大师傅轧空轧空噶"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    var depathAttIconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "delete")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var temperatureColorView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .randomColor
        return view
    }()
    
    var temperatureTitleLabel: CRSTopAlignedLabel = {
        let label = CRSTopAlignedLabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .randomColor
        label.text = "大师傅轧空轧空噶fasdasdasggdfasdasdasgdasdasda"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    var visibilityColorView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .randomColor
        return view
    }()
    
    var visibilityTitleLabel: CRSTopAlignedLabel = {
        let label = CRSTopAlignedLabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .randomColor
        label.text = "大师傅轧空轧空噶"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    var fuColorView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .randomColor
        return view
    }()
    
    var fuTitleLabel: CRSTopAlignedLabel = {
        let label = CRSTopAlignedLabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .randomColor
        label.text = "大师傅轧空轧空噶"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    // value
    var valueBackView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .randomColor
        return view
    }()
    
    var depathValueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.text = "45.1"
        return label
    }()
    
    var depathUnitLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "m"
        return label
    }()
    
    var temperatureValueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.text = "30~100"
        return label
    }()
    
    var temperatureUnitLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "°C"
        return label
    }()
    
    var visibilityValueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.text = "35.6"
        return label
    }()
    
    var visibilityUnitLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "m"
        return label
    }()
    
    var fuValueBackView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .randomColor
        return view
    }()
    
    var fuValueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.text = "9"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI() {
        addSubview(titleBackView)
        titleBackView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
        }
        
        titleBackView.addSubview(depthColorView)
        depthColorView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(5)
            make.top.equalTo(5)
        }
        
        let tempView = UIView(frame: .zero)
        titleBackView.addSubview(tempView)
        tempView.snp.makeConstraints { make in
            make.left.equalTo(depthColorView.snp.right).offset(1)
            make.width.equalToSuperview().multipliedBy(0.20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleBackView.addSubview(depathTitleLabel)
        depathTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(depthColorView.snp.right).offset(1)
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.20).offset(-10)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleBackView.addSubview(depathAttIconImageView)
        depathAttIconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(14)
            make.left.equalTo(depathTitleLabel.snp.right)
            make.top.equalTo(depathTitleLabel.snp.top)
        }
        depathAttIconImageView.addTapGesture {
            print("sadasdasda")
        }
        
        titleBackView.addSubview(temperatureColorView)
        temperatureColorView.snp.makeConstraints { make in
            make.left.equalTo(tempView.snp.right).offset(5)
            make.width.height.equalTo(5)
            make.top.equalTo(5)
        }
        
        titleBackView.addSubview(temperatureTitleLabel)
        temperatureTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(temperatureColorView.snp.right).offset(1)
            make.width.equalToSuperview().multipliedBy(0.30)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleBackView.addSubview(visibilityColorView)
        visibilityColorView.snp.makeConstraints { make in
            make.left.equalTo(temperatureTitleLabel.snp.right).offset(5)
            make.width.height.equalTo(5)
            make.top.equalTo(5)
        }
        
        titleBackView.addSubview(visibilityTitleLabel)
        visibilityTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(visibilityColorView.snp.right).offset(1)
            make.width.equalToSuperview().multipliedBy(0.20)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleBackView.addSubview(fuColorView)
        fuColorView.snp.makeConstraints { make in
            make.left.equalTo(visibilityTitleLabel.snp.right).offset(5)
            make.width.height.equalTo(5)
            make.top.equalTo(5)
        }
        
        titleBackView.addSubview(fuTitleLabel)
        fuTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(fuColorView.snp.right).offset(1)
            make.width.equalToSuperview().multipliedBy(0.18)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        addSubview(valueBackView)
        valueBackView.snp.makeConstraints { make in
            make.top.equalTo(titleBackView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        valueBackView.addSubview(depathValueLabel)
        depathValueLabel.snp.makeConstraints { make in
            make.left.equalTo(depathTitleLabel.snp.left)
            make.top.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.20).offset(-20)
            make.bottom.equalToSuperview()
        }
        
        valueBackView.addSubview(depathUnitLabel)
        depathUnitLabel.snp.makeConstraints { make in
            make.left.equalTo(depathValueLabel.snp.right)
            make.width.equalTo(20)
            make.centerY.equalTo(depathValueLabel.snp.centerY).offset(2)
        }
        
        valueBackView.addSubview(temperatureValueLabel)
        temperatureValueLabel.snp.makeConstraints { make in
            make.left.equalTo(temperatureTitleLabel.snp.left)
            make.top.equalToSuperview()
            make.width.lessThanOrEqualTo(temperatureTitleLabel.snp.width).offset(-20)
            make.bottom.equalToSuperview()
        }
        
        valueBackView.addSubview(temperatureUnitLabel)
        temperatureUnitLabel.snp.makeConstraints { make in
            make.left.equalTo(temperatureValueLabel.snp.right)
            make.width.equalTo(20)
            make.centerY.equalTo(temperatureValueLabel.snp.centerY).offset(2)
        }
        
        valueBackView.addSubview(visibilityValueLabel)
        visibilityValueLabel.snp.makeConstraints { make in
            make.left.equalTo(visibilityTitleLabel.snp.left)
            make.top.equalToSuperview()
            make.width.lessThanOrEqualTo(visibilityTitleLabel.snp.width).offset(-20)
            make.bottom.equalToSuperview()
        }
        
        valueBackView.addSubview(visibilityUnitLabel)
        visibilityUnitLabel.snp.makeConstraints { make in
            make.left.equalTo(visibilityValueLabel.snp.right)
            make.width.equalTo(20)
            make.centerY.equalTo(visibilityValueLabel.snp.centerY).offset(2)
        }
        
        valueBackView.addSubview(fuValueBackView)
        valueBackView.addSubview(fuValueLabel)
        fuValueLabel.snp.makeConstraints { make in
            make.left.equalTo(fuTitleLabel.snp.left).offset(20)
            make.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        fuValueBackView.snp.makeConstraints { make in
            make.width.equalTo(fuValueLabel.snp.width).offset(6)
            make.height.equalTo(fuValueLabel.snp.height).offset(6)
            make.center.equalTo(fuValueLabel.snp.center)
        }
    }
    
}
