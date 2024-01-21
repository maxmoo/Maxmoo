//
//  CRSTrackClimbChartView.swift
//  Maxmoo
//
//  Created by 程超 on 2024/1/21.
//

import UIKit

struct CRSTrackClimbInfo {
    var distance: Double?
    var climbHeigh: Double?
    var level: Int?
    
    static func testInfos() -> [CRSTrackClimbInfo] {
        var testInfos: [CRSTrackClimbInfo] = []
        for x in 0...20 {
            let info = CRSTrackClimbInfo(distance: Double.random(in: 3...9) + Double(x * 10),
                                         climbHeigh: Double.random(in: 10...200) + Double(x * 50),
                                         level: Int.random(in: 1...5))
            testInfos.append(info)
        }
        return testInfos
    }
}

class CRSTrackClimbChartView: UIView {

    var trackInfos: [CRSTrackClimbInfo] = [] {
        didSet {
            refreshChart()
        }
    }
    
    // 图表距离边界的距离
    var chartInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 40, bottom: 30, right: 16)
    
    // X轴最大值
    private var maxX: Double = -Double.greatestFiniteMagnitude
    // X轴最小值
    private var minX: Double = Double.greatestFiniteMagnitude
    // Y轴最大值
    private var maxY: Double = -Double.greatestFiniteMagnitude
    // Y轴最小值
    private var minY: Double = Double.greatestFiniteMagnitude
    
    // MARK: - UI
    // X轴
    private var xBaseLineLayer: CAShapeLayer = {
        let xLayer = CAShapeLayer()
        xLayer.frame = .zero
        xLayer.backgroundColor = UIColor.red.cgColor
        return xLayer
    }()
    
    // Y轴
    private var yBaseLineLayer: CAShapeLayer = {
        let yLayer = CAShapeLayer()
        yLayer.backgroundColor = UIColor.red.cgColor
        return yLayer
    }()
    
    // 图表
    private var lineChartLayer: CAShapeLayer = {
        let chartLayer = CAShapeLayer()
        chartLayer.fillColor = UIColor.clear.cgColor
        chartLayer.lineWidth = 3.0
        chartLayer.lineCap = .round
        chartLayer.lineJoin = .round
        chartLayer.strokeColor = UIColor.purple.cgColor
        return chartLayer
    }()
    
    // 方块颜色
    private var colorRectLayer: CAShapeLayer = {
        let rectLayer = CAShapeLayer()
        return rectLayer
    }()

    private func refreshChart() {
        xBaseLineLayer.frame = CGRect(x: chartInset.left,
                                      y: self.height - chartInset.bottom,
                                      width: self.width - chartInset.left - chartInset.right,
                                      height: 0.5)
        layer.addSublayer(xBaseLineLayer)
        yBaseLineLayer.frame = CGRect(x: chartInset.left,
                                      y: chartInset.top,
                                      width: 0.5,
                                      height: self.height - chartInset.top - chartInset.bottom)
        layer.addSublayer(yBaseLineLayer)
        
        // 找到当前最大值和最小值
        maxInfos()
        
        // 方块
        colorRectLayer.frame = CGRect(x: chartInset.left, y: chartInset.top, width: xBaseLineLayer.width, height: yBaseLineLayer.height)
        layer.addSublayer(colorRectLayer)
        
        // 线
        lineChartLayer.frame = CGRect(x: chartInset.left, y: chartInset.top, width: xBaseLineLayer.width, height: yBaseLineLayer.height)
        layer.addSublayer(lineChartLayer)
        drawLineChart()
    }
    
    // 画平滑曲线
    private func drawLineChart() {
        if let colorSublasyers = colorRectLayer.sublayers {
            for subLayer in colorSublasyers {
                subLayer.removeFromSuperlayer()
            }
        }

        let drawWidth = lineChartLayer.width
        let drawHeigh = lineChartLayer.height
        var drawPoint = CGPoint.zero
        
        var lastPoint: CGPoint = .zero
        var lastRectHei: CGFloat = -CGFloat.greatestFiniteMagnitude
        var path = UIBezierPath.init()

        for (index, info) in self.trackInfos.enumerated() {
            guard let dis = info.distance, let cH = info.climbHeigh else { continue }
            
            let x = (dis - minX) / (maxX - minX) * drawWidth
            let y = (1 - (cH - minY)/(maxY - minY)) * drawHeigh
            // line
            drawPoint = CGPoint(x: x, y: y)
            // rect
            let rectH = ((cH - minY)/(maxY - minY)) * drawHeigh
            let finalRectH = max(rectH, lastRectHei)
            let rect = CGRect(x: lastPoint.x, y: colorRectLayer.height - finalRectH, width: x - lastPoint.x, height: finalRectH)
            let rectLayer = CAShapeLayer()
            rectLayer.frame = rect
            rectLayer.backgroundColor = UIColor.randomColor.cgColor
            colorRectLayer.addSublayer(rectLayer)
            lastRectHei = finalRectH
            lastPoint = drawPoint

            if index == 0 {
                path.move(to: drawPoint)
            } else {
                path.addLine(to: drawPoint)
            }
        }
        
        path = path.smoothedPath(withGranularity: 10)
        lineChartLayer.path = path.cgPath
        
        let maskLayer = CAShapeLayer()
        path.addLine(to: CGPoint(x: lineChartLayer.width, y: lineChartLayer.height))
        path.addLine(to: CGPoint(x: 0, y: lineChartLayer.height))
        maskLayer.path = path.cgPath
        colorRectLayer.mask = maskLayer
        
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.fromValue = 0
//        animation.toValue = 3
//        animation.autoreverses = false
//        animation.duration = 3
//        
//        lineChartLayer.add(animation, forKey: nil)
//        lineChartLayer.strokeEnd = 1
    }
    
}


// MARK: - calculate
extension CRSTrackClimbChartView {
    
    private func maxInfos() {
        for trackInfo in self.trackInfos {
            guard let dis = trackInfo.distance,
                  let hei = trackInfo.climbHeigh else { continue }
    
            maxX = max(dis, maxX)
            minX = min(dis, minX)
            maxY = max(hei, maxY)
            minY = min(hei, minY)
        }
    }
    
}
