//
//  CRSDSItemDetailListCell.swift
//  Maxmoo
//
//  Created by 程超 on 2024/10/30.
//

import UIKit

class CRSDSItemDetailListCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var selectIconImageView: UIImageView!
    
    var itemSelect: Bool = false {
        didSet {
            if itemSelect {
                titleLabel.textColor = .blue
                infoLabel.textColor = .blue
                selectIconImageView.image = UIImage(named: "")
            } else {
                titleLabel.textColor = .white
                infoLabel.textColor = .darkGray
                selectIconImageView.image = UIImage(named: "")
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
