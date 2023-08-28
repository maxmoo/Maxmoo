//
//  CRSSinglePickerController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit

class CRSSinglePickerController: CCBaseViewController {

    // 选项是否循环
    var isLoop = false {
        didSet {
            yearPickerView.isLoop = isLoop
            monthPickerView.isLoop = isLoop
            dayPickerView.isLoop = isLoop
        }
    }
    
    private lazy var yearPickerView: CRSSingleRowPickerView = {
        let view = CRSSingleRowPickerView()
        view.isLoop = isLoop
        view.selectedRowBackgroundColor = .clear
        view.didSelectedCallback = { [weak self] view, item, index in
            guard let self = self else { return }
            self.selectedDateChanged()
        }
        return view
    }()
    
    private lazy var monthPickerView: CRSSingleRowPickerView = {
        let view = CRSSingleRowPickerView()
        view.isLoop = isLoop
        view.selectedRowBackgroundColor = .clear
        view.didSelectedCallback = { [weak self] view, item, index in
            guard let self = self else { return }
            self.selectedDateChanged()
        }
        return view
    }()
    
    private lazy var dayPickerView: CRSSingleRowPickerView = {
        let view = CRSSingleRowPickerView()
        view.isLoop = isLoop
        view.selectedRowBackgroundColor = .clear
        view.didSelectedCallback = { [weak self] view, item, index in
            guard let self = self else { return }
            self.selectedDateChanged()
        }
        return view
    }()
    
    private lazy var backView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 200, width: 300, height: 100))
        view.backgroundColor = .red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configData()
    }
    
    func setupUI() {
        view.addSubview(backView)
        backView.addSubview(yearPickerView)
        backView.addSubview(monthPickerView)
        backView.addSubview(dayPickerView)
        yearPickerView.snp.updateConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1.0 / 3.0)
        }
        monthPickerView.snp.updateConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(yearPickerView.snp.right)
            make.width.equalToSuperview().multipliedBy(1.0 / 3.0)
        }
        dayPickerView.snp.updateConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(monthPickerView.snp.right)
            make.width.equalToSuperview().multipliedBy(1.0 / 3.0)
        }
    }
    
    func configData() {
        yearPickerView.dataSource = ["2012年", "2013年", "2014年"]
        yearPickerView.selectedIndex = 1
        yearPickerView.reloadAllComponents()
        
        monthPickerView.dataSource = ["1月", "2月", "3月"]
        monthPickerView.selectedIndex = 2
        monthPickerView.reloadAllComponents()
        
        dayPickerView.dataSource = ["1日", "2日", "3日"]
        dayPickerView.selectedIndex = 0
        dayPickerView.reloadAllComponents()
    }
    
    func selectedDateChanged() {
        let selectedDay = dayPickerView.selectedValue
        let selectedMonth = monthPickerView.selectedValue
        let selectedYear = yearPickerView.selectedValue
        print("[picker change] \(selectedYear)-\(selectedMonth)-\(selectedDay)")
    }
}
