//
//  CCTransPhotoViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/7/17.
//

import UIKit

class CCTransPhotoViewController: UIViewController {
    
    private var transitionDelegate: ExploreTransitionPhoto? {
        return self.transitioningDelegate as? ExploreTransitionPhoto
    }
    
    lazy var testImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 300, width: kScreenWidth, height: kScreenWidth))
        imageView.image = UIImage(named: "icon_maleAvatar")
        return imageView
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 100, width: 100, height: 50))
        button.backgroundColor = .randomColor
        button.setTitle("back", for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        return button
    }()
    
    deinit {
        print("sdasdadada")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(backButton)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(testImageView)
    }
    
    @objc
    func back() {
        testImageView.isHidden = true
        if let transitionDelegate {
            transitionDelegate.forwardPhoto?.image = testImageView.image
        }
        dismiss(animated: true)
    }
}
