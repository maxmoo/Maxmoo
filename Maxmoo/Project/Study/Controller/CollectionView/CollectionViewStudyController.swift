//
//  CollectionViewStudyController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/29.
//

import UIKit

class CollectionViewStudyController: ItemListViewController {

    override var items: [String] {
        return ["竖直滑动Collection-VWatchCollectionViewController",
                "增加删除动画-AddAnimateCollectionController",
                "使用tableView实现增删动画-TableCollectionController"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
