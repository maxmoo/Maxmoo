//
//  CRSDragMoveButton.swift
//  Maxmoo
//
//  Created by 程超 on 2024/7/1.
//

import UIKit

enum CRSDragAssistiveType {
    case none       // 不移动
    case left       // 靠左
    case right      // 靠右
    case horizon    // 靠左或靠右
    case top        // 靠上
    case bottom     // 靠下
    case vert       // 靠上或靠下
}

class CRSDragMoveButton: UIButton {
    
    var action:((CRSDragMoveButton)->Void)? = nil
    var assistiveType: CRSDragAssistiveType = .horizon
    
    // 距离四周的边距
    var contentInset: UIEdgeInsets = UIEdgeInsets(top: 100, left: 16, bottom: 100, right: 16)
    
    private var autoAnimationDuration: TimeInterval = 0.5
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        initViews();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initViews() {
        let longPress = UIPanGestureRecognizer(target: self, action: #selector(CRSDragMoveButton.longPress(_:)))
        longPress.delegate = self as? UIGestureRecognizerDelegate
        addGestureRecognizer(longPress)
        
        addTarget(self, action: #selector(CRSDragMoveButton.buttonTapped(_:)), for: .touchUpInside)
    }
        
    @objc func buttonTapped(_ sender: UIControl) {
        if let unwrappedAction = self.action {
            unwrappedAction(self)
        }
    }
    
    var buttonOrigin : CGPoint = CGPoint(x: 0, y: 0)
    @objc func longPress(_ pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            buttonOrigin = pan.location(in: self)
            
        }else {
            let location = pan.location(in: self.superview) // get pan location
            self.frame.origin = CGPoint(x: location.x - buttonOrigin.x, y: location.y - buttonOrigin.y)
            
            if(pan.state == .ended){
                self.updateButtonFrame()
            }
        }
    }
    
    /// 更新按钮的位置
    private func updateButtonFrame(){

        let btnY: CGFloat = self.frame.origin.y
        let btnX: CGFloat = self.frame.origin.x
        let screenW = self.superview?.bounds.size.width ?? 100
        let screenH = self.superview?.bounds.size.height ?? 100
        let floatBtnW = self.bounds.size.width
        let floatBtnH = self.bounds.size.height
        let maxY: CGFloat = screenH - contentInset.bottom - floatBtnH
        let maxX: CGFloat = screenW - contentInset.right - floatBtnW
        
        // 最终显示的位置
        var finalFrame: CGRect = .zero
        switch assistiveType {
        case .none:
            break;
        case .left:
            finalFrame = CGRect(x: contentInset.left,
                                y: min(max(btnY, contentInset.top), maxY),
                                width: floatBtnW,
                                height: floatBtnH)
        case .right:
            finalFrame = CGRect(x: screenW - floatBtnW - contentInset.right,
                                y: min(max(btnY, contentInset.top), maxY),
                                width: floatBtnW,
                                height: floatBtnH)
        case .horizon:
            if (self.center.x >= screenW/2) {
                finalFrame = CGRect(x: screenW - floatBtnW - contentInset.right,
                                    y: min(max(btnY, contentInset.top), maxY),
                                    width: floatBtnW,
                                    height: floatBtnH)
            }else{
                finalFrame = CGRect(x: contentInset.left,
                                    y: min(max(btnY, contentInset.top), maxY),
                                    width: floatBtnW,
                                    height: floatBtnH)
            }
        case .top:
            finalFrame = CGRect(x: min(max(btnX, contentInset.left), maxX),
                                y: max(btnY, contentInset.top),
                                width: floatBtnW,
                                height: floatBtnH)
        case .bottom:
            finalFrame = CGRect(x: min(max(btnX, contentInset.left), maxX),
                                y: screenH - contentInset.bottom,
                                width: floatBtnW,
                                height: floatBtnH)
        case .vert:
            if self.center.y >= screenH / 2 {
                finalFrame = CGRect(x: min(max(btnX, contentInset.left), maxX),
                                    y: screenH - contentInset.bottom,
                                    width: floatBtnW,
                                    height: floatBtnH)
            } else {
                finalFrame = CGRect(x: min(max(btnX, contentInset.left), maxX),
                                    y: contentInset.top,
                                    width: floatBtnW,
                                    height: floatBtnH)
            }
        }
        
        UIView.animate(withDuration: autoAnimationDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 5) {
            [weak self] in
            self?.frame = finalFrame
        }
    }
    
}


