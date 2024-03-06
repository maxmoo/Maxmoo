//
//  CRSClimbProDetailController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/2/22.
//

import UIKit
import SnapKit

class CRSClimbProDetailController: ExplorePullUpController {
    
    lazy var chartHeaderView: CRSClimbProChartHeaderView = {
        let header = CRSClimbProChartHeaderView(frame: CGRect(x: 16, y: 52, width: kScreenWidth - 32, height: 40))
        return header
    }()
    
    lazy var chart: CRSTrackClimbChartView = {
        let chart = CRSTrackClimbChartView(frame: CGRect(x: 16, y: chartHeaderView.bottom, width: kScreenWidth - 32, height: 180))
        return chart
    }()
    
    lazy var listHeaderView: CRSClimbProListHeaderView = {
        let listHeader = CRSClimbProListHeaderView(frame: CGRect(x: 0, y: chart.bottom, width: kScreenWidth, height: 48))
        listHeader.layoutIfNeeded()
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
    
    lazy var tableFooterView: UIView = {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 188))
        footer.backgroundColor = .randomColor
        
        let label = UILabel(frame: footer.bounds)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.red
        label.text = "该路线无爬坡信息"
        footer.addSubview(label)
        
        return footer
    }()
    
    var totalClimbInfos: [CRSTrackClimbInfo] = []
    var listItems: [CRSClimbListItem] = []
    
    // 除去列表之外的基础高度
    private let baseInfoHeight: CGFloat = 320
    private let bottomBaseHeight: CGFloat = 188
    private let cellHeight: CGFloat = 56
    
    var testDataCount: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareData()
        setupUI()
    }
    
    func prepareData() {
        totalClimbInfos.removeAll()
        listItems.removeAll()
        
        guard testDataCount > 0 else { return }
        
        var startDistance = 0.0
        for _ in 0..<testDataCount {
            let startIndex = totalClimbInfos.count
            let testInfos = CRSTrackClimbInfo.testItemInfos(count: Int.random(in: 5...15), startDistance: startDistance)
            if let last = testInfos.last {
                startDistance = last.distance ?? startDistance
            }
            totalClimbInfos.append(contentsOf: testInfos)
            let endIndex = totalClimbInfos.count - 1
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
    
    // 用于获取当前显示高度
    public func showHeight(with itemCount: Int) -> CGFloat {
        testDataCount = itemCount
        if itemCount > 0 {
            let result = baseInfoHeight + CGFloat(itemCount) * cellHeight + bottomBaseHeight
            return result >= (kScreenHeight - 56) ? (kScreenHeight - 56) : result
        } else {
            return baseInfoHeight + bottomBaseHeight + cellHeight
        }
    }
    
    private func isHaveBottomGap() -> Bool {
        let result = baseInfoHeight + CGFloat(listItems.count) * cellHeight
        if result < (kScreenHeight - 56) {
            return true
        } else {
            return false
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
        
        if !item.isExtra,
           isHaveBottomGap(),
           let cell = tableView.cellForRow(at: indexPath) as? CRSClimbProListCell {
            cell.hideChart()
        }
        
        tableView.reloadRows(at: reloadIndexPaths, with: .fade)
        // 最后一个时需要向上展开
        if indexPath.row == listItems.count - 1,
            let offset = initialStickyPointOffset,
            offset >= kScreenHeight - 56 {
            tableView.scrollToBottom()
        }
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
            return cellHeight
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if listItems.count <= 0 {
            return 188
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if listItems.count <= 0 {
            return tableFooterView
        } else {
            return nil
        }
    }
}
