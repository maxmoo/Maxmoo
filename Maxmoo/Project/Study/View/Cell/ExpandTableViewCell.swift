//
//  ExpandTableViewCell.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit

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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
