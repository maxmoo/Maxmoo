//
//  SegmentViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/9/5.
//

import UIKit

class SegmentViewController: CCBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var items: [CRSPageSegmentItem] = []
        for index in 0...10 {
            let item = CRSPageSegmentItem(title: "第\(index)个")
            item.backgroundColor = .randomColor
            items.append(item)
        }
        
        let seV = CRSPageSegmentView(frame: CGRect(x: 16, y: 120, width: kScreenWidth - 32, height: 50), orientation: .horizontal, items: items)
        seV.backgroundColor = .randomColor
        view.addSubview(seV)
    }
}
