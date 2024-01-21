//
//  CellViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit

class CellViewController: ItemListViewController {

    override var items: [[String]] {
        return [["Cell展开-ExpandCellViewController",
                "cell编辑-CellEditViewController"]]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cell"
    }

}
