//
//  SwiftUIController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/12/22.
//

import UIKit
import SwiftUI

class SwiftUIController: ItemListViewController {

    override var items: [String] {
        return ["Hello-SwiftUIHelloController"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SwiftUI-Demo"
    }

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//
//        switch indexPath.row {
//        case 0:
//            let vc = UIHostingController(rootView: SUHello(title: "jack"))
//            navigationController?.pushViewController(vc, animated: true)
//        default:
//            break
//        }
//    }
}
