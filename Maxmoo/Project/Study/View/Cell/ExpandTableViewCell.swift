//
//  ExpandTableViewCell.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit
import SnapKit

class ExpandTableViewCell: UITableViewCell {

    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    var item: ExpandCellItem? {
        didSet {
            titleLabel.text = item?.name
            if item?.isExtra == true {
                infoView.isHidden = false
            } else {
                infoView.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        infoView.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        pickerView.dataSource = ["s", "2", "xxxx", "we did that on yestoday! hahahaahahaahaahahahahaahahaah!"]
        pickerView.selectedIndex = 0
        pickerView.reloadAllComponents()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func selectedDateChanged() {
        print("pickerView: \(pickerView.selectedValue)")
    }
    
    private lazy var pickerView: CRSSingleRowPickerView = {
        let view = CRSSingleRowPickerView()
        view.textColor = .red
        view.isLoop = true
        view.selectedRowBackgroundColor = .clear
        view.didSelectedCallback = { [weak self] view, item, index in
            guard let self = self else { return }
            self.selectedDateChanged()
        }
        return view
    }()
}
