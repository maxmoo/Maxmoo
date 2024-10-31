//
//  CCCenterCluster.swift
//  Maxmoo
//
//  Created by 程超 on 2024/7/24.
//

import UIKit

class CCCenterCluster: NSObject {
    
    // 简单聚合策略
    func aggregateCoordinates(_ anns: [CRSMapClusterProtocol], withThreshold threshold: Double) -> [CRSMapClusterAnnotation] {
        var clusters = [CRSMapClusterAnnotation]()
        var visited = [Bool](repeating: false, count: anns.count)
        
        for i in 0..<anns.count {
            if visited[i] {
                continue
            }
            visited[i] = true
            
            // 以当前点为中心，创建一个新的聚类
            var cluster = anns[i]
            var clusterAnns: [CRSMapClusterProtocol] = [cluster]
            var clusterCoor = cluster.coordinate
            
            for j in (i+1)..<anns.count {
                if visited[j] {
                    continue
                }
                // 如果点j与点i的距离小于阈值，将其加入当前聚类
                if distanceBetween(anns[i], anns[j]) < threshold {
                    clusterCoor.latitude += anns[j].coordinate.latitude
                    clusterCoor.longitude += anns[j].coordinate.longitude
                    clusterAnns.append(anns[j])
                    visited[j] = true
                }
            }
            
            // 计算当前聚类的中心点
            clusterCoor.latitude /= Double(clusterAnns.count)
            clusterCoor.longitude /= Double(clusterAnns.count)
            
            let clusterCollect = CRSMapClusterAnnotation()
            clusterCollect.coordinate = clusterCoor
            clusterCollect.anns = clusterAnns
            clusters.append(clusterCollect)
        }
        
        return clusters
    }
    
    // 计算两点间的距离
    func distanceBetween(_ first: CRSMapClusterProtocol, _ second: CRSMapClusterProtocol) -> Double {
        return sqrt(pow(first.coordinate.latitude - second.coordinate.latitude, 2) + pow(first.coordinate.longitude - second.coordinate.longitude, 2))
    }
}
