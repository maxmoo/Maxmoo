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

    public var trackInfos: [CRSTrackClimbInfo] = [] {
        didSet {
            refreshChart()
        }
    }
    
    // 图表距离边界的距离
    public var chartInset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 40, bottom: 30, right: 16) {
        didSet {
            refreshChart()
        }
    }
    
    // 高亮的index范围
    public var highlightRange: Range = Int(Int.max - 1)..<Int(Int.max) {
        didSet {
            drawChart()
        }
    }
    
    // 是否显示坐标轴
    public var isShowLabels: Bool = true {
        didSet {
            resetXLabels()
            resetYLabels()
        }
    }
    
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
    
    // X标签集合
    private var xLineLabels: [UILabel] = []
    
    // Y标签集合
    private var yLineLabels: [UILabel] = []
    
    // 图表
    private var lineChartLayer: CAShapeLayer = {
        let chartLayer = CAShapeLayer()
        chartLayer.fillColor = UIColor.clear.cgColor
        chartLayer.lineWidth = 1.0
        chartLayer.lineCap = .round
        chartLayer.lineJoin = .round
        chartLayer.strokeColor = UIColor.clear.cgColor
        return chartLayer
    }()
    
    // 方块颜色
    private var colorRectLayer: CAShapeLayer = {
        let rectLayer = CAShapeLayer()
        return rectLayer
    }()

    private func refreshChart() {
        // 找到当前最大值和最小值
        maxInfos()
        
        // UI
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
        
        // 方块
        colorRectLayer.frame = CGRect(x: chartInset.left, y: chartInset.top, width: xBaseLineLayer.width, height: yBaseLineLayer.height)
        layer.addSublayer(colorRectLayer)
        
        // 线
        lineChartLayer.frame = CGRect(x: chartInset.left, y: chartInset.top, width: xBaseLineLayer.width, height: yBaseLineLayer.height)
        layer.addSublayer(lineChartLayer)
        drawChart()
        
        // 标签
        resetXLabels()
        resetYLabels()
    }
    
    // 画平滑曲线
    private func drawChart() {
        if let colorSublayers = colorRectLayer.sublayers {
            for subLayer in colorSublayers {
                subLayer.removeFromSuperlayer()
            }
        }

        if let lineSublayers = lineChartLayer.sublayers {
            for subLayer in lineSublayers {
                subLayer.removeFromSuperlayer()
            }
        }
        
        let drawWidth = lineChartLayer.width
        let drawHeigh = lineChartLayer.height
        var drawPoint = CGPoint.zero
        
        // highlight 边界竖线
        var highStartIndex: Int = -2
        var highEndIndex: Int = -1
        if trackInfos.count > 0, highlightRange.endIndex > highlightRange.startIndex {
            let countRange = 0..<trackInfos.count
            if countRange.contains(highlightRange.startIndex) &&
                countRange.contains(highlightRange.endIndex - 1) {
                highStartIndex = highlightRange.startIndex
                highEndIndex = highlightRange.endIndex - 1
            }
        }
        
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
            rectLayer.backgroundColor = color(level: info.level).cgColor
            colorRectLayer.addSublayer(rectLayer)
            
            // not highlight
            if !highlightRange.contains(index) {
                let darkRectLayer = CAShapeLayer()
                darkRectLayer.frame = rect
                darkRectLayer.backgroundColor = UIColor(white: 0.3, alpha: 0.8).cgColor
                colorRectLayer.addSublayer(darkRectLayer)
            }
            
            // highlight
            if index == highStartIndex {
                let hx = rect.x - 0.25
                let vLayer = vDottedLine(at: hx, color: .blue, height: colorRectLayer.height)
                lineChartLayer.addSublayer(vLayer)
            }
            
            if index == highEndIndex {
                let hx = rect.x + rect.width - 0.25
                let vLayer = vDottedLine(at: hx, color: .blue, height: colorRectLayer.height)
                lineChartLayer.addSublayer(vLayer)
            }
            
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
    }
    
    // 重设X轴标签
    private func resetXLabels() {
        for label in xLineLabels {
            label.removeFromSuperview()
        }
        guard isShowLabels else { return }
        
        let xLabelStrings: [String] = ["0", "15", "30", "1099"]
        for (index, ti) in xLabelStrings.enumerated() {
            let label = createLabel(info: ti)
            label.top = xBaseLineLayer.bottom
            label.centerX = ((xBaseLineLayer.width / CGFloat(xLabelStrings.count - 1)) * CGFloat(index)) + chartInset.left
            // 最后一个
            addSubview(label)
            xLineLabels.append(label)
        }
    }
    
    // 重设Y轴标签
    private func resetYLabels() {
        for label in yLineLabels {
            label.removeFromSuperview()
        }
        guard isShowLabels else { return }
     
        let yLabelStrings: [String] = ["0", "15", "30", "1099"]
        guard yLabelStrings.count > 1 else { return }
        for (index, ti) in yLabelStrings.enumerated() {
            let label = createLabel(info: ti)
            label.bottom = (yBaseLineLayer.height / CGFloat(yLabelStrings.count - 1)) * CGFloat(yLabelStrings.count - 1 - index) + chartInset.top + 5
            label.right = yBaseLineLayer.left - 2
            addSubview(label)
            yLineLabels.append(label)
        }
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
    
    private func color(level: Int?) -> UIColor {
        switch level {
        case 1:
            return .red
        case 2:
            return .yellow
        case 3:
            return .purple
        case 4:
            return .green
        case 5:
            return .brown
        default:
            return .black
        }
    }
}

// MARK: - create ui
extension CRSTrackClimbChartView {
    // 竖直线
    @discardableResult
    private func vDottedLine(at x: CGFloat,
                        color: UIColor,
                        height: CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: x - 0.5, y: 0, width: 1, height: height)
        layer.lineWidth = 1.0
        layer.lineDashPattern = [4,2]
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color.cgColor
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0.5, y: 0))
        path.addLine(to: CGPoint(x: 0.5, y: layer.bounds.height))
        
        layer.path = path
        self.layer.addSublayer(layer)
        
        return layer
    }
    
    private func createLabel(info: String) -> UILabel {
        let label = UILabel(frame: .zero)
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = info
        
        let width = info.width(font: label.font)
        label.frame = CGRect(x: 0, y: 0, width: width, height: 20)
        
        return label
    }
}
