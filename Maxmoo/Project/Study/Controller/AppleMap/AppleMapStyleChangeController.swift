//
//  AppleMapStyleChangeController.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/31.
//

import UIKit
import MapKit

class AppleMapStyleChangeController: CCBaseViewController {

    var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupUI()
    }
    
    func setupMap() {
        mapView = MKMapView(frame: view.bounds)
        view.addSubview(mapView)

        let initialLocation = CLLocation(latitude: 23.7749, longitude: 114.4194)
        let region = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
    }
    
    func setupUI() {
        let titles: [String] = ["标准","卫星","混合","卫3D","混3D","暗标准"]
        let width: CGFloat = 100
        for (i, title) in titles.enumerated() {
            let button = UIButton(frame: CGRect(x: 16.0,
                                                y: 120.0 + CGFloat(i) * 40.0,
                                                width: width,
                                                height: 30))
            button.backgroundColor = .randomColor
            button.setTitle(title, for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
            view.addSubview(button)
        }
    }
    
    @objc
    func action(sender: UIButton) {
        switch sender.tag {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        case 2:
            mapView.mapType = .hybrid
        case 3:
            mapView.mapType = .satelliteFlyover
        case 4:
            mapView.mapType = .hybridFlyover
        case 5:
            mapView.mapType = .mutedStandard
        default:
            break
        }
    }
}
