//
//  CastScreenDataTestController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/12/7.
//

import UIKit

class CastScreenDataTestController: UIViewController {

    var items: [CRSCastScreenDataStyle] {
        return [.one, .two, .three, .four, .six, .eight, .ten]
    }
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .plain)
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

extension CastScreenDataTestController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        let item = items[indexPath.row]
    
        cell.textLabel?.text = item.testName

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let item = items[indexPath.row]

        let vc = CRSCastScreenDataController()
        vc.dataShowType = item
        navigationController?.pushViewController(vc, animated: true)
    }
}
