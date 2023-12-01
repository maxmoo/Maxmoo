//
//  Array+CC.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit

extension Array {
    
    func JSONString(encoding: String.Encoding) -> String? {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return nil
        }
        
        let data = try? JSONSerialization.data(withJSONObject: self, options: [])
        if let data = data {
            let JSONString = String(data: data, encoding: encoding)
            return JSONString
        } else {
            return nil
        }
    }
}


extension Array {
    
    @discardableResult
    mutating func removeStart(_ k: Int) -> [Element] {
        guard k < self.count else {
            let array = self
            self.removeAll()
            return array
        }
        
        var array: [Element] = []
        for _ in 0..<k {
            array.append(self.removeFirst())
        }
        return array
    }
    
    @discardableResult
    mutating func removeStart() -> Element? {
        guard self.count > 0 else {return nil}
        return self.removeFirst()
    }
    
    @discardableResult
    mutating func removeEnd(_ k: Int) -> [Element] {
        guard k < self.count else {
            let array = self
            self.removeAll()
            return array
        }
        
        var array: [Element] = []
        for _ in 0..<k {
            array.append(self.removeLast())
        }
        return array
    }
    
    @discardableResult
    mutating func removeEnd() -> Element? {
        guard self.count > 0 else {return nil}
        return self.removeLast()
    }
    
    // 返回所有的索引
    public func allIndexs<T>(trans: (Int) -> T) -> [T] {
        var ind: Int = -1
        return self.map { _ in
            ind += 1
            return trans(ind)
        }
    }
}
