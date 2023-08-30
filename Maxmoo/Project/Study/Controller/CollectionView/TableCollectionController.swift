//
//  TableCollectionController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/30.
//

import UIKit

class TableCollectionController: CCBaseViewController {

    var items: [String] = {
        var arr: [String] = []
        for i in 0...40 {
            arr.append("第\(i)个")
        }
        return arr
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .randomColor
        button.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .randomColor
        button.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(120)
            make.width.height.equalTo(100)
        }
        
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.top.equalTo(120)
            make.width.height.equalTo(100)
        }
    }

    @objc
    func addItem() {
        items.insert("\(Int.random(in: 10...100))", at: 20)
        tableView.insertRows(at: [IndexPath(row: 20, section: 0)], with: .bottom)
    }
    
    @objc
    func deleteItem() {
        items.removeStart()
        tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
    }
}

extension TableCollectionController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
