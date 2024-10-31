//
//  CRSDataScreenItemListView.swift
//  Maxmoo
//
//  Created by 程超 on 2024/10/30.
//

import UIKit
import SnapKit

class CRSDataScreenItemListView: UIView {

    public var dsGroups: [CRSDataScreenGroup] = [] {
        didSet {
            configData()
        }
    }
    
    enum ShowItemType {
        case normal
        case chart
    }
    
    struct ShowItem {
        var dsItem: CRSDataScreenItem
        var chartItem: ChartShowItem
        var type: ShowItemType
        var select: Bool
    }
    
    struct ChartShowItem {
        var title: String
        var items: [ShowItem]
    }
    
    struct ShowItemGroup {
        var items: [ShowItem]
        var dsGroup: CRSDataScreenGroup
        var select: Bool
    }
    
    private var listItemGroups: [ShowItemGroup] = []
    
    private var seletGroup: ShowItemGroup?
    
    // header
    lazy var headerView: UIView = {
        let header = UIView(frame: .zero)
        header.backgroundColor = .randomColor
        return header
    }()
    
    // left group tableView
    lazy var groupTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .randomColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(withCellNib: CRSDSItemGroupListCell.self)
        return tableView
    }()
    
    // right item list tableView
    lazy var itemListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .randomColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(withCellNib: CRSDSItemDetailListCell.self)
        tableView.register(withCellNib: CRSDSItemDetailChartCell.self)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configData() {
        listItemGroups.removeAll()
        
        struct ChartTempGroup {
            var title: String
            var items: [CRSDataScreenItem]
        }
        
        for (index, dsGroup) in dsGroups.enumerated() {
            var items: [ShowItem] = []
            var chartTempGroups: [ChartTempGroup] = []
            ds: for dsItem in dsGroup.items {
                if dsItem.chartPath.count > 0 {
                    for (index, chartTempGroup) in chartTempGroups.enumerated() {
                        if chartTempGroup.title == dsItem.title {
                            var items = chartTempGroup.items
                            items.append(dsItem)
                            chartTempGroups[index] = ChartTempGroup(title: dsItem.title, items: items)
                            continue ds
                        }
                    }
                    
                    chartTempGroups.append(ChartTempGroup(title: dsItem.title, items: [dsItem]))
                } else {
                    let item = ShowItem(dsItem: dsItem, chartItem: ChartShowItem(title: "", items: []), type: .normal, select: false)
                    items.append(item)
                }
            }
            
            var chartItems: [ShowItem] = []
            for chartItem in chartTempGroups {
                let showItem = chartItem.items.map { dsI in
                    return ShowItem(dsItem: dsI, chartItem: ChartShowItem(title: "", items: []), type: .chart, select: false)
                }
                let item = ShowItem(dsItem: CRSDataScreenItem(chartPath: "", iconName: "", title: "", info: ""), chartItem: ChartShowItem(title: chartItem.title, items: showItem), type: .chart, select: false)
                chartItems.append(item)
            }
            
            items.insert(contentsOf: chartItems, at: 0)
            let group = ShowItemGroup(items: items, dsGroup: dsGroup, select: index == 0)
            listItemGroups.append(group)
        }
        
        seletGroup = listItemGroups.first
        groupTableView.reloadData()
        itemListTableView.reloadData()
    }
    
    private func setupUI() {
        addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        addSubview(groupTableView)
        groupTableView.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.width.equalTo(80)
        }
        
        addSubview(itemListTableView)
        itemListTableView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.left.equalTo(groupTableView.snp.right)
        }
    }
    
}

extension CRSDataScreenItemListView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == groupTableView {
            return 48
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == groupTableView {
            return listItemGroups.count
        } else {
            return seletGroup?.items.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == groupTableView {
            let cell = tableView.dequeueReusableCell(cellType: CRSDSItemGroupListCell.self, for: indexPath)
            let group = listItemGroups[indexPath.row]
            cell.nameLabel.text = group.dsGroup.name
            cell.isItemSelect = group.select
            return cell
        } else {
            if let seletGroup {
                let item = seletGroup.items[indexPath.row]
                if item.type == .chart {
                    let cell = tableView.dequeueReusableCell(cellType: CRSDSItemDetailChartCell.self, for: indexPath)
                    cell.type = .type22
                    cell.chartItems = item.chartItem.items
                    cell.nameLabel.text = item.chartItem.title
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(cellType: CRSDSItemDetailListCell.self, for: indexPath)
                    cell.titleLabel.text = item.dsItem.title
                    cell.infoLabel.text = item.dsItem.info
                    cell.itemSelect = item.select
                    return cell
                }
            } else {
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == groupTableView {
            let beforeGroup = listItemGroups[indexPath.row]
            guard !beforeGroup.select else { return }
            
            for (index, var group) in listItemGroups.enumerated() {
                if index == indexPath.row {
                    group.select = true
                } else {
                    group.select = false
                }
                
                listItemGroups[index] = group
            }
            groupTableView.reloadData()
            
            let group = listItemGroups[indexPath.row]
            seletGroup = group
            itemListTableView.reloadData()
        }
    }
    
}
