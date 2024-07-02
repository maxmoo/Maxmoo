//
//  CorosUserTipViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/5/22.
//

import UIKit

class CorosUserTipViewController: UIViewController {

    var tapCount: Int = 0
    
    lazy var tapView: UIView = {
        let view = UIView(frame: CGRect(x: 50, y: 100, width: 80, height: 40))
        view.backgroundColor = .red
        view.addTapGesture { [weak self] in
            guard let self else { return }
            
//            let styleValue = tapCount % 2
//            let style = CRSCSMapUserTipStyle(rawValue: styleValue)
//            userTipView.style = style ?? .normal
            
            let statusValue = tapCount % 4
            let status = CRSCSMapUserTipStatus(rawValue: statusValue)
            userTipView.status = status ?? .normal
            
            self.tapCount += 1
        }
        return view
    }()
    
    lazy var userTipView: CRSCastScreenUserTipView = {
        let leftValue = CRSCSMapUserTipValueInfo(iconImage: UIImage(named: "add"), value: 3.1415, unit: nil)
        let rightValue = CRSCSMapUserTipValueInfo(iconImage: UIImage(named: "add"), value: 99.0, unit: "km")
        let info = CRSCSMapUserTipInfo(headImage: UIImage(named: "icon_maleAvatar"),
                                       name: "123hhh",
                                       isFocus: false,
                                       valueInfos: [leftValue, rightValue])
        let tip = CRSCastScreenUserTipView(info: info, style: .normal)
        tip.backgroundColor = .red
        tip.delegate = self
        return tip
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(tapView)
        
        userTipView.top = 200
        userTipView.left = 100
        view.addSubview(userTipView)
    }

}

extension CorosUserTipViewController: CRSCSMapUserTipDelegate {
    
    func userTipFocusClick(tipView: CRSCastScreenUserTipView) {
        if var info = tipView.info {
            info.isFocus = !info.isFocus
            tipView.info = info
        }
    }
    
    func userTipHeadClick(tipView: CRSCastScreenUserTipView) {
        tipView.style = tipView.style == .normal ? .select : .normal
        
    }
}
