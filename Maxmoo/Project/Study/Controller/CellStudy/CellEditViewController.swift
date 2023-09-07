//
//  CellEditViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/9/6.
//

import UIKit

class CellEditViewController: CCBaseViewController {

    var ary1 = [String]()
    var ary2 = [String]()
    
    var tableView : UITableView {
        let tableview = UITableView(frame: view.bounds,
                                    style: UITableView.Style.grouped)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.setEditing(true, animated: false)
        tableview.estimatedRowHeight = 0;
        tableview.estimatedSectionHeaderHeight = 0;
        tableview.estimatedSectionFooterHeight = 0;
        tableview.register(UINib(nibName: "CellEditMoveCell", bundle: nil), forCellReuseIdentifier: "CellEditMoveCell")
        return tableview
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for idx  in 0...5 {
            ary1.append("\(idx)")
            ary2.append("\(idx+6)")
        }
        
        view.addSubview(tableView)
    }
}

extension CellEditViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? ary1.count :  ary2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellEditMoveCell",
                                                 for: indexPath) as! CellEditMoveCell
        if indexPath.section == 1 {
            cell.titleLabel.text = ary2[indexPath.row]
        } else {
            cell.titleLabel.text = ary1[indexPath.row]
        }
        
        if indexPath.row > 1 && indexPath.section == 0 {
            cell.editImageView.isHidden = false
        } else {
            cell.editImageView.isHidden = true
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.row > 1
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row > 1 && indexPath.section == 0
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if destinationIndexPath.item < 2 {
            tableView.reloadData()
            return
        }
        let obj = ary1.remove(at: sourceIndexPath.row)
        if destinationIndexPath.section == 1 {
            ary2.insert(obj, at: destinationIndexPath.row)
        } else {
            ary1.insert(obj, at: destinationIndexPath.row)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return indexPath.section == 0 ? .delete : .insert
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let obj = ary1.remove(at: indexPath.row)
            ary2.append(obj)
            ary2.sort()
        } else {
            let obj = ary2.remove(at: indexPath.row)
            ary1.append(obj)
        }
        tableView.reloadData()
    }
}
