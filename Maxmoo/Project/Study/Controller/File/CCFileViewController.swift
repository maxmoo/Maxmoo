//
//  CCFileViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/4/18.
//

import UIKit

class CCFileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        fileDeal()
    }

    func fileDeal() {
        print("------")
        print(CCFileManager.shared.home)
        print(CCFileManager.shared.document)
        print(CCFileManager.shared.library)
        print(CCFileManager.shared.caches)
        print(CCFileManager.shared.temp)
        print("------")
        print(CCFileManager.shared.fileList(CCFileManager.shared.document))
        CCFileManager.shared.createFile(urlString: CCFileManager.shared.document, fileName: "A")
        print(CCFileManager.shared.fileList(CCFileManager.shared.document))
        CCFileManager.shared.createFile(urlString: CCFileManager.shared.document + "/B/b", fileName: "2")
        print(CCFileManager.shared.fileList(CCFileManager.shared.document, isFullPath: true))
        let searchArray = CCFileManager.shared.searchFile(CCFileManager.shared.document, name: "b", isDeepSearch: false)
        print(searchArray)
    }

}
