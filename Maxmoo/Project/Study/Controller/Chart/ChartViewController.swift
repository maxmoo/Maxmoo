//
//  ChartViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/1/21.
//

import UIKit

class ChartViewController: UIViewController {

    lazy var chart: CRSTrackClimbChartView = {
        let chart = CRSTrackClimbChartView(frame: CGRect(x: 16, y: 100, width: kScreenWidth - 32, height: 180))
        chart.backgroundColor = .randomColor
        return chart
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(chart)
        chart.trackInfos = CRSTrackClimbInfo.testInfos()
    }

}
