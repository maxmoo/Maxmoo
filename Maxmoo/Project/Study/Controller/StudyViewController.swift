//
//  StudyViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/25.
//

import UIKit

class StudyViewController: ItemListViewController {

    override var items: [[String]] {
        return [["COROS-COROSDemoListController",
                 "OC-OCStudyViewController",
                 "C-CStudyViewController",
                 "Video-StudyVideoViewController",
                 "videoPlay-VideoPlayViewController",
                 "陀螺仪-GyroViewController",
                 "录制-RecorderViewController",
                 "XDX demo-XDXListViewController"],
                ["手势处理-GestureViewController",
                 "文件操作-CCFileViewController",
                 "SwiftUI-SwiftUIController",
                 "Cell-CellViewController",
                 "Page-PageStudyViewController",
                 "CollectionView-CollectionViewStudyController",
                 "image-ImageStudyController",
                 "读取文件-ReadFileViewController",
                 "JSON-JSONViewController",
                 "CRS投屏数据页-CastScreenDataTestController",
                 "动画-CCAnimateListController"]]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Study"
        
        let a = -114.987
        let b = 23.987
        
        let ac = Int(ceil(a))
        let af = Int(floor(a))
        let bc = Int(ceil(b))
        let bf = Int(floor(b))
        
        print("[11111] \(ac) \(af) \(bc) \(bf)")
    }

}
