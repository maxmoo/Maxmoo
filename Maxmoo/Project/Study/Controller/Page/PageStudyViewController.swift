//
//  PageStudyViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit

class PageStudyViewController: ItemListViewController {

    override var items: [[String]] {
        return [["Page上一步下一步-PageGuideViewController"]]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Page的初步使用"
    }

}
