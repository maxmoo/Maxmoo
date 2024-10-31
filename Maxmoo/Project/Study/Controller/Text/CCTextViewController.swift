//
//  CCTextViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/7/2.
//

import UIKit

class CCTextViewController: UIViewController {

    lazy var textLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 10, y: 100, width: 200, height: 30))
        label.backgroundColor = .yellow
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(textLabel)
        
//        let string = "Ghhfggfghhhggghyyffgyyfdfgyyyyuuuhgffghh adasdadadadasgdsgfgfdhdhdhdhdhgjhjfgsdfsdfs"
//        let subString = CCTextTools.getVisibleString(withWidth: 476.5175388647003, font: textLabel.font, str: string)
//        textLabel.text = subString
        
        let attr = OCStudyViewController().attLeftValue("58", rightValue: "80", unit: "%")
        textLabel.attributedText = attr
    }
    
}
