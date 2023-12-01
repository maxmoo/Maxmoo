//
//  StudyViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/25.
//

import UIKit

class StudyViewController: ItemListViewController {

    override var items: [String] {
        return ["Cell-CellViewController",
                "Page-PageStudyViewController",
                "CollectionView-CollectionViewStudyController",
                "苹果地图-AppleMapViewController",
                "image-ImageStudyController",
                "读取文件-ReadFileViewController",
                "JSON-JSONViewController",
                "CRS投屏数据页-CRSCastScreenDataController"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Study"
    }

}
