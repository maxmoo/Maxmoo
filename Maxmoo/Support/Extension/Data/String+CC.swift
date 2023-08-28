//
//  String+CC.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit

extension String {
    
    // 转class
    func toClass() -> AnyClass? {
        guard let bundleName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            return nil
        }
        var anyClass: AnyClass? = NSClassFromString(bundleName + "." + self)
        if (anyClass == nil) {
            anyClass = NSClassFromString(self)
        }
        return anyClass
    }
    
    /// 过滤Emoji表情
    public var disableEmojis: String {
        let result = unicodeScalars.filter{ !$0.properties.isEmojiPresentation }
        return String(result)
    }
    
    /// 过滤特殊字符
    public var disableSpecialCharacters: String {
        let pattern: String = "[^a-zA-Z0-9\u{4e00}-\u{9fa5}]"
        let express = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return express.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: "")
    }
    
    public func disableSpecialCharacters(except: String) -> String {
        let pattern: String = "[^a-zA-Z0-9\u{4e00}-\u{9fa5}\(except)]"
        let express = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        return express.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: "")
    }
    
    /// 截取字符串
    public func headSub(_ index: Int) -> String {
        if self.count > index + 1 {
            let endIndex = self.index(self.startIndex, offsetBy: index - 1)
            return String(self[self.startIndex...endIndex])
        } else {
            return self
        }
    }
    
    /// 去掉末尾某一字符
    public func removeSuffix(_ suf: String?) -> String {
        guard let suf = suf else {return self}
        var resultStr = self
        if resultStr.hasSuffix(suf) {
            let sufCount = suf.count
            let range = resultStr.index(resultStr.endIndex, offsetBy: -sufCount)..<resultStr.endIndex
            resultStr.removeSubrange(range)
            return resultStr.removeSuffix(suf)
        } else {
            return resultStr
        }
    }
    
    /// 去掉开头某一字符
    public func removePrefix(_ prefix: String?) -> String {
        guard let prefix = prefix else {return self}
        var resultStr = self
        if resultStr.hasPrefix(prefix) {
            let preCount = prefix.count
            resultStr = String(Array(resultStr)[preCount..<resultStr.count])
            return resultStr.removePrefix(prefix)
        } else {
            return resultStr
        }
    }
    
    public mutating func decodeBase64() -> Data? {
        let b = self.count%4
        switch b {
        case 1:
            self += "==="
        case 2:
            self += "=="
        case 3:
            self += "="
        default:
            break
        }
        
        if let data = Data(base64Encoded: self) {
            return data
        }
        return nil
    }
    
    func json() -> Any? {
        if let jsondata = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: jsondata, options: .allowFragments)
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}


// UI
extension String {
    
    func autoSizeFont(maxWidth: CGFloat,
                      maxFont: UIFont) -> UIFont {
        if maxWidth < 1 {
            return maxFont
        }
        let tempLabel = UILabel(frame: .zero)
        tempLabel.font = maxFont
        tempLabel.text = self
        tempLabel.sizeToFit()
        while tempLabel.width > maxWidth {
            tempLabel.font = tempLabel.font.withSize(tempLabel.font.pointSize - 0.1)
            tempLabel.sizeToFit()
        }
        
        return tempLabel.font
    }
    
    /// 固定宽度获取高度
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 固定宽度
    /// - Returns: 返回自适应高度
    func height(font: UIFont, width: CGFloat) -> CGFloat {
        let size = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).size
        return CGFloat(ceilf(Float(size.height + 1)))
    }
    
    /// 一行显示获取宽度
    /// - Parameter font: 字体
    /// - Returns: 自适应宽度
    func width(font: UIFont) -> CGFloat {
        let size = self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).size
        return CGFloat(ceilf(Float(size.width + 1)))
    }
}
