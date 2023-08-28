//
//  Int+CC.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit

extension Int {
    private func pad(string : String, toSize: Int) -> String {
        var padded = string
        for _ in 0..<toSize - string.count {
            padded = "0" + padded
        }
        return padded
    }
    
    // 二进制String
    func binaryStr() -> String {
        return "0b" + self.pad(string: String(self, radix: 2), toSize: 8)
    }
    
    // 16进制String
    func hex6Str() -> String {
        return "0x" + String(self, radix: 16)
    }
}
