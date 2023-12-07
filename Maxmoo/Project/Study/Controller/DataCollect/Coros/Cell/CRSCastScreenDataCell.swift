//
//  CRSCastScreenDataCell.swift
//  Maxmoo
//
//  Created by 程超 on 2023/12/1.
//

import UIKit

class CRSCastScreenDataCell: UICollectionViewCell {

    @IBOutlet weak var unitConstraintOffsetY: NSLayoutConstraint!
    @IBOutlet weak var titleConstraintOffsetY: NSLayoutConstraint!
    @IBOutlet weak var valueConstrainOffsetY: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    var dataStyle: CRSCastScreenDataStyle = .one {
        didSet {
            refreshFont()
            refreshConstraint()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func refreshFont() {
        titleLabel.font = dataStyle.titleFont
        valueLabel.font = dataStyle.valueFont
        unitLabel.font = dataStyle.unitFont
    }
    
    private func refreshConstraint() {
        valueConstrainOffsetY.constant = dataStyle.valueOffset
        unitConstraintOffsetY.constant = dataStyle.unitOffset
        titleConstraintOffsetY.constant = dataStyle.titleOffset
    }
    
}
