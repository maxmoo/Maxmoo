//
//  CRSWeatherController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/8/6.
//

import UIKit
import SnapKit

class CRSWeatherController: UIViewController {

    lazy var weatherView: CRSMapWeatherView = {
        let weather = CRSMapWeatherView(frame: .zero)
        weather.backgroundColor = .randomColor
        return weather
    }()
    
    lazy var button: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(weatherView)
        weatherView.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.right.equalToSuperview().offset(-60)
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(200)
            make.height.width.equalTo(50)
            make.left.equalTo(100)
        }
    }

    @objc
    func refresh() {
        weatherView.refresh(wind: "231231", hum: "fdasda-sfa", tem: "1asfaasd")
    }
}
