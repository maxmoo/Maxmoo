//
//  CRSCastScreenDataSettingController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/12/7.
//

import UIKit

class CRSCastScreenDataSettingController: UIViewController {

    var completeBlock: ((CRSCastScreenDataStyle) -> Void)?
    
    var showArray = [String]()
    var otherArray = [String]()
    
    lazy var tableView : UITableView = {
        let tableview = UITableView(frame: .zero,
                                    style: UITableView.Style.grouped)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.backgroundColor = .black
        tableview.setEditing(true, animated: false)
        tableview.estimatedRowHeight = 0;
        tableview.estimatedSectionHeaderHeight = 0;
        tableview.estimatedSectionFooterHeight = 0;
        tableview.register(UINib(nibName: "CRSCastScreenOrderCell", bundle: nil), forCellReuseIdentifier: "CRSCastScreenOrderCell")
        return tableview
    }()
    
    lazy var testAction: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("action", for: .normal)
        button.backgroundColor = .randomColor
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        for idx  in 0...5 {
            showArray.append("\(idx)")
            otherArray.append("\(idx+6)")
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
        
        view.addSubview(testAction)
        testAction.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.bottom.equalTo(-80)
            make.height.width.equalTo(60)
        }
    }
    
    @objc
    private func save() {
        if let completeBlock {
            let style = CRSCastScreenDataStyle.style(count: showArray.count)
            completeBlock(style)
        }
    }
    
    private func add(at indexPath: IndexPath) {
        guard indexPath.section != 0 else { return }
        guard showArray.count < 10 else { return }
        
        let item = otherArray.remove(at: indexPath.row)
        showArray.append(item)
        self.tableView.reloadData()
    }
    
    private func delete(at indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        guard showArray.count > 3 else { return }
        
        let item = showArray.remove(at: indexPath.row)
        otherArray.insert(item, at: 0)
        self.tableView.reloadData()
    }
}

extension CRSCastScreenDataSettingController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if otherArray.count > 0 {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? showArray.count : otherArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CRSCastScreenOrderCell",
                                                 for: indexPath) as! CRSCastScreenOrderCell
        
        if indexPath.section == 0 {
            cell.iconImageView.image = UIImage(named: "delete")
            cell.titleLabel.text = showArray[indexPath.row]
        } else {
            cell.iconImageView.image = UIImage(named: "add")
            cell.titleLabel.text = otherArray[indexPath.row]
        }
        cell.iconClickBlock = { [weak self] in
            if indexPath.section == 0 {
                // delete
                print("delete")
                self?.delete(at: indexPath)
            } else {
                // add
                print("add")
                self?.add(at: indexPath)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let obj = showArray.remove(at: sourceIndexPath.row)
        showArray.insert(obj, at: destinationIndexPath.row)
        tableView.reloadData()
    }

    /// 限制只能在一个section中拖动
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.section != sourceIndexPath.section {
            let row = tableView.numberOfRows(inSection: sourceIndexPath.section) - 1
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
}
