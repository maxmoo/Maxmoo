//
//  GestureViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/5/20.
//

import UIKit
import SnapKit


class CCAnnView: UIView {
    
    lazy var clickView: UIView = {
        let clickView = UIView(frame: .zero)
        clickView.backgroundColor = .green
        clickView.addTapGesture {
            print("extra click!!!!!!!!!!!!!")
        }
        
        let buttonView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        buttonView.backgroundColor = .blue
        buttonView.addTapGesture {
            print("buttonnnnnnnn")
        }
        clickView.addSubview(buttonView)
        
        return clickView
    }()
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let eventView = super.hitTest(point, with: event)
        let tempPoint = clickView.convert(point, from: self)
        if clickView.point(inside: tempPoint, with: event) {
            if let subView = clickView.hitTest(tempPoint, with: event) {
                return subView
            }
            return clickView
        }
        return eventView
    }
    
}

class GestureViewController: UIViewController {

    lazy var annView: CCAnnView = {
        let annView = CCAnnView(frame: .zero)
        annView.backgroundColor = .red
        annView.addTapGesture {
            print("aannnnnn click")
        }
        return annView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "手势处理"
        view.backgroundColor = .lightGray
        
        setUpUI()
    }


    func setUpUI() {
        view.addSubview(annView)
        annView.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.left.equalTo(40)
            make.width.height.equalTo(60)
        }
        
        annView.addSubview(annView.clickView)
        annView.clickView.snp.makeConstraints { make in
            make.top.left.equalTo(100)
            make.width.height.equalTo(200)
        }
    }
    
    @objc
    func annClick() {
        
    }
    
    @objc
    func extraClick() {
        
    }
    
}
