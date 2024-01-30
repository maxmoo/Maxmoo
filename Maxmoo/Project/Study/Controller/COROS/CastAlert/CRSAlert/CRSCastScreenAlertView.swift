//
//  CRSCastScreenAlertView.swift
//  Coros
//
//  Created by 程超 on 2023/12/14.
//  Copyright © 2023 YFTech. All rights reserved.
//

import UIKit
import SnapKit

// 用于提醒的model
struct CRSCastAlertModel {
    var icon: UIImage?
    var title: String?
    var value: String?
    var unit: String?
    var infoTitle: String?
    var infoValue: String?
}

struct CRSCastAlertGroupModel {
    var title: String?
    var items: [CRSCastAlertModel]?
}

// CRSCastAlertModel
class CRSCastScreenAlertView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.allCorner(radius: 12)
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 换项提醒，首次提醒，新纪录，记圈提醒
    public func buildFirstSubstituteAlert(title: String,
                                          header: CRSCastAlertModel?,
                                          items: [CRSCastAlertModel]?) {
        let titleLabel = valueLabel(title, font: UIFont.systemFont(ofSize: 16, weight: .medium), preHeight: 24, maxWidth: self.width - 32)
        titleLabel.textColor = .green
        titleLabel.left = 16
        titleLabel.top = 15
        self.addSubview(titleLabel)
        
        var left: CGFloat = 16
        let centerY = (self.height - titleLabel.bottom) / 2 + titleLabel.bottom
        if let header {
            if let icon = header.icon {
                let iconView = iconImageView(icon: icon)
                iconView.left = left
                iconView.centerY = centerY
                self.addSubview(iconView)
                left = iconView.right + 4
            }
            
            if let title = header.title {
                let headTitleLabel = valueLabel(title, font: UIFont.systemFont(ofSize: 24, weight: .medium), preHeight: 45, maxWidth: (self.width - 32) / 2)
                headTitleLabel.left = left
                headTitleLabel.centerY = centerY
                self.addSubview(headTitleLabel)
                left = headTitleLabel.right + 8
            }
            
            if let value = header.value {
                let headValueLabel = valueLabel(value, font: UIFont.systemFont(ofSize: 32, weight: .medium), preHeight: 45, maxWidth: (self.width - 32) / 2)
                headValueLabel.left = left
                headValueLabel.centerY = centerY
                self.addSubview(headValueLabel)
                left = headValueLabel.right
            }
            
            if let unit = header.unit {
                let headUnitLabel = valueLabel(unit, font: UIFont.systemFont(ofSize: 16, weight: .medium), maxWidth: 40)
                headUnitLabel.left = left
                headUnitLabel.centerY = centerY
                self.addSubview(headUnitLabel)
                left = headUnitLabel.right + 24
            }
        }
        
        if let items {
            for item in items {
                let itemView = itemView(item)
                itemView.left = left
                itemView.centerY = centerY
                self.addSubview(itemView)
                left = itemView.right + 24
            }
        }
    }
    
    // 换项提醒，非首次提醒
    public func buildSubstituteAlert(groups: [CRSCastAlertGroupModel]) {
        let (valueFont, unitFont) = autoFont(groups: groups, maxValueFontSize: 26, maxUnitFontSize: 14, maxCount: 3, totalWidth: self.width - 16 * 2)
        
        var left: CGFloat = 16
        for (index, group) in groups.enumerated() {
            if let title = group.title {
                let titleLabel = valueLabel(title, font: UIFont.systemFont(ofSize: 16, weight: .medium), preHeight: 24)
                titleLabel.left = left
                titleLabel.top = 15
                self.addSubview(titleLabel)
                
                let centerY = (self.height - titleLabel.bottom) / 2 + titleLabel.bottom
                var innerLeft = left
                if let items = group.items {
                    for item in items {
                        let itemView = itemView(item, valueFont: valueFont, unitFont: unitFont)
                        itemView.left = innerLeft
                        itemView.centerY = centerY - 5
                        self.addSubview(itemView)
                        innerLeft = max(itemView.right, innerLeft) + 24
                    }
                }
                
                if index < groups.count - 1 {
                    let vLine = vLine()
                    vLine.left = innerLeft
                    vLine.centerY = self.height / 2
                    self.addSubview(vLine)
                }
                
                left = innerLeft + 24
            }
        }
    }
    
    // 运动提醒
    public func buildSportAlert(title: String,
                                iconWidth: CGFloat = 16,
                                titleColor: UIColor = .white,
                                item: CRSCastAlertModel?) {
        
        let titleLabel = valueLabel(title,
                                    font: UIFont.systemFont(ofSize: 24, weight: .medium),
                                    preHeight: 50,
                                    maxWidth: 80)
        titleLabel.textColor = titleColor
        titleLabel.left = 16
        titleLabel.centerY = self.height / 2
        self.addSubview(titleLabel)
        
        let vLine = vLine()
        vLine.left = titleLabel.right + 16
        vLine.centerY = self.height / 2
        self.addSubview(vLine)
        
        if let item {
            let itemView = itemView(item, iconWidth: iconWidth)
            itemView.left = vLine.right + 15
            self.addSubview(itemView)
            
            if let info = item.infoTitle {
                itemView.centerY = titleLabel.centerY - 10
                
                var infoValueLabel = UILabel(frame: .zero)
                if let infoValue = item.infoValue {
                    infoValueLabel = valueLabel(infoValue, font: UIFont.systemFont(ofSize: 16, weight: .medium), preHeight: 30, maxWidth: (self.width - vLine.right - 15 - 16) / 2)
                    self.addSubview(infoValueLabel)
                }
                let infoLabel = valueLabel(info, font: UIFont.systemFont(ofSize: 12, weight: .medium), preHeight: 30, maxWidth: self.width - vLine.right - 15 - 16 - infoValueLabel.width)
                infoLabel.left = vLine.right + 15
                infoLabel.centerY = self.height - 25
                self.addSubview(infoLabel)
                
                infoValueLabel.left = infoLabel.right
                infoValueLabel.centerY = infoLabel.centerY
            } else {
                itemView.centerY = titleLabel.centerY
            }
        }
    }
    
    // 到达提醒
    public func buildArriveAlert(title: String,
                                 titleColor: UIColor = .white,
                                 item: CRSCastAlertModel?) {
        let titleLabel = valueLabel(title,
                                    font: UIFont.systemFont(ofSize: 24, weight: .medium),
                                    preHeight: 50,
                                    maxWidth: self.width / 2 - 16)
        titleLabel.textColor = titleColor
        titleLabel.left = 16
        titleLabel.centerY = self.height / 2
        self.addSubview(titleLabel)
        
        if let item {
            let itemView = itemView(item)
            itemView.left = titleLabel.right + 24
            itemView.centerY = titleLabel.centerY
            self.addSubview(itemView)
        }
    }
    
    // 提示提醒
    public func buildTipsAlert(item: CRSCastAlertModel) {
        var left: CGFloat = 16
        if let icon = item.icon {
            let iconView = iconImageView(icon: icon)
            iconView.frame = CGRect(x: left, y: 0, width: 16, height: 16)
            iconView.centerY = self.height / 2
            self.addSubview(iconView)
            left = iconView.right + 8
        }
        
        if let info = item.infoTitle {
            let label = valueLabel(info,
                                   font: UIFont.systemFont(ofSize: 16, weight: .medium),
                                   maxWidth: self.width - left - 16)
            label.left = left
            label.centerY = self.height / 2
            self.addSubview(label)
        }
    }
    
}

