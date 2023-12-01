//
//  ReadFileViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/10/7.
//

import UIKit

class ReadFileViewController: UIViewController {
    
    struct SubJson: Codable {
        var a1: String
        var a2: String
    }
    
    struct KeyJson: Codable {
        var key1: SubJson
        var key2: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        readJson()
    }

    
    func readJson() {
        // 1. 获取 JSON 文件的URL
        if let jsonURL = Bundle.main.url(forResource: "res_4_0", withExtension: "json") {
            do {
                // 2. 读取 JSON 数据
                let jsonData = try Data(contentsOf: jsonURL)
                
                // 3. 解析 JSON 数据
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    // 在这里使用解析后的 JSON 数据
                    print(json)
                }
            } catch {
                // 处理读取或解析错误
                print(error.localizedDescription)
            }
        }
        
        
        if let jsonURL = Bundle.main.url(forResource: "keyCodeAble", withExtension: "json") {
            
            do {
                // 读取 JSON 数据
                let jsonData = try Data(contentsOf: jsonURL)
                
                // 解码 JSON 数据到 Swift 结构体
                let decoder = JSONDecoder()
                let myData = try decoder.decode(KeyJson.self, from: jsonData)
                
                // 使用解析后的数据
                print("xxx: \(myData)")
            } catch {
                // 处理读取或解析错误
                print(error.localizedDescription)
            }
        }
    }
}
