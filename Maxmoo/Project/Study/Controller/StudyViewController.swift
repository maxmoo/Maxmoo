//
//  StudyViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/25.
//

import UIKit

class StudyViewController: ItemListViewController {

    override var items: [[String]] {
        return [["OC-OCStudyViewController",
                 "C-CStudyViewController"],
                ["CRS图表-ChartViewController",
                 "SwiftUI-SwiftUIController",
                "Cell-CellViewController",
                "Page-PageStudyViewController",
                "CollectionView-CollectionViewStudyController",
                "苹果地图-AppleMapViewController",
                "image-ImageStudyController",
                "读取文件-ReadFileViewController",
                "JSON-JSONViewController",
                "CRS投屏数据页-CastScreenDataTestController",
                "动画-CCAnimateListController"]]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Study"
    }

}
