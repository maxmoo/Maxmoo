//
//  SUHelloController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/12/22.
//

import UIKit
import SwiftUI

class SwiftUIHelloController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    private func setupUI() {
        let vc = UIHostingController(rootView: SUHello(title: "jack"))
        if let tempView = vc.view {
            tempView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
            tempView.backgroundColor = .randomColor
            view.addSubview(tempView)
        }
    }
}
