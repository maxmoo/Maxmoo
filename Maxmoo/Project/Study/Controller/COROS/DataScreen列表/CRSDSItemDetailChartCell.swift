//
//  CRSDSItemDetailChartCell.swift
//  Maxmoo
//
//  Created by 程超 on 2024/10/30.
//

import UIKit
import SnapKit

class CRSDSItemDetailChartCell: UITableViewCell {

    public var type: ChartType = .type12
    
    public var chartItems: [CRSDataScreenItemListView.ShowItem] = [] {
        didSet {
            createSubViews()
        }
    }
    
    enum ChartType {
        case type12
        case type22
        case type32
        
        var height: CGFloat {
            switch self {
            case .type12:
                return 50
            case .type22:
                return 100
            case .type32:
                return 150
            }
        }
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.backgroundColor = .randomColor
        label.textColor = .white
        label.text = "xxxxxxxxxxx"
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func createSubViews() {
        contentView.removeAllSubviews()
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(20)
        }
        
        let numberOfChart = chartItems.count
        let bottomLevel = Int((numberOfChart + 1) / 2)
        var lastChart: CRSDSItemDetailChartItemView?
        for i in 1...numberOfChart {
            let chartItem = chartItems[i - 1]
            let chartView = createChartImageView(item: chartItem, isSelect: chartItem.select)
            chartView.selectCallBack = { [weak self] in
                self?.selectItem(chartView)
            }
            chartView.tag = i - 1
            contentView.addSubview(chartView)
            
            let level = Int((i + 1) / 2)
            let isLeft = (i % 2) == 1
            
            if level == bottomLevel {
                if isLeft {
                    if let lastChart {
                        chartView.snp.makeConstraints { make in
                            make.left.equalTo(16)
                            make.top.equalTo(lastChart.snp.bottom).offset(8)
                            make.height.equalTo(type.height)
                            make.right.equalToSuperview().multipliedBy(0.5).offset(-4)
                            make.bottom.equalToSuperview().offset(-16).priority(999)
                        }
                    } else {
                        chartView.snp.makeConstraints { make in
                            make.left.equalTo(16)
                            make.top.equalTo(nameLabel.snp.bottom).offset(8)
                            make.height.equalTo(type.height)
                            make.right.equalToSuperview().multipliedBy(0.5).offset(-4)
                            make.bottom.equalToSuperview().offset(-16).priority(999)
                        }
                    }
                } else {
                    if let lastChart {
                        chartView.snp.makeConstraints { make in
                            make.top.equalTo(lastChart.snp.top)
                            make.left.equalTo(lastChart.snp.right).offset(4)
                            make.right.equalToSuperview().offset(-16)
                            make.height.equalTo(lastChart.snp.height)
                            make.bottom.equalToSuperview().offset(-16).priority(999)
                        }
                    }
                }
            } else {
                if isLeft {
                    if let lastChart {
                        chartView.snp.makeConstraints { make in
                            make.left.equalTo(16)
                            make.top.equalTo(lastChart.snp.bottom).offset(8)
                            make.height.equalTo(type.height)
                            make.right.equalToSuperview().multipliedBy(0.5).offset(-4)
                        }
                    } else {
                        chartView.snp.makeConstraints { make in
                            make.left.equalTo(16)
                            make.top.equalTo(nameLabel.snp.bottom).offset(8)
                            make.height.equalTo(type.height)
                            make.right.equalToSuperview().multipliedBy(0.5).offset(-4)
                        }
                    }
                } else {
                    if let lastChart {
                        chartView.snp.makeConstraints { make in
                            make.top.equalTo(lastChart.snp.top)
                            make.left.equalTo(lastChart.snp.right).offset(4)
                            make.right.equalToSuperview().offset(-16)
                            make.height.equalTo(lastChart.snp.height)
                        }
                    }
                }
            }
            
            lastChart = chartView
        }
    }
    
    private func createChartImageView(item: CRSDataScreenItemListView.ShowItem, isSelect: Bool = false) -> CRSDSItemDetailChartItemView {
        let chartView = CRSDSItemDetailChartItemView(frame: .zero, item: item, isSelect: isSelect)
        chartView.backgroundColor = .clear
        return chartView
    }
    
    private func selectItem(_ item: CRSDSItemDetailChartItemView) {
        print("select index: \(item.tag)")
    }
}


class CRSDSItemDetailChartItemView: UIView {
    
    var selectCallBack: (() -> Void)?
    
    lazy var borderView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.cornerRadius = 4
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.borderWidth = 3
        return view
    }()
    
    lazy var imageView: UIView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .randomColor
        return imageView
    }()
    
    var item: CRSDataScreenItemListView.ShowItem?
    
    lazy var isSelect: Bool = false {
        didSet {
            if isSelect {
                borderView.layer.borderColor = UIColor.blue.cgColor
            } else {
                borderView.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    convenience init(frame: CGRect, item: CRSDataScreenItemListView.ShowItem, isSelect: Bool) {
        self.init(frame: frame)
        self.item = item
        self.isSelect = isSelect
        if isSelect {
            borderView.layer.borderColor = UIColor.blue.cgColor
        } else {
            borderView.layer.borderColor = UIColor.clear.cgColor
        }
        
        addSubview(borderView)
        borderView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(4)
            make.right.bottom.equalToSuperview().offset(-4)
        }
        
        addTapGesture { [weak self] in
            self?.isSelect = true
            if let selectCallBack = self?.selectCallBack {
                selectCallBack()
            }
        }
    }
    
}
