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

public extension Array {
    // 移除
    mutating func crs_remove(_ object: AnyObject) {
        if let index = index(where: { $0 as AnyObject === object }) {
            remove(at: index)
        }
    }
}

public extension Array {
    mutating func move(at index: Index, to newIndex: Index) {
        insert(remove(at: index), at: newIndex)
    }
}

public extension Array where Element: Equatable {
    mutating func remove(element: Element) {
        if let value = firstIndex(of: element) {
            remove(at: value)
        }
    }

    mutating func insertOrReplace(_ element: Element, position: Int) {
        remove(element: element)
        insert(element, at: position)
    }

    func contains<T>(_ object: T) -> Bool where T: Equatable {
        !filter { $0 as? T == object }.isEmpty
    }

    mutating func move(_ item: Element, to newIndex: Index) {
        if let index = index(of: item) {
            move(at: index, to: newIndex)
        }
    }

    mutating func bringToFront(item: Element) {
        move(item, to: 0)
    }

    mutating func sendToBack(item: Element) {
        move(item, to: endIndex - 1)
    }
}
