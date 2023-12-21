//
//  CCAnimateListController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/12/21.
//

import UIKit

class CCAnimateListController: ItemListViewController {

    override var items: [String] {
        return ["旋转-CCCircleAnimateController"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Animate"
    }

}
