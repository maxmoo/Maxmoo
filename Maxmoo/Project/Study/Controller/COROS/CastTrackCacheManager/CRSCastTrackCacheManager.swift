//
//  CRSCastTrackCacheManager.swift
//  Maxmoo
//
//  Created by 程超 on 2024/4/18.
//

import UIKit

class CRSCastTrackCacheManager: NSObject {

    static let shared = CRSCastTrackCacheManager()
    
    private let concurrentQueue = DispatchQueue(label: "CRSCastTrackCahceQueue",
                                                attributes: .concurrent)
    private let fileBaseUrlString: String = CCFileManager.shared.document + "/explore"
    private let maxCacheSize: CGFloat = 1024
    
    public func saveCoordinates(coors: [CRSCoordinate]) {
        var finalRoutePath = CRSRoutePath()
        let totalPoints = coors.map { coor in
            var point = CRSRoutePoint()
            point.coor = coor
            point.style = .solid
            point.available = true
            return point
        }
        
        CCFileManager.shared.createFolder(urlString: cachePathString())
        
        concurrentQueue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            let current = self.currentRoutePath()
            finalRoutePath.pathDatas = current.route.pathDatas + totalPoints
            self.write(path: finalRoutePath, url: URL(fileURLWithPath: current.path))
        }
    }
    
    public func allCoordinatesRoutePath(complete: @escaping (CRSRoutePath) -> Void) {
        concurrentQueue.async { [weak self] in
            guard let self else { return }
            var finalRoutePath = CRSRoutePath()
            let cacheBaseUrlString = self.cachePathString()
            let allFiles = CCFileManager.shared.fileList(cacheBaseUrlString)
            for file in allFiles {
                let fullPath = cacheBaseUrlString + "/\(file)"
                if let readPath = self.read(url: URL(fileURLWithPath: fullPath)) {
                    finalRoutePath.pathDatas = finalRoutePath.pathDatas + readPath.pathDatas
                }
            }
            main {
                complete(finalRoutePath)
            }
        }
    }
    
    private func currentRoutePath() -> (route: CRSRoutePath, path: String) {
        let cachePath = cachePathString()
        let allFiles = CCFileManager.shared.contentsOfDirectory(at: cachePath)
        if allFiles.isEmpty {
            let path = prepareCachePath(index: 1)
            return (CRSRoutePath(), path)
        } else {
            if let maxFileName = allFiles.sorted(by: { (Int($0) ?? 0) < (Int($1) ?? 0) }).last {
                let urlString = cachePath + "/\(maxFileName)"
                let size = CCFileManager.shared.fileSize(atPath: urlString)
                if size >= maxCacheSize {
                    let path = prepareCachePath(index: allFiles.count + 1)
                    return (CRSRoutePath(), path)
                } else {
                    let fileUrl = URL(fileURLWithPath: urlString)
                    var path = CRSRoutePath()
                    if let readPath = read(url: fileUrl) {
                        path = readPath
                    }
                    return (path, urlString)
                }
            } else {
                let path = prepareCachePath(index: allFiles.count + 1)
                return (CRSRoutePath(), path)
            }
        }
    }
    
    private func prepareCachePath(index: Int) -> String {
        let cachePath = cachePathString() + "/\(index).bat"
        if !CCFileManager.shared.isFileExists(cachePath) {
            CCFileManager.shared.createFile(urlString: cachePath)
            return cachePath
        } else {
            return cachePath
        }
    }
    
    func cachePathString() -> String {
        return fileBaseUrlString + "/userId/castCacheTrack/deviceId_startTime"
    }
}


extension CRSCastTrackCacheManager {
    
    private func write(path: CRSRoutePath, url: URL? = nil) {
        do {
            let binaryData = try path.serializedData()
            if let url = url {
                try binaryData.write(to: url)
            }
        } catch {
            print("write path error: \(error)")
        }
    }
    
    private func read(url: URL) -> CRSRoutePath? {
        var path: CRSRoutePath?
        
        do {
            let data: Data? = try Data(contentsOf: url)
            if let data = data {
                guard let l = try? CRSRoutePath(serializedData: data) else {
                    return nil
                }
                path = l
            }
        } catch {
            print("read path error: \(error)")
        }
        
        return path
    }
    
}
