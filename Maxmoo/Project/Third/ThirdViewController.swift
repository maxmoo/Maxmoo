//
//  ThirdViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/25.
//

import UIKit

class ThirdViewController: ItemListViewController {

    override var items: [String] {
        return ["Cell-CellViewController"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Third"
    }

}
