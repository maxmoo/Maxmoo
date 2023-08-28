//
//  Double+CC.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit

extension Double {
    /// 准确的小数尾截取 - 没有进位(直接使用%.3f会四舍五入)
    func decimalString(_ base: Self = 1) -> String {
        let stepone = self.decimal(base)
        if stepone.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", stepone)
        }else{
            return String(format: "%.\(Int(base))f", stepone)
        }
    }
    
    func decimal(_ base: Self = 1) -> Double {
        let tempCount: Self = pow(10, base)
        let temp = self*tempCount
        
        let target = Self(Int(temp))
        let stepone = target/tempCount
        return stepone
    }
}
