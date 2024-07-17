//
//  CCTransitionUtilListController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/7/17.
//

import UIKit

class CCTransitionUtilListController: UIViewController {
    
    //转场动画
    private let transitionUtil = ExploreTransitionUtil()
    private lazy var circleTransUtil: ExploreTransitionCircle = {
        let circleTransUtil = ExploreTransitionCircle()
        circleTransUtil.duration = 0.5
        circleTransUtil.centerPoint = presentActionButton.center
        return circleTransUtil
    }()
    private lazy var photoTransUtil: ExploreTransitionPhoto = {
        let photoTrans = ExploreTransitionPhoto()
        let photoModel = ExploreTransitionPhotoImageModel(image: testImageView.image, originalFrame: testImageView.frame, targetFrame: CGRect(x: 0, y: 300, width: kScreenWidth, height: kScreenWidth))
        photoTrans.forwardPhoto = photoModel
        return photoTrans
    }()
    
    lazy var testImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 100, y: 400, width: 100, height: 100))
        imageView.image = UIImage(named: "icon_maleAvatar")
        return imageView
    }()
    
    lazy var pushActionButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 100, width: 100, height: 50))
        button.backgroundColor = .randomColor
        button.setTitle("push", for: .normal)
        button.addTarget(self, action: #selector(pushStart), for: .touchUpInside)
        return button
    }()
    
    lazy var presentActionButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 200, width: 100, height: 50))
        button.backgroundColor = .randomColor
        button.setTitle("present", for: .normal)
        button.addTarget(self, action: #selector(presentAction), for: .touchUpInside)
        return button
    }()
    
    lazy var photoActionButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 50, y: 300, width: 100, height: 50))
        button.backgroundColor = .randomColor
        button.setTitle("photo", for: .normal)
        button.addTarget(self, action: #selector(photoAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        view.addSubview(pushActionButton)
        view.addSubview(presentActionButton)
        view.addSubview(photoActionButton)
        view.addSubview(testImageView)
    }

    @objc
    func pushStart() {
        let vc = CCTransPushViewController()
        vc.hidesBottomBarWhenPushed = true
        transitionUtil.navigationController = self.navigationController
        self.navigationController?.delegate = transitionUtil
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func presentAction() {
        let present = CCTransPresentController()
        present.transitioningDelegate = circleTransUtil
        present.modalPresentationStyle = .custom
        self.present(present, animated: true)
    }
    
    @objc
    func photoAction() {
        let per = CCTransPhotoViewController()
        photoTransUtil.forwardPhoto?.image = testImageView.image
        per.transitioningDelegate = photoTransUtil
        per.modalPresentationStyle = .custom
        self.present(per, animated: true)
    }
    
}
