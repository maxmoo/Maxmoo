//
//  CRSDSBottomListViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/10/30.
//

import UIKit
import SnapKit

class CRSDSBottomListViewController: UIViewController {

    lazy var bottomListView: CRSDataScreenItemListView = {
        let list = CRSDataScreenItemListView(frame: .zero)
        list.backgroundColor = .randomColor
        return list
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .randomColor
        
        bottomListView.dsGroups = createTestInfos()
        view.addSubview(bottomListView)
        bottomListView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(300)
        }
    }

    func createTestInfos() -> [CRSDataScreenGroup] {
        var groups: [CRSDataScreenGroup] = []
        
        let item1 = CRSDataScreenItem(chartPath: "1111", iconName: "icon_maleAvatar", title: "xxxxxxxxxx", info: "")
        let item2 = CRSDataScreenItem(chartPath: "1111", iconName: "icon_maleAvatar", title: "心率", info: "")
        let item3 = CRSDataScreenItem(chartPath: "1111", iconName: "icon_maleAvatar", title: "心率", info: "")
        let item4 = CRSDataScreenItem(chartPath: "1111", iconName: "icon_maleAvatar", title: "距离", info: "")
        let item5 = CRSDataScreenItem(chartPath: "1111", iconName: "icon_maleAvatar", title: "距离", info: "")
        let item6 = CRSDataScreenItem(chartPath: "1111", iconName: "icon_maleAvatar", title: "距离", info: "")
        let item7 = CRSDataScreenItem(chartPath: "1111", iconName: "icon_maleAvatar", title: "距离", info: "")
        let item8 = CRSDataScreenItem(chartPath: "1111", iconName: "icon_maleAvatar", title: "距离", info: "")
        
        let aitem1 = CRSDataScreenItem(chartPath: "", iconName: "icon_maleAvatar", title: "xxxxxxxxxx", info: "dasdasdasgagasdasdasdasdasdasd")
        let aitem2 = CRSDataScreenItem(chartPath: "", iconName: "icon_maleAvatar", title: "心率", info: "aasd")
        let aitem3 = CRSDataScreenItem(chartPath: "", iconName: "icon_maleAvatar", title: "距离", info: "kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk")
        let aitem4 = CRSDataScreenItem(chartPath: "", iconName: "icon_maleAvatar", title: "yyyyy", info: "")
        
        let group1 = CRSDataScreenGroup(name: "图表", items: [item1, aitem1, item2, aitem2, item3, aitem3, item4, aitem4, item5, item6, item7, item8])
        groups.append(group1)
        
        let group2 = CRSDataScreenGroup(name: "推荐", items: [aitem1, aitem2,aitem3, aitem4])
        groups.append(group2)
        
        return groups
    }
    
}

struct CRSDataScreenGroup {
    var name: String
    var items: [CRSDataScreenItem]
}

struct CRSDataScreenItem {
    var chartPath: String
    var iconName: String
    var title: String
    var info: String
}