// MARK: - calculate
extension CRSCastScreenAlertView {
    
    private func autoFont(groups: [CRSCastAlertGroupModel],
                          maxValueFontSize: CGFloat,
                          maxUnitFontSize: CGFloat,
                          maxCount: Int,
                          totalWidth: CGFloat) -> (UIFont, UIFont) {
        
        let itemGap: CGFloat = 24
        let currentTotalWidth: CGFloat = totalWidth - CGFloat((groups.count - 1)) * itemGap
        
        var showItems: [CRSCastAlertModel] = []
        var allGroupItemsCount: Int = 0
        for group in groups {
            guard let items = group.items else { continue }
            for item in items {
                allGroupItemsCount += 1
                if allGroupItemsCount <= maxCount {
                    showItems.append(item)
                }
            }
        }
        
        let iconValueGap: CGFloat = 3
        let valueUnitGap: CGFloat = 1
        func autoWidth(valueFont: UIFont, unitFont: UIFont) -> CGFloat {
            var left: CGFloat = 0
            for showItem in showItems {
                if showItem.icon != nil {
                    left += 16
                }
                if let value = showItem.value {
                    let width = value.width(font: valueFont)
                    left += (iconValueGap + width)
                }
                if let unit = showItem.unit {
                    let unitWidth = unit.width(font: unitFont)
                    left += (valueUnitGap + unitWidth)
                }
                left += itemGap
            }
            
            left -= itemGap
            return left
        }
        
        var normalFontSize: CGFloat = maxValueFontSize + 1
        var normalUnitFontSize: CGFloat = maxUnitFontSize + 1
        var autoWidthValue: CGFloat = totalWidth * 2
        var resultFont: UIFont = UIFont.systemFont(ofSize: normalFontSize, weight: .medium)
        var resultUnitFont: UIFont = UIFont.systemFont(ofSize: normalUnitFontSize, weight: .regular)
        while autoWidthValue > currentTotalWidth {
            normalFontSize -= 1
            normalUnitFontSize = min((normalFontSize / 1.5) + 2, maxUnitFontSize)
            resultFont = UIFont.systemFont(ofSize: normalFontSize, weight: .medium)
            resultUnitFont = UIFont.systemFont(ofSize: normalUnitFontSize, weight: .regular)
            autoWidthValue = autoWidth(valueFont: resultFont, unitFont: resultUnitFont)
        }
        
        return (resultFont, resultUnitFont)
    }
}

