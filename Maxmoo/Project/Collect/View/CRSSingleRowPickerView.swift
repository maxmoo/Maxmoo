//
//  CustomSinglePickerView.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit
import Foundation
import SnapKit

typealias CRSPickerViewDidSelectedCallback = (_ view: CRSSingleRowPickerView, _ item: String, _ index: Int) -> Void
typealias CRSPickerViewRowTextCallback = (_ view: CRSSingleRowPickerView, _ component: Int, _ row: Int) -> String?

protocol CRSSingleRowPickerProtocol {
    var numberOfComponents: Int { get }
    func numberOfRows(in component: Int) -> Int
    func reloadAllComponents()
    func reloadComponent(_ component: Int)
    func selectRow(_ row: Int, inComponent: Int, animated: Bool)
    func selectedRow(inComponent: Int) -> Int
    func view(forRow: Int, forComponent: Int) -> UIView?
}

class CRSSingleRowPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, CRSSingleRowPickerProtocol {
    
    private let loopCount = 100
    
    // 是否初始化完毕
    private var isInited = false
    
    // 是否已经设置了中间选中条的颜色
    private var isConfigSelectedRowBackgroungColor = false
    
    // 是否无限循环
    var isLoop = false {
        didSet {
            var selIndex = selectedIndex
            if isLoop {
                selIndex = dataSource.count * loopCount / 2 + selIndex
            }
            pickerView.reloadAllComponents()
            pickerView.selectRow(selIndex, inComponent: 0, animated: false)
        }
    }
    
    // 当前选择值
    var selectedValue: String? {
        get {
            if dataSource.isEmpty || !isInited {
                return nil
            }
            let loopIndex = pickerView.selectedRow(inComponent: 0)
            let realIndex = loopIndex % dataSource.count
            return dataSource[realIndex]
        }
        set {
            if dataSource.isEmpty || !isInited || newValue == nil {
                return
            }
            let index = dataSource.firstIndex(of: newValue!)
            if let index = index {
                let currentIndex = pickerView.selectedRow(inComponent: 0)
                let offset = currentIndex % dataSource.count
                let newIndex = max(0, currentIndex - offset) + index
                pickerView.selectRow(newIndex, inComponent: 0, animated: true)
            }
        }
    }
    
    // 当前选择的索引
    var selectedIndex: Int {
        get {
            if dataSource.isEmpty || !isInited {
                return 0
            }
            let loopIndex = pickerView.selectedRow(inComponent: 0)
            return loopIndex % dataSource.count
        }
        set {
            if dataSource.isEmpty || !isInited || newValue >= dataSource.count {
                return
            }
            selectedValue = dataSource[newValue]
        }
    }
    
    // 选中回调
    var didSelectedCallback: CRSPickerViewDidSelectedCallback?
    
    // 显示文本的回调
    var customRowTextCallback: CRSPickerViewRowTextCallback?
    
    // 数据源
    var dataSource = [String]() {
        didSet {
            reloadPickerView()
        }
    }
    
    // 行高
    var rowHeight = 36.0 {
        didSet {
            if !isInited || dataSource.isEmpty {
                return
            }
            selectedRowView.snp.updateConstraints { make in
                make.height.equalTo(rowHeight)
            }
            pickerView.reloadAllComponents()
        }
    }
    
    // 文字颜色
    var textColor: UIColor = .black {
        didSet {
            if !isInited || dataSource.isEmpty {
                return
            }
            pickerView.reloadAllComponents()
        }
    }
    
    // 字体
    var textFont: UIFont = .systemFont(ofSize: 16) {
        didSet {
            if !isInited || dataSource.isEmpty {
                return
            }
            pickerView.reloadAllComponents()
        }
    }
    
    // 中间选中条的颜色
    var selectedRowBackgroundColor: UIColor = .black {
        didSet {
            configSelectedRowBackgroundColor()
        }
    }
    
    var numberOfComponents: Int { 1 }
    
