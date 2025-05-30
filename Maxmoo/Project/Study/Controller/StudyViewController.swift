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
                 "转场动画-CCTransitionUtilListController",
                 "文本-CCTextViewController",
                 "OC-OCStudyViewController",
                 "C-CStudyViewController",
                 "Video-StudyVideoViewController",
                 "videoPlay-VideoPlayViewController",
                 "陀螺仪-GyroViewController",
                 "录制-RecorderViewController",
                 "XDX demo-XDXListViewController"],
                ["灵动岛-CRSLiveActivityController",
                 "手势处理-GestureViewController",
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
        
        let result = compareVersions(version1: "3.9.4.2", version2: "3.10.16")

        switch result {
            case .orderedAscending:
                print("3.11.4.2 小于 3.10.16")
            case .orderedDescending:
                print("3.11.4.2 大于 3.10.16")
            case .orderedSame:
                print("3.11.4.2 等于 3.10.16")
        }
    }

    func compareVersions(version1: String, version2: String) -> ComparisonResult {
        let components1 = version1.split(separator: ".").map { Int($0)! }
        let components2 = version2.split(separator: ".").map { Int($0)! }
        
        let maxCount = max(components1.count, components2.count)
        
        for i in 0..<maxCount {
            let component1 = i < components1.count ? components1[i] : 0
            let component2 = i < components2.count ? components2[i] : 0
            
            if component1 < component2 {
                return .orderedAscending
            } else if component1 > component2 {
                return .orderedDescending
            }
        }
        
        return .orderedSame
    }
    
}
