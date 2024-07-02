//
//  CRSCastScreenUserTipView.swift
//  Maxmoo
//
//  Created by 程超 on 2024/5/22.
//

import UIKit

protocol CRSMapCustomAnnPositionDelegate: NSObjectProtocol {
    var yOffset: CGFloat { get }
    var xOffset: CGFloat { get }
}

enum CRSCSMapUserTipStyle: Int {
    case normal             // 正常
    case select             // 选中
}

enum CRSCSMapUserTipStatus: Int {
    case normal             //正常
    case pause              //暂停
    case unusual            //异常
    case sos                //sos
    
    var themeColor: UIColor {
        switch self {
        case .normal:
            return .blue
        case .pause:
            return .red
        case .unusual:
            return .darkGray
        case .sos:
            return .red
        }
    }
}

struct CRSCSMapUserTipValueInfo {
    var iconImage: UIImage?
    var value: Double?
    var unit: String?
}

struct CRSCSMapUserTipInfo {
    var headImage: UIImage?
    var name: String
    var isFocus: Bool
    var valueInfos: [CRSCSMapUserTipValueInfo]
}

protocol CRSCSMapUserTipDelegate: NSObjectProtocol {
    func userTipFocusClick(tipView: CRSCastScreenUserTipView)
    func userTipHeadClick(tipView: CRSCastScreenUserTipView)
}

class CRSCastScreenUserTipView: UIView, CRSMapCustomAnnPositionDelegate {

    var yOffset: CGFloat {
        return self.height / 2 - headImageView.centerY
    }
    
    var xOffset: CGFloat {
        return (self.width / 2) - headImageWidth / 2
    }
    
    weak var delegate: CRSCSMapUserTipDelegate?
    
    // 当前样式
    public var style: CRSCSMapUserTipStyle = .normal {
        didSet {
            refreshUI()
        }
    }
    
    // 当前状态
    public var status: CRSCSMapUserTipStatus = .normal {
        didSet {
            refreshHeadImage()
            refreshColor()
        }
    }
    
    public var info: CRSCSMapUserTipInfo? {
        didSet {
            refreshUI()
        }
    }
    
    // headImage
    public var headImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    // 头像底部制造阴影的视图
    private var headBackView: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    // content
    var infoContentView: UIView = {
        let content = UIView(frame: .zero)
        return content
    }()
    
