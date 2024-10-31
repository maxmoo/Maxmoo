//
//  AMapViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/2/23.
//

import UIKit
import MAMapKit

class AMapViewController: UIViewController {

    /// map
    private var mapView: MAMapView!
    /// 高德地图key
    private let apiKey: String = "3b5ec2b6a414bf0fe79d17bf0b65e2a0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createMap()
    }

    private func createMap() {
        // 支持https 不一定要放在这，在地图启用前设置就好
        AMapServices.shared().enableHTTPS = true
        // 设置apiKay
        AMapServices.shared().apiKey = apiKey
        //更新用户授权高德SDK隐私协议状态. since 8.1.0
        MAMapView.updatePrivacyShow(.didShow, privacyInfo: .didContain)
        MAMapView.updatePrivacyAgree(.didAgree)
        MAMapView.terrainEnabled = true
        
        mapView = MAMapView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
//        mapView.delegate = self
        // 设置最大缩放等级
//        mapView.maxZoomLevel = 19
        // 初始化时由于地图方位为正北，故隐藏指北针
        mapView.showsCompass = false
        // 隐藏标尺
        mapView.showsScale = false
        // 屏蔽camera仰角
//        mapView.isRotateCameraEnabled = false
        // 以手势中心为缩放点
//        mapView.zoomingInPivotsAroundAnchorPoint = false
        
        view.addSubview(mapView)
        
        let tapView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        tapView.backgroundColor = .randomColor
        tapView.addTapGesture {
            print("dasdasdadasdada")
        }
        view.addSubview(tapView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("touchesBegan")
    }
}
