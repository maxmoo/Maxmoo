//
//  CRSMapClusterAnnotation.swift
//  Maxmoo
//
//  Created by 程超 on 2024/7/2.
//

import UIKit
import CoreLocation

// 聚合点必须实现
@objc
protocol CRSMapClusterProtocol: NSObjectProtocol {
    var coordinate: CLLocationCoordinate2D { get set }
}

// 图片聚合
@objc
class CRSSportPhotoAnnotation: NSObject, CRSMapClusterProtocol {
    @objc
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @objc
    var title: String = ""
}

// 录音聚合
@objc
class CRSSportVoiceAnnotation: NSObject, CRSMapClusterProtocol {
    @objc
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @objc
    var title: String = ""
}

// 聚合类型
@objc
enum CRSMapClusterType: Int {
    case photo
    case voice
}

@objc
class CRSMapClusterAnnotation: NSObject {
    @objc
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @objc
    var anns: [CRSMapClusterProtocol] = []
    @objc
    var type: CRSMapClusterType = .photo
    @objc
    var count: Int {
        return anns.count
    }
}