    // 序号
    var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    // 关注
    var focusLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        return label
    }()
    
    // left info icon
    var leftIconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    // left info label
    var leftValueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    // left unit label
    var leftUnitLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    // right info icon
    var rightIconView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    // right info label
    var rightValueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    // right unit label
    var rightUnitLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    // 三角layer
    private var triangleLayer: CAShapeLayer?
    private func createTriangleLayer(color: UIColor, width: CGFloat = 5, height: CGFloat = 10) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.zPosition = 1
        layer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        layer.borderWidth = 0
        layer.strokeColor = color.cgColor
        layer.fillColor = color.cgColor
        layer.lineCap = .square
        layer.lineJoin = .round
        layer.lineWidth = 0
        
        // line
        let trianglePath = UIBezierPath.init()
        trianglePath.move(to: CGPoint(x: width, y: 0))
        trianglePath.addLine(to: CGPoint(x: width, y: height))
        trianglePath.addLine(to: CGPoint(x: 0, y: height/2))
        trianglePath.addLine(to: CGPoint(x: width, y: 0))
        layer.path = trianglePath.cgPath

        return layer
    }
    
    var headImageWidth: CGFloat = 30
    let headImageBottom: CGFloat = 50
    
    init(info: CRSCSMapUserTipInfo, style: CRSCSMapUserTipStyle) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.info = info
        self.style = style
        createSubviews()
        refreshUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSubviews() {
        addSubview(headBackView)
        addSubview(headImageView)
        addSubview(infoContentView)
        infoContentView.addSubview(nameLabel)
        infoContentView.addSubview(focusLabel)
        infoContentView.addSubview(leftIconView)
        infoContentView.addSubview(leftValueLabel)
        infoContentView.addSubview(leftUnitLabel)
        infoContentView.addSubview(rightIconView)
        infoContentView.addSubview(rightValueLabel)
        infoContentView.addSubview(rightUnitLabel)
        
        // 添加手势
        focusLabel.addTapGesture { [weak self] in
            guard let self else { return }
            if let delegate {
                delegate.userTipFocusClick(tipView: self)
            }
        }
        
        headImageView.addTapGesture { [weak self] in
            guard let self else { return }
            if let delegate {
                delegate.userTipHeadClick(tipView: self)
            }
        }
    }
    
    private func refreshUI() {
        guard let info else { return }
        
        // info
        if let leftValueInfo = info.valueInfos.first {
            leftIconView.image = leftValueInfo.iconImage
            leftValueLabel.text = "\(leftValueInfo.value ?? 0)"
            leftUnitLabel.text = "\(leftValueInfo.unit ?? "")"
        }
        if let rightValueInfo = info.valueInfos.last {
            rightIconView.image = rightValueInfo.iconImage
            rightValueLabel.text = "\(rightValueInfo.value ?? 0)"
            rightUnitLabel.text = "\(rightValueInfo.unit ?? "")"
        }

        if info.isFocus {
            if style == .select {
                nameLabel.text = info.name + ""
            } else {
                nameLabel.text = info.name + " | 已关注"
            }
            focusLabel.text = "已关注"
        } else {
            nameLabel.text = info.name
            focusLabel.text = "+关注"
        }
        
        // 关注两侧边距
        let focusContentGap: CGFloat = 6
        // 左右两项中间的间距
        let itemCenterGap: CGFloat = 8
        // icon的宽度
        let iconWidth: CGFloat = 18
        // icon和文字之间的间距
        let iconTextGap: CGFloat = 2
        // 整个显示区域的高度
        var contentHeight: CGFloat = 20
        // 整个显示区域的宽度（后面计算后会调整）
        var contentWidth: CGFloat = 0
        // 整个显示区域距离上面的间距
        var contentOutside: UIEdgeInsets = UIEdgeInsets.zero
        // 显示区域中内容距离边界的间隙
        var contentInside: UIEdgeInsets = UIEdgeInsets.zero
        
        // calculate
        switch style {
        case .normal:
            headImageWidth = 32
            contentOutside = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 0)
            contentInside = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            contentHeight = 24
        case .select:
            // calculate
            headImageWidth = 40
            contentOutside = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            contentInside = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            contentHeight = 70
        }
        
        switch style {
        case .normal:
            let nameWidth = nameLabel.text?.width(font: nameLabel.font) ?? 0
            contentWidth = nameWidth + contentInside.left + contentInside.right
            // MARK: - frame
            // head
            headImageView.frame = CGRect(x: 0, y: 0, width: headImageWidth, height: headImageWidth)
            headImageView.bottom = headImageBottom
            headBackView.frame = headImageView.frame
            
            // content
            infoContentView.frame = CGRect(x: headImageView.right + contentOutside.left, y: headImageView.top + 4, width: contentWidth, height: contentHeight)
            nameLabel.frame = CGRect(x: contentInside.left, y: 0, width: nameWidth, height: contentHeight)
            nameLabel.centerY = contentHeight / 2
        case .select:
            let nameWidth = nameLabel.text?.width(font: nameLabel.font) ?? 0
            let focusWidth = focusLabel.text?.width(font: focusLabel.font) ?? 0
            let topWidth = nameWidth + focusWidth + contentInside.left + contentInside.right + itemCenterGap + focusContentGap * 2
            let leftValueWidth = leftValueLabel.text?.width(font: leftValueLabel.font) ?? 0
            let leftUnitWidth = leftUnitLabel.text?.width(font: leftUnitLabel.font) ?? 0
            let rightValueWidth = rightValueLabel.text?.width(font: rightValueLabel.font) ?? 0
            let rightUnitWidth = rightUnitLabel.text?.width(font: rightUnitLabel.font) ?? 0

            let bottomWidth = leftValueWidth + rightValueWidth + contentInside.left + contentInside.right + itemCenterGap + iconWidth * 2 + iconTextGap * 2 + leftUnitWidth + rightUnitWidth
            contentWidth = max(topWidth, bottomWidth)
            // MARK: - frame
            // head
            headImageView.frame = CGRect(x: -4, y: 0, width: headImageWidth, height: headImageWidth)
            headImageView.bottom = headImageBottom
            headBackView.frame = headImageView.frame

            // content
            infoContentView.frame = CGRect(x: headImageView.right + contentOutside.left, y: headImageView.top, width: contentWidth, height: contentHeight)
            nameLabel.frame = CGRect(x: contentInside.left, y: contentInside.top, width: nameWidth, height: 20)
            focusLabel.frame = CGRect(x: 0, y: 0, width: focusWidth + focusContentGap * 2, height: 24)
            focusLabel.right = contentWidth - contentInside.right
            focusLabel.centerY = nameLabel.centerY
            
            leftIconView.frame = CGRect(x: contentInside.left, y: 0, width: iconWidth, height: iconWidth)
            leftIconView.bottom = contentHeight - contentInside.bottom
            leftValueLabel.frame = CGRect(x: leftIconView.right + iconTextGap, y: 0, width: leftValueWidth, height: 30)
            leftValueLabel.centerY = leftIconView.centerY
            leftUnitLabel.frame = CGRect(x: leftValueLabel.right, y: 0, width: leftUnitWidth, height: 20)
            leftUnitLabel.centerY = leftIconView.centerY + 2
            
            rightUnitLabel.frame = CGRect(x: 0, y: 0, width: rightUnitWidth, height: leftUnitLabel.height)
            rightUnitLabel.centerY = leftUnitLabel.centerY
            rightUnitLabel.right = contentWidth - contentInside.right
            rightValueLabel.frame = CGRect(x: 0, y: 0, width: rightValueWidth, height: leftValueLabel.height)
            rightValueLabel.centerY = leftValueLabel.centerY
            rightValueLabel.right = rightUnitLabel.left
            rightIconView.frame = CGRect(x: 0, y: 0, width: leftIconView.width, height: leftIconView.height)
            rightIconView.right = rightValueLabel.left - iconTextGap
            rightIconView.centerY = leftIconView.centerY
        }
        
        // 显示与否
        switch style {
        case .normal:
            focusLabel.isHidden = true
            leftIconView.isHidden = true
            leftValueLabel.isHidden = true
            leftUnitLabel.isHidden = true
            rightIconView.isHidden = true
            rightValueLabel.isHidden = true
            rightUnitLabel.isHidden = true
        case .select:
            focusLabel.isHidden = false
            leftIconView.isHidden = false
            leftValueLabel.isHidden = false
            leftUnitLabel.isHidden = false
            rightIconView.isHidden = false
            rightValueLabel.isHidden = false
            rightUnitLabel.isHidden = false
        }
        
        self.width = infoContentView.right
        self.height = max(headImageView.bottom, infoContentView.bottom)
        
        if let triangleLayer {
            triangleLayer.removeFromSuperlayer()
        }
        
        var triColor: UIColor = .white
        if info.isFocus {
            triColor = status.themeColor
        }
        
        var topOffset: CGFloat = 7
        var triWidth: CGFloat = 4
        var triHeight: CGFloat = 5
        if style == .select {
            topOffset = 15
            triWidth = 5
            triHeight = 10
        }
        
        let triLayer = createTriangleLayer(color: triColor, width: triWidth, height: triHeight)
        triLayer.right = infoContentView.left
        triLayer.top = infoContentView.top + topOffset
        layer.addSublayer(triLayer)
        triangleLayer = triLayer
        
        refreshColor()
        refreshHeadImage()
    }
 
    private func refreshHeadImage() {
        guard let info else { return }
        
        switch status {
        case .sos:
            headImageView.image = UIImage(named: "delete")
        default:
            headImageView.image = info.headImage
        }
    }
    
    private func refreshColor() {
        guard let info else { return }
        
        // 圆角
        focusLabel.layer.cornerRadius = 4
        focusLabel.layer.masksToBounds = true
        infoContentView.layer.cornerRadius = 6
        infoContentView.shadowOffset(CGSize(width: 0, height: 0), radius: 3, color: status.themeColor, opacity: 0.7)
        
        headImageView.layer.cornerRadius = headImageView.height / 2
//        headImageView.layer.masksToBounds = true
        headImageView.layer.borderWidth = 3
        headImageView.layer.borderColor = status.themeColor.cgColor
        
        headBackView.backgroundColor = .clear
        headBackView.layer.cornerRadius = headBackView.height / 2
        headBackView.layer.shadowColor = UIColor.black.cgColor
        headBackView.layer.shadowOffset = .zero
        headBackView.layer.shadowOpacity = 1
        headBackView.layer.shadowRadius = 2.0
        headBackView.clipsToBounds = false

        // color
        if info.isFocus {
            infoContentView.backgroundColor = status.themeColor
            nameLabel.textColor = .white
            focusLabel.backgroundColor = UIColor.init(white: 0.7, alpha: 0.3)
            focusLabel.textColor = .white
            leftValueLabel.textColor = .white
            leftUnitLabel.textColor = .white
            rightValueLabel.textColor = .white
            rightUnitLabel.textColor = .white
        } else {
            infoContentView.backgroundColor = .white
            nameLabel.textColor = .black
            focusLabel.backgroundColor = .blue
            focusLabel.textColor = .white
            leftValueLabel.textColor = .black
            leftUnitLabel.textColor = .black
            rightValueLabel.textColor = .black
            rightUnitLabel.textColor = .black
        }
    }
}
