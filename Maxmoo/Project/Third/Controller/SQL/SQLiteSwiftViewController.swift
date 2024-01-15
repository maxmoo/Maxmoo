//
//  SQLiteSwiftViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/1/11.
//

/*
 # 可视化db
 pod 'DatabaseVisual'

 #if DEBUG
         let path = ExploreFileManager.documents + "/db" + "/\(exploreUserId())"
         let vc = DatabaseListViewController(dbPaths: DatabaseFactory.queryIfHadDB(fromDirectory: path))
         let root = UINavigationController(rootViewController: vc)
         self.present(root, animated: true)
#endif
 */

import UIKit
import SQLite
import DatabaseVisual

class SQLiteSwiftViewController: UIViewController {

    lazy var tapButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 60, height: 60))
        button.backgroundColor = .randomColor
        button.addTarget(self, action: #selector(action), for: .touchUpInside)
        return button
    }()
    
    lazy var dbListVC = {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let vc = DatabaseListViewController(dbPaths: DatabaseFactory.queryIfHadDB(fromDirectory: path))
        vc.delegate = self
        return vc
    }()
    
    @objc
    func action() {
        let root = UINavigationController(rootViewController: dbListVC)
        self.present(root, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tapButton)
        
        //获取doc路径
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        //如果不存在的话，创建一个名为db.sqlite3的数据库，并且连接数据库
        let db = try? Connection("\(path)/db.sqlite3")
        guard let db else { return }
        
        //并发错误
        db.busyTimeout = 5
        db.busyHandler({ tries in
            if tries >= 3 {
                return false
            }
            return true
        })
        
        // 申明
        let id = Expression<Int64>("id")
        let email = Expression<String?>("email")
        let balance = Expression<Double?>("balance")
        let name = Expression<String?>("name")
        
        // 创建表
        let users = Table("users")
//        _ = try? db.run(users.create(ifNotExists: true) { t in     // CREATE TABLE "users" (
//            t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
//            t.column(email, unique: true)  //     "email" TEXT UNIQUE NOT NULL,
//            t.column(balance)
//            t.column(name)                 //     "name" TEXT
//        })
        
//        _ = try? db.run(users.insert(email <- "alice@mac.com", name <- "Alice"))
        // INSERT INTO "users" ("email", "name") VALUES ('alice@mac.com', 'Alice')

        _ = try? db.run(users.insert(or: .replace, email <- "aliceaaaaa@mac.com", name <- "Aliceaa B."))
        // INSERT OR REPLACE INTO "users" ("email", "name") VALUES ('alice@mac.com', 'Alice B.')

//        do {
//            let rowid = try db.run(users.insert(email <- "alice@mac.com"))
//            print("inserted id: \(rowid)")
//        } catch {
//            print("insertion failed: \(error)")
//        }
//
//        try? db.run(users.update(balance-=10))
    }

}


extension SQLiteSwiftViewController: DatabaseListViewControllerDelegate {
    
    func databaseListViewControllerDidFinish() {
        dbListVC.dismiss(animated: true)
    }
}
