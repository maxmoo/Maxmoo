//
//  CRSCastScreenOrderCell.swift
//  Maxmoo
//
//  Created by 程超 on 2023/12/7.
//

import UIKit

class CRSCastScreenOrderCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var iconClickBlock: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageClick))
        tapGesture.numberOfTapsRequired = 1
        iconImageView.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 点击时刷新排序图标
        changeSortIconImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            changeSortIconImage()
        }
    }
    
    func changeSortIconImage() {
        for view in subviews where view.description.contains("Reorder") {
            for case let subview as UIImageView in view.subviews {
                subview.image = UIImage(named: "Dail1")
                subview.frame.size.height = 25
//                view.width = 50
            }
        }
    }
    
    @objc
    func imageClick() {
        if let iconClickBlock {
            iconClickBlock()
        }
    }
    
}

