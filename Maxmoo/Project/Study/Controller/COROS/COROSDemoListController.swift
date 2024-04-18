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
        
        var coor = CRSCoordinate()
        coor.lat = 100
        coor.long = 101
        
        var coors: [CRSCoordinate] = []
        for _ in 0...1000 {
            coors.append(coor)
        }
        
        CRSCastTrackCacheManager.shared.saveCoordinates(coors: coors)
        print(CCFileManager.shared.contentsOfDirectory(at: CRSCastTrackCacheManager.shared.cachePathString()))
        
        CRSCastTrackCacheManager.shared.allCoordinatesRoutePath { path in
            print("[path all] count:\(path.pathDatas.count)")
        }
    }

}
