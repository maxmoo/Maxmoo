//
//  JSONViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/10/12.
//

import UIKit

class JSONViewController: UIViewController {

    let jsonString: String = """
    {"menu": {
        "id": "file",
        "value": "File",
        "localId": 22222222222,
        "popup": {
            "menuitem": [
                    {"value": "New", "onclick": "CreateNewDoc()"},
                    {"value": "Open", "onclick": "OpenDoc()"},
                    {"value": "Close", "onclick": "CloseDoc()"}
                ]
            }
        }
    }
    """

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = jsonString.data(using: .utf8)!
        do {
            let obj = try JSONDecoder().decode(Obj.self, from: data)
            let value = obj.menu.popup.menuItem[0].value
            print(value)
        } catch {
            print("!!!!!")
        }
    }

}


struct Obj: Codable {
    let menu: Menu
    
    struct Menu: Codable {
        let id: String
        let value: String
        let popup: Popup
        var localId: Int32?
        let localTempId: Int
        
        enum CodingKeys: String, CodingKey {
            case id
            case value
            case popup
            case localId = "xxxx"
            case localTempId = "localId"
        }
    }
    
    struct Popup: Codable {
        let menuItem: [MenuItem]
        enum CodingKeys: String, CodingKey {
            case menuItem = "menuitem"
        }
    }
    
    struct MenuItem: Codable {
        let value: String
        let onClick: String
        
        enum CodingKeys: String, CodingKey {
            case value
            case onClick = "onclick"
        }
    }
}
