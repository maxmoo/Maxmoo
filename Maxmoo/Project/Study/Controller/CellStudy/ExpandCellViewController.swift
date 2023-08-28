//
//  ExpandCellViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit

class ExpandCellViewController: CCBaseViewController {
    
    var items: [ExpandCellItem] = []
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "ExpandTableViewCell")
        table.register(UINib(nibName: "ExpandTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpandTableViewCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cell展开"
        initData()
        view.addSubview(tableView)
    }
    
    func initData() {
        for i in 0...10 {
            let item = ExpandCellItem(name: "第\(i)个", isExtra: false)
            items.append(item)
        }
    }
}

extension ExpandCellViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = items[indexPath.row]
        if item.isExtra {
            return 160
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandTableViewCell",
                                                 for: indexPath) as! ExpandTableViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandTableViewCell", for: indexPath)
//        cell.textLabel?.text = items[indexPath.row].name
        cell.item = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        var item = items[indexPath.row]
        item.isExtra = !item.isExtra
        items[indexPath.row] = item
        let x = indexPath.row % 8
        switch x {
        case 0:
            tableView.reloadRows(at: [indexPath], with: .fade)
        case 1:
            tableView.reloadRows(at: [indexPath], with: .right)
        case 2:
            tableView.reloadRows(at: [indexPath], with: .left)
        case 3:
            tableView.reloadRows(at: [indexPath], with: .top)
        case 4:
            tableView.reloadRows(at: [indexPath], with: .bottom)
        case 5:
            tableView.reloadRows(at: [indexPath], with: .none)
        case 6:
            tableView.reloadRows(at: [indexPath], with: .middle)
        case 7:
            tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
}
