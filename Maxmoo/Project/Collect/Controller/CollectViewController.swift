//
//  CollectViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/25.
//

import UIKit

class CollectViewController: ItemListViewController {

    override var items: [String] {
        return ["Picker-CRSSinglePickerController",
                "Segment-SegmentViewController"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Collect"
    }

}
