//
//  CRSDSItemGroupListCell.swift
//  Maxmoo
//
//  Created by 程超 on 2024/10/30.
//

import UIKit

class CRSDSItemGroupListCell: UITableViewCell {

    
    @IBOutlet weak var backColorView: UIView!
    @IBOutlet weak var selectFlagView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var isItemSelect: Bool = false {
        didSet {
            if isItemSelect {
                backColorView.backgroundColor = .darkGray
                selectFlagView.backgroundColor = .blue
            } else {
                backColorView.backgroundColor = .lightGray
                selectFlagView.backgroundColor = .clear
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
