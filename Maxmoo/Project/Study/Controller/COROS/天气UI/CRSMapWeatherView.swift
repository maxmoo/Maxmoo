//
//  CRSMapWeatherView.swift
//  Maxmoo
//
//  Created by 程超 on 2024/8/6.
//

import UIKit
import SnapKit

class CRSMapWeatherView: UIView {

    // wind
    lazy var windLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.backgroundColor = .black
        label.text = "23km/h"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var windImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .red
        return imageView
    }()
    
    // humidity
    lazy var humidityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.backgroundColor = .black
        label.text = "53%"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var humidityImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .red
        return imageView
    }()
    
    // temperature
    lazy var temperatureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        label.backgroundColor = .black
        label.text = "27℃"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var weatherImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .red
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(windLabel)
        windLabel.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
        }
        
        addSubview(windImageView)
        windImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.right.equalTo(windLabel.snp.left)
        }
        
        addSubview(humidityLabel)
        humidityLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(windImageView.snp.left).offset(-10)
        }
        
        addSubview(humidityImageView)
        humidityImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.right.equalTo(humidityLabel.snp.left)
        }
        
        addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalTo(humidityImageView.snp.left).offset(-10)
        }
        
        addSubview(weatherImageView)
        weatherImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.right.equalTo(temperatureLabel.snp.left)
        }
    }
    
    func refresh(wind: String, hum: String, tem: String) {
        windLabel.text = wind
        humidityLabel.text = hum
        temperatureLabel.text = tem
    }
    
}
