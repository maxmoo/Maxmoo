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
                 "投屏提醒-CRSAlertViewController",
                 "地图用户头像-CorosUserTipViewController"]]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "COROS"
        
//        var coor = CRSCoordinate()
//        coor.lat = 23452987
//        coor.long = 10198673
//        
//        var coors: [CRSCoordinate] = []
//        for _ in 0...10000 {
//            coors.append(coor)
//        }
//        
//        CRSCastTrackCacheManager.shared.saveCoordinates(coors: coors)
//        print(CCFileManager.shared.contentsOfDirectory(at: CRSCastTrackCacheManager.shared.cachePathString()))
//        
//        CRSCastTrackCacheManager.shared.allCoordinatesRoutePath { path in
//            print("[path all] count:\(path.pathDatas.count)")
//        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        CRSCastTrackCacheManager.shared.deleteAll()
    }

}
