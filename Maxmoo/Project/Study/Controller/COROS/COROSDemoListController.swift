//
//  COROSDemoListController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/1/29.
//

import UIKit

class COROSDemoListController: ItemListViewController {

    override var items: [[String]] {
        return [["CRS图表-ChartViewController",
                 "投屏提醒-CRSAlertViewController"]]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "COROS"
    }

}
