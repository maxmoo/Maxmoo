//
//  CRSAlertViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/1/29.
//

import UIKit

class CRSAlertViewController: UIViewController {

    lazy var button: UIButton = {
        let bu = UIButton(frame: CGRect(x: 16, y: 500, width: 100, height: 40))
        bu.backgroundColor = .randomColor
        bu.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        return bu
    }()
    
    lazy var buttonAll: UIButton = {
        let bu = UIButton(frame: CGRect(x: 188, y: 500, width: 100, height: 40))
        bu.backgroundColor = .randomColor
        bu.addTarget(self, action: #selector(hideAll), for: .touchUpInside)
        return bu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .randomColor
        view.addSubview(button)
        view.addSubview(buttonAll)
    }
    

    @objc
    func showAlert() {
//        let model = CRSCastAlertModel(icon: UIImage(named: "delete"), title: "title", value: "9876.9", unit: "km/h", info: "what's your name!!")
        let titleModel = CRSCastAlertModel(title: "title")
        let model = CRSCastAlertModel(title: "title", value: "98765473", unit: "km/h", infoTitle: "whats your name!!", infoValue: "170-180")
        let alert = CRSCastScreenAlertView(frame: CGRect(x: 0, y: 0, width: kScreenWidth - 32, height: 90))
//        alert.buildArriveAlert(title: "到达", item: model)
//        alert.buildSportAlert(title: "心率偏高", iconWidth: 25, titleColor: .red, item: model)
//        alert.buildFirstSubstituteAlert(title: "1-热身", header: titleModel, items: [model,model])
        let group1 = CRSCastAlertGroupModel(title: "上一圈", items: [model, model])
        let group2 = CRSCastAlertGroupModel(title: "2-训练", items: [model])
        alert.buildSubstituteAlert(groups: [group1, group2])
        CRSCastScreenAlertManager.shared.show(alert)
    }

    @objc
    func hideAll() {
        CRSCastScreenAlertManager.shared.hideAll()
    }
}
