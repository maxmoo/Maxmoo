//
//  ExploreFileManager.swift
//  MapboxDemo
//
//  Created by 程超 on 2022/9/12.
//

import UIKit

class ExploreFileManager: NSObject {
    
    static let documents = NSHomeDirectory() + "/Documents"
    
    //文件路径是否存在
    class func isFileExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    //文件路径是否存在，若不存在创建
    @discardableResult
    class func isFileExistsAndCreate(at path: String) -> Bool {
        if isFileExists(at: path) {
            return true
        } else {
            return createFile(at: path)
        }
    }
    
    //创建文件
    @discardableResult
    class func createFile(at path: String) -> Bool {
        return FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
    }
    
    //创建文件夹
    @discardableResult
    class func createDirectory(at path: String) -> Bool {
        print("createDir: \(path)")
        if isFileExists(at: path) {
            return true
        }
        
        do {
            try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    //拷贝文件
    @discardableResult
    class func copyFile(at path: String, toPath: String) -> Bool {
        do {
            try FileManager.default.copyItem(at:URL.init(fileURLWithPath: path) , to: URL.init(fileURLWithPath: toPath))
        } catch let error {
            print("copy file error: \(error)")
            return false
        }
        return true
    }
    
    //重命名文件
    @discardableResult
    static func renameFile(_ path: String, fileName: String, newName: String) -> Bool {
        let filePath = path + "/\(fileName)"
        let newPath = path + "/\(newName)"
        return moveFile(at: filePath, toPath: newPath)
    }
    
    //移动文件
    @discardableResult
    class func moveFile(at path: String, toPath: String) -> Bool {
        print("path: \(path) move to: \(toPath)")
        do {
            try FileManager.default.moveItem(atPath: path, toPath: toPath)
        } catch let error {
            print("move file error: \(error)")
            return false
        }
        return true
    }
    
    //删除文件
    @discardableResult
    class func removeFile(at path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch let error {
            print("remove file error:\(error)")
            return false
        }
        print("remove file success at path:\(path)")
        return true
    }
    
    //删除文件夹下所有文件
    @discardableResult
    class func removeAllFile(at path: String) -> Bool {
        let manager = FileManager.default
        let files = fileList(path)
        for file in files {
            let filePath = path + "/\(file)"
            removeFile(at: filePath)
        }
        return true
    }
    
    //文件夹下所有文件
    class func contentsOfDirectory(at path: String) -> [String] {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: path)
        } catch let error {
            print("contens error:\(error)")
            return []
        }
    }
    
    //获取单个文件的大小
    class func getFileSize(atPath filePath : String) -> CGFloat {
        guard isFileExists(at: filePath) else {
            return 0
        }
        
        guard let dict = try? FileManager.default.attributesOfItem(atPath: filePath) as NSDictionary else {
            return 0
        }
        
        return CGFloat(dict.fileSize())
    }
    
    // MARK: - 获取文件列表
    class func fileList(_ path: String, isFullPath: Bool = false) -> [String] {
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
