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
}
