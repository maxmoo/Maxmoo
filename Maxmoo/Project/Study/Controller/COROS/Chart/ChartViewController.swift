//
//  ChartViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/1/21.
//

import UIKit

class ChartViewController: UIViewController {

//    lazy var button: UIButton = {
//        let bu = UIButton(frame: CGRect(x: 16, y: 100, width: 100, height: 40))
//        bu.backgroundColor = .randomColor
//        bu.addTarget(self, action: #selector(refreshChart), for: .touchUpInside)
//        return bu
//    }()
//    
//    lazy var chart: CRSTrackClimbChartView = {
//        let chart = CRSTrackClimbChartView(frame: CGRect(x: 16, y: 200, width: kScreenWidth - 32, height: 180))
//        chart.backgroundColor = .randomColor
//        return chart
//    }()
//    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        
//        view.addSubview(button)
//        view.addSubview(chart)
//        addDragMove()
        
        let selectView = CRSSegmentMemberSelectView(frame: CGRect(x: 0, y: 300, width: kScreenWidth, height: 128))
        selectView.backgroundColor = .randomColor
        view.addSubview(selectView)
        
        let animateMenu = CRSAnimateCircleMenuView(frame: CGRect(x: kScreenWidth / 2, y: 500, width: 40, height: 40))
        animateMenu.backgroundColor = .randomColor
        view.addSubview(animateMenu)
        
    }
//
//    
//    @objc
//    func refreshChart() {
//        let start = Int.random(in: 0..<10)
//        let gap = Int.random(in: 1..<9)
//        chart.highlightRange = start..<(start+gap)
//        
//        let preVC = CRSClimbProDetailController()
//        let hei = preVC.showHeight(with: 2)
//        addPullUpController(preVC, initialStickyPointOffset: hei, animated: true)
//    }
    
    func addDragMove() {
        let button = CRSDragMoveButton(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        button.backgroundColor = .red
        button.assistiveType = .horizon
        view.addSubview(button)
        
        //点击事件
        button.action = {(sender) in
            print("click---->",123344)
        }
    }
}
