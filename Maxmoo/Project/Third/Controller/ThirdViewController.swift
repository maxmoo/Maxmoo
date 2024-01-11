//
//  ThirdViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/25.
//

/*
 # 可视化db
 pod 'DatabaseVisual'

 #if DEBUG
         let path = ExploreFileManager.documents + "/db" + "/\(exploreUserId())"
         let vc = DatabaseListViewController(dbPaths: DatabaseFactory.queryIfHadDB(fromDirectory: path))
         let root = UINavigationController(rootViewController: vc)
         self.present(root, animated: true)
#endif
 */

import UIKit

class ThirdViewController: ItemListViewController {

    override var items: [String] {
        return ["阿里播放器-AliPlayerViewController"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Third"
        
        let number: UInt = 17561877850638462191
        let hexString = String(number, radix: 16, uppercase: false)
        print("xxxxxx: \(hexString)")
    }

}
