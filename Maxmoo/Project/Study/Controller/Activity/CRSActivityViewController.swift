//
//  CRSActivityViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2025/1/22.
//

import UIKit
import ActivityKit

@available(iOS 16.2, *)
class CRSActivityViewController: UIViewController {

    var activity: Activity<CRSSportActivityAttributes>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createButton(title: "启动灵动岛", y: view.center.y - 100, selector: #selector(start))
        createButton(title: "更新灵动岛", y: view.center.y - 50, selector: #selector(update))
        createButton(title: "关闭灵动岛", y: view.center.y, selector: #selector(end))
    }

    
    private func createButton(title: String, y: CGFloat, selector: Selector) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.sizeToFit()
        view.addSubview(button)
        button.center.x = view.center.x
        button.frame.origin.y = y
        button.addTarget(self, action: selector, for: .touchUpInside)
    }

    @objc
    private func start() {
        // 创建灵动岛
        let attributes = CRSSportActivityAttributes(name: "iOS 新知")
        let state = CRSSportActivityAttributes.ContentState(emoji: " ")
        let content = ActivityContent<CRSSportActivityAttributes.ContentState>(state: state, staleDate: nil)
        do {
            self.activity = try Activity<CRSSportActivityAttributes>.request(attributes: attributes, content: content)
        } catch let error {
            print("出错了：\(error.localizedDescription)")
        }
    }
    
    @objc
    private func update() {
        let state = CRSSportActivityAttributes.ContentState(emoji: " ")
        Task {
            await activity?.update(using: state)
        }
    }
    
    @objc
    private func end() {
        Task {
            await activity?.end()
        }
    }
}

struct CRSSportActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}