// MARK: - factory
extension CRSCastScreenAlertView {
    
    // create
    private func itemView(_ item: CRSCastAlertModel,
                          iconWidth: CGFloat = 16,
                          valueFont: UIFont = UIFont.systemFont(ofSize: 36, weight: .medium),
                          unitFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium),
                          height: CGFloat = 54) -> UIView {
        let backView = UIView(frame: .zero)
        backView.height = height
        
        var left: CGFloat = 0
        if let icon = item.icon {
            let iconView = iconImageView(icon: icon)
            iconView.frame = CGRect(x: left, y: 0, width: iconWidth, height: iconWidth)
            iconView.centerY = backView.height / 2
            backView.addSubview(iconView)
            left = iconView.right + 3
        }
        
        if let value = item.value {
            let valueLabel = valueLabel(value, font: valueFont, preHeight: 50)
            valueLabel.left = left
            valueLabel.centerY = backView.height / 2
            backView.addSubview(valueLabel)
            left = valueLabel.right
        }
        
        if let unit = item.unit {
            let unitLabel = valueLabel(unit, font: unitFont, preHeight: 20)
            unitLabel.left = left
            unitLabel.centerY = backView.height / 2
            backView.addSubview(unitLabel)
            left = unitLabel.right
        }
        
        backView.width = left
        return backView
    }
    
    // info label
    private func valueLabel(_ value: String?,
                            font: UIFont,
                            preHeight: CGFloat = 20,
                            maxWidth: CGFloat? = nil) -> UILabel {
        var labelWidth: CGFloat = 0
        var labelHei: CGFloat = preHeight
        if let value {
            let width = value.width(font: font)
            if let maxWidth {
                if width > maxWidth {
                    labelWidth = maxWidth
                    labelHei = value.height(font: font, width: maxWidth)
                } else {
                    labelWidth = width
                }
            } else {
                labelWidth = width
            }
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: labelHei))
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .randomColor
//        label.numberOfLines = 0
        label.font = font
        label.textColor = .white
        label.text = value
        return label
    }
    
    // 竖直线
    private func vLine() -> UIView {
        let line = UIView(frame: CGRect(x: 0, y: 0, width: 0.5, height: 52))
        line.backgroundColor = .white
        return line
    }
    
    // icon
    private func iconImageView(icon: UIImage?) -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        imageView.image = icon
        return imageView
    }
    
}

class CRSCastScreenAlertManager {
    
    static let shared = CRSCastScreenAlertManager()
    
    // 最多同时显示的视图数量
    let showMaxAlertCount: Int = 3
    var alerts: [UIView] = []
    
    func show(_ alert: UIView) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            let currentAlerts = self.alerts.map { $0 }
            
            alert.centerX = kScreenWidth / 2
            alert.top = -alert.height
            alert.alpha = 0
            UIDevice.keyWindow?.addSubview(alert)
            
            UIView.animate(withDuration: 0.2) {
                alert.alpha = 1
                alert.top = kStatusBarHeight
            }
            
            var lastBottom = alert.bottom
            for (index, ale) in currentAlerts.reversed().enumerated() {
                UIView.animate(withDuration: 0.2) {
                    ale.top = lastBottom + 5
                }
                lastBottom = ale.bottom
                
                if index >= showMaxAlertCount - 1 {
                    self.hide(ale)
                }
            }
            
            self.alerts.append(alert)
            delay(5) { [weak self] in
                self?.hide(alert)
            }
        }
    }
    
    func hide(_ alert: UIView) {
        guard alerts.contains(alert) else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                alert.alpha = 0.1
                alert.transform = CGAffineTransformMakeScale(0.1, 0.1)
            } completion: { [weak self] _ in
                self?.alerts.remove(element: alert)
                alert.removeFromSuperview()
            }
        }
    }
    
    func hideAll() {
        for alert in alerts {
            hide(alert)
        }
    }
    
}
