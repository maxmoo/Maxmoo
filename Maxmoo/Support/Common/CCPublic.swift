//
//  CCPublic.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit
import Foundation

// 是否在debug模式
func isDebug() -> Bool {
#if DEBUG
    return true
#endif
    return false
}

// 在主线程处理事件
func main(_ closure: @escaping () -> ()) {
    // 判断当前线程是否是主线程
    if Thread.current.isMainThread {
        closure()
    } else {
        // 切换到 main 线程，处理
        DispatchQueue.main.async {
            closure()
        }
    }
}

// MARK: - global
// delay
/*
 use:
 let task = delay(5) { print("拨打 110") }
 cancel(task)
 */
typealias DelayTask = (_ cancel : Bool) -> Void
    
@discardableResult
func delay(_ time: TimeInterval, task: @escaping ()->()) ->  DelayTask? {
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }

    var closure: (()->Void)? = task
    var result: DelayTask?
    
    let delayedClosure: DelayTask = {
            cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
            closure = nil
            result = nil
    }

    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }

    return result;
}

func cancel(_ task: DelayTask?) {
    task?(true)
}

// 对象锁
func synchronized(_ lock: AnyObject, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
