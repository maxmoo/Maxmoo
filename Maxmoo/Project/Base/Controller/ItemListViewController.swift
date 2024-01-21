//
//  ItemListViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit

class ItemListViewController: UIViewController {

    var items: [[String]] {
        return []
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }

}

extension ItemListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        let items = items[indexPath.section][indexPath.row]
        let subItems = items.components(separatedBy: "-")
    
        cell.textLabel?.text = subItems.first
        cell.textLabel?.numberOfLines = 2
        cell.detailTextLabel?.text = subItems.last
        cell.detailTextLabel?.numberOfLines = 2
        if #available(iOS 13.0, *) {
            cell.detailTextLabel?.textColor = .secondaryLabel
        } else {
            cell.detailTextLabel?.textColor = .lightGray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let item = items[indexPath.section][indexPath.row]
        let subItems = item.components(separatedBy: "-")
        if let last = subItems.last, let v = last.toClass() as? UIViewController.Type {
            let pushV = v.init()
            pushV.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(pushV, animated: true)
        }
    }
}
