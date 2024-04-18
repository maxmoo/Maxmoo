//
//  CRSClimbProListCell.swift
//  Maxmoo
//
//  Created by 程超 on 2024/2/22.
//

import UIKit

class CRSClimbProListCell: UITableViewCell {

    @IBOutlet weak var normalBackView: UIView!
    
    @IBOutlet weak var lapLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceScopeLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var climbLabel: UILabel!
    @IBOutlet weak var flagIconImageView: UIImageView!
    
    @IBOutlet weak var infoBottomLine: UIView!
    @IBOutlet weak var chartBottomLine: UIView!
    
    var headerClicked: (() -> Void)?
    
//    lazy var chart: CRSTrackClimbChartView = {
//        let chart = CRSTrackClimbChartView(frame: CGRect(x: 16, y: 56, width: kScreenWidth - 32, height: 154))
//        chart.isHidden = true
//        return chart
//    }()
//    
//    public var item: CRSClimbListItem? {
//        didSet {
//            if let item {
//                item.isExtra ? showChart() : hideChart()
//                chart.trackInfos = item.infos
//                lapLabel.text = item.lapString
//                distanceLabel.text = item.distanceString
//                distanceScopeLabel.text = item.distanceScopeString
//                percentageLabel.text = item.percentageString
//                climbLabel.text = item.climbValueString
//            } else {
//                lapLabel.text = ""
//                distanceLabel.text = ""
//                distanceScopeLabel.text = ""
//                percentageLabel.text = ""
//                climbLabel.text = ""
//            }
//        }
//    }
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        addSubview(chart)
//        
//        normalBackView.addTapGesture {
//            [weak self] in
//            if let clicked = self?.headerClicked {
//                clicked()
//            }
//        }
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
//    public func showChart() {
//        chart.alpha = 0
//        chart.isHidden = false
//        chartBottomLine.alpha = 0
//        chartBottomLine.isHidden = false
//        UIView.animate(withDuration: 0.2) {
//            self.chart.alpha = 1
//            self.chartBottomLine.alpha = 1
//        }
//        
//        let rotation = CGAffineTransformMakeRotation(Double.pi)
//        flagIconImageView.transform = rotation
//    }
//    
//    public func hideChart() {
//        chart.isHidden = true
//        chartBottomLine.isHidden = true
//        flagIconImageView.transform = CGAffineTransformIdentity
//    }
    
}