    deinit {
        print("single picker deinit!")
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: 设置UI
    
    func setupUI() {
        addSubview(selectedRowView)
        addSubview(pickerView)
        pickerView.snp.updateConstraints { make in
            make.edges.equalTo(self)
        }
        selectedRowView.snp.updateConstraints { make in
            make.center.width.equalTo(pickerView)
            make.height.equalTo(rowHeight)
        }
        configSelectedRowBackgroundColor()
        isInited = true
    }
    
    // MARK: 刷新
    
    func reloadPickerView() {
        if !isInited || dataSource.isEmpty {
            return
        }
        var selIndex = selectedIndex
        if isLoop {
            selIndex = dataSource.count * loopCount / 2 + selIndex
        }
        pickerView.reloadAllComponents()
        pickerView.selectRow(selIndex, inComponent: 0, animated: false)
    }
    
    // MARK: 设置选择条的背景色
    
    func configSelectedRowBackgroundColor() {
        let subviews = pickerView.subviews
        if subviews.count >= 1 {
            subviews[1].backgroundColor = .clear
        }
        selectedRowView.backgroundColor = selectedRowBackgroundColor
    }
    
    func configSelectedRowBackgroundIfNeed() {
        if isConfigSelectedRowBackgroungColor {
            return
        }
        isConfigSelectedRowBackgroungColor = true
        configSelectedRowBackgroundColor()
    }
    
    // MARK: UIPickerViewDelegate, UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return isLoop ? dataSource.count * loopCount : dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var labelView = view as? UILabel
        if labelView == nil {
            labelView = UILabel()
            labelView?.font = textFont
            labelView?.textColor = textColor
            labelView?.textAlignment = .center
        }
        if customRowTextCallback != nil {
            labelView?.text = customRowTextCallback!(self, component, row % dataSource.count)
        } else {
            labelView?.text = dataSource[row % dataSource.count]
        }
        configSelectedRowBackgroundIfNeed()
        return labelView!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let realIndex = row % dataSource.count
        if isLoop {
            let loopIndex = dataSource.count * (loopCount / 2) + realIndex
            pickerView.selectRow(loopIndex, inComponent: component, animated: false)
        }
        didSelectedCallback?(self, dataSource[realIndex], realIndex)
    }
    
    // MARK: 删除一条数据
    
    func delete(index: Int) {
        if index < 0 || index >= dataSource.count {
            return
        }
        
        let curSelIndex = pickerView.selectedRow(inComponent: 0) % dataSource.count
        let selectedItem = dataSource[curSelIndex]
        
        dataSource.remove(at: index)
        
        if var newIndex = dataSource.firstIndex(of: selectedItem) {
            if isLoop {
                newIndex = dataSource.count * loopCount / 2 + newIndex
            }
            pickerView.selectRow(newIndex, inComponent: 0, animated: false)
        }
    }
    
    func delete(item: String) {
        let target = item.trimmingCharacters(in: .whitespaces)
        if target.isEmpty || dataSource.isEmpty {
            return
        }
        let index = dataSource.firstIndex(of: target)
        if let index = index {
            delete(index: index)
        }
    }
    
    // MARK: CRSSingleRowPickerProtocol
    
    func numberOfRows(in component: Int) -> Int {
        return pickerView.numberOfRows(inComponent: 0) % dataSource.count
    }
    
    func reloadAllComponents() {
        pickerView.reloadAllComponents()
    }
    
    func reloadComponent(_ component: Int) {
        pickerView.reloadComponent(0)
    }
    
    func selectRow(_ row: Int, inComponent: Int, animated: Bool) {
        pickerView.selectRow(row, inComponent: 0, animated: animated)
    }
    
    func selectedRow(inComponent: Int) -> Int {
        return pickerView.selectedRow(inComponent: 0) % dataSource.count
    }
    
    func view(forRow: Int, forComponent: Int) -> UIView? {
        return pickerView.view(forRow: forRow, forComponent: 0)
    }
    
    // MARK: lazy
    
    private lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        view.showsSelectionIndicator = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var selectedRowView: UIView = {
        let view = UIView()
        view.backgroundColor = selectedRowBackgroundColor
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    
}
