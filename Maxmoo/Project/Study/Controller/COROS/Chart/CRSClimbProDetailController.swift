//
//  CRSClimbProDetailController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/2/22.
//

import UIKit
import SnapKit

class CRSClimbProDetailController: UIViewController {
    
    lazy var chartHeaderView: CRSClimbProChartHeaderView = {
        let header = CRSClimbProChartHeaderView(frame: .zero)
        return header
    }()
    
    lazy var chart: CRSTrackClimbChartView = {
        let chart = CRSTrackClimbChartView(frame: CGRect(x: 16, y: 200, width: kScreenWidth - 32, height: 180))
        return chart
    }()
    
    lazy var listHeaderView: CRSClimbProListHeaderView = {
        let listHeader = CRSClimbProListHeaderView(frame: .zero)
        return listHeader
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(withCellNib: CRSClimbProListCell.self)
        return table
    }()
    
    var totalClimbInfos: [CRSTrackClimbInfo] = []
    var listItems: [CRSClimbListItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareData()
        setupUI()
    }
    
    func prepareData() {
        totalClimbInfos.removeAll()
        listItems.removeAll()
        
        let testDataCount: Int = 20
        var startDistance = 0.0
        for _ in 0..<testDataCount {
            let startIndex = totalClimbInfos.count
            let testInfos = CRSTrackClimbInfo.testItemInfos(count: Int.random(in: 5...15), startDistance: startDistance)
            if let last = testInfos.last {
                startDistance = last.distance ?? startDistance
            }
            totalClimbInfos.append(contentsOf: testInfos)
            let endIndex = totalClimbInfos.count
            let item = CRSClimbListItem(isExtra: false, infos: testInfos, startIndex: startIndex, endIndex: endIndex)
            listItems.append(item)
        }
    }
    
    func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(chartHeaderView)
        chartHeaderView.snp.makeConstraints { make in
            make.top.equalTo(52)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(40)
        }
        
        view.addSubview(chart)
        chart.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(chartHeaderView.snp.bottom)
            make.height.equalTo(180)
        }
        chart.trackInfos = totalClimbInfos
        
        view.addSubview(listHeaderView)
        listHeaderView.snp.makeConstraints { make in
            make.right.left.equalTo(0)
            make.top.equalTo(chart.snp.bottom)
            make.height.equalTo(48)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(listHeaderView.snp.bottom)
        }
    }
    
    func selectedItemIndex() -> Int? {
        for (index, item) in listItems.enumerated() where item.isExtra {
            return index
        }
        return nil
    }
    
    func clickCellInfo(at indexPath: IndexPath) {
        var reloadIndexPaths: [IndexPath] = []
        
        if let selectedIndex = selectedItemIndex(),
            selectedIndex != indexPath.row,
            selectedIndex >= 0,
            selectedIndex < listItems.count {
            
            var selectedItem = listItems[selectedIndex]
            selectedItem.isExtra = false
            listItems[selectedIndex] = selectedItem
            
            let selectedIndexPath = IndexPath(row: selectedIndex, section: 0)
            reloadIndexPaths.append(selectedIndexPath)
        }
        
        var item = listItems[indexPath.row]
        item.isExtra = !item.isExtra
        listItems[indexPath.row] = item
        if item.isExtra {
            chart.highlightRange = item.startIndex..<item.endIndex + 1
        } else {
            chart.highlightRange = -1..<0
        }
        
        reloadIndexPaths.append(indexPath)
        
        tableView.reloadRows(at: reloadIndexPaths, with: .fade)
    }
    
}


extension CRSClimbProDetailController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = listItems[indexPath.row]
        if item.isExtra {
            return 210
        } else {
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: CRSClimbProListCell.self, for: indexPath)

        cell.selectionStyle = .none
        cell.item = listItems[indexPath.row]
        
        cell.headerClicked = {
            [weak self] in
            self?.clickCellInfo(at: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
