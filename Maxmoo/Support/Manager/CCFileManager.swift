//
//  CCFileManager.swift
//  Maxmoo
//
//  Created by 程超 on 2024/4/18.
//

import UIKit

class CCFileManager: NSObject {
    
    @objc
    static let shared = CCFileManager()
    
    var home: String {
        return NSHomeDirectory()
    }
    
    @objc
    var document: String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first ?? home
    }
    
    var library: String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first ?? home
    }
    
    var caches: String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last ?? home
    }
    
    var temp: String {
        return NSTemporaryDirectory()
    }
    
}


extension CCFileManager {
    
    // 文件是否存在
    func isFileExists(_ filePath: String) -> Bool {
        return FileManager.default.fileExists(atPath: filePath)
    }
    
    // create file
    @objc
    @discardableResult
    func createFile(urlString: String, fileName: String? = nil) -> Bool {
        var filePath = URL(fileURLWithPath: urlString)
        
        if let fileName {
            let folderExist = FileManager.default.fileExists(atPath: filePath.path)
            if !folderExist {
                createFolder(urlString: filePath.path)
            }
            filePath = filePath.appendingPathComponent(fileName)
        }
        let exist = FileManager.default.fileExists(atPath: filePath.path)
        if !exist {
            return FileManager.default.createFile(atPath: filePath.path, contents: nil, attributes: nil)
        } else {
            return true
        }
    }
    
    // create folder
    @discardableResult
    func createFolder(urlString: String, folderName: String? = nil) -> Bool {
        var folderPath = URL(fileURLWithPath: urlString)

        if let folderName {
            folderPath = folderPath.appendingPathComponent(folderName)
        }
        let exist = FileManager.default.fileExists(atPath: folderPath.path)
        if !exist {
            do {
                try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
                return true
            } catch let error {
                print("[file] \(error)")
                return false
            }
        } else {
            return true
        }
    }
    
    // remove file
    @discardableResult
    func removeFile(_ filePathString: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: filePathString)
            return true
        } catch let error {
            print("[file] \(error)")
            return false
        }
    }
    
    // remove folder
    @discardableResult
    func removeFolder(_ folderPathString: String) -> Bool {
        let exist = FileManager.default.fileExists(atPath: folderPathString)
        if exist {
            do {
                try FileManager.default.removeItem(atPath: folderPathString)
                return true
            } catch let error {
                print("[file] \(error)")
                return false
            }
        } else {
            return true
        }
    }
    
    // 删除文件夹下所有文件
    @discardableResult
    func removeAllFile(at path: String) -> Bool {
        let files = fileList(path)
        for file in files {
            let filePath = path + "/\(file)"
            removeFile(filePath)
        }
        return true
    }
 
    // 拷贝文件
    @discardableResult
    func copyFile(at path: String, toPath: String) -> Bool {
        do {
            try FileManager.default.copyItem(at:URL.init(fileURLWithPath: path) , to: URL.init(fileURLWithPath: toPath))
        } catch let error {
            print("[file] \(error)")
            return false
        }
        return true
    }
    
    // 移动文件
    @discardableResult
    func moveFile(at path: String, toPath: String) -> Bool {
        do {
            try FileManager.default.moveItem(atPath: path, toPath: toPath)
        } catch let error {
            print("[file] \(error)")
            return false
        }
        return true
    }
    
    // 重命名文件
    @discardableResult
    func renameFile(_ path: String, fileName: String, newName: String) -> Bool {
        let filePath = path + "/\(fileName)"
        let newPath = path + "/\(newName)"
        return moveFile(at: filePath, toPath: newPath)
    }
    
    // 查找文件，返回存在的全路径
    func searchFile(_ path: String, name: String, isDeepSearch: Bool = true) -> [String] {
        if isDeepSearch {
            let exist = FileManager.default.fileExists(atPath: path)
            if (exist) {
                let fileManager = FileManager.default
                var foundPaths = [String]()
                // 枚举器提供了一个递归查找的选项
                let enumerator = fileManager.enumerator(atPath: path)
                while let element = enumerator?.nextObject() {
                    // 检查文件名是否符合目标
                    if (element as AnyObject).lastPathComponent == name {
                        // 将完整路径添加到结果数组
                        foundPaths.append(path + "/\(element)")
                    }
                }
                return foundPaths
            } else {
                return []
            }
        } else {
            let fileArray = contentsOfDirectory(at: path)
            return fileArray.filter { $0 == name }.map { path + "/\($0)" }
        }
    }
    
    // 文件夹下所有文件
    func contentsOfDirectory(at path: String) -> [String] {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: path)
        } catch let error {
            print("[file] \(error)")
            return []
        }
    }
    
    // 获取单个文件的大小
    func fileSize(atPath filePath : String) -> CGFloat {
        guard isFileExists(filePath) else {
            return 0
        }
        
        guard let dict = try? FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary else {
            return 0
        }
        
        return CGFloat(dict.fileSize())
    }
    
    // 文件列表
    func fileList(_ path: String, isFullPath: Bool = false) -> [String] {
        let fileManager = FileManager.default
        if isFullPath {
            let contentsOfDirectory = try? fileManager.contentsOfDirectory(at: URL(string: path)!,
                                                                        includingPropertiesForKeys: nil,
                                                                        options: .skipsHiddenFiles)
            if let contentsOfDirectory = contentsOfDirectory {
                return contentsOfDirectory.map{ $0.absoluteString }
            } else {
                return []
            }
        } else {
            let fileList = try? fileManager.contentsOfDirectory(atPath: path)
            return fileList ?? []
        }
    }
}
