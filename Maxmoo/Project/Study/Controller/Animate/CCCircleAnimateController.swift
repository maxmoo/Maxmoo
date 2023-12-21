//
//  CCCircleAnimateController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/12/21.
//

import UIKit

class CCCircleAnimateController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    
    private func setupUI() {
        title = "旋转"
        view.backgroundColor = .randomColor
        
        let imageBackView = UIImageView(frame: CGRect(x: 60, y: 200, width: 60, height: 60))
        imageBackView.image = UIImage(named: "sync_circle")
        view.addSubview(imageBackView)
        
        let rotationAnimatioin = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimatioin.toValue = Double.pi * 2.0
        rotationAnimatioin.duration = 1.6
        rotationAnimatioin.repeatCount = HUGE
        rotationAnimatioin.isRemovedOnCompletion = false
        imageBackView.layer.add(rotationAnimatioin, forKey: "rotationAnimatioin")
        
        let centerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        centerImageView.image = UIImage(named: "add")
        centerImageView.center = imageBackView.center
        view.addSubview(centerImageView)
    }
}
