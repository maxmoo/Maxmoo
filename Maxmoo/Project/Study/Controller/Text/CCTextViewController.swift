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
        
        let textNames: [String] = ["abc",
                                   "tom hanks",
                                   "c",
                                   "西瓜",
                                   "a 西瓜", 
                                   "😄",
                                   "泰麋",
                                   "a啥给哦给",
                                   "哈哈哈 abc",
                                   "abc bbbb xia da", "jack  cheng"]
        for textName in textNames {
            print("text: \(shortName(ori: textName))")
        }
    }
    
    
    func shortName(ori: String) -> String {
        
        let subItems = ori.components(separatedBy: .whitespaces).filter{ !$0.isEmpty }
        
        switch subItems.count {
        case 0:
            return ori
        case 1:
            let first = subItems[0]
            if first.isAllEnglishLetters {
                return headChars(from: first, count: 2)
            } else {
                return headChars(from: ori, count: 1)
            }
        default:
            let first = subItems[0]
            let second = subItems[1]
            if first.isAllEnglishLetters, second.isAllEnglishLetters {
                return headChars(from: first, count: 1) + headChars(from: second, count: 1)
            } else {
                if first.isAllEnglishLetters {
                    return headChars(from: first, count: 2)
                } else {
                    return headChars(from: ori, count: 1)
                }
            }
        }
        
        func headChars(from str: String, count: Int) -> String {
            if str.count <= count {
                return str
            }

            let index = str.index(str.startIndex, offsetBy: count)
            return String(str[..<index])
        }
    }
}

extension String {
    var isAllEnglishLetters: Bool {
        return self.range(of: "^[A-Za-z]+$", options: .regularExpression) != nil
    }
}
