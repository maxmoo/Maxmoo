//
//  AnnotationClusterViewController.swift
//  iOS_ClusterAnnotation_3D
//
//  Created by AutoNavi on 2016/12/16.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

import Foundation

let calloutViewMargin = -12.0
let buttonHeight = 70.0

class AnnotationClusterViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate, CustomCalloutViewTapDelegate {
    
    var mapView: MAMapView!
    var search: AMapSearchAPI!
    var refreshButton: UIButton!
    
    var coordinateQuadTree = CoordinateQuadTree()
    var customCalloutView = CustomCalloutView()
    var selectedPoiArray = Array<AMapPOI>()
    var shouldRegionChangeReCalculate = false
    var currentRequest: AMapPOIKeywordsSearchRequest?
    
    /// 高德地图key
    private let apiKey: String = "e68a4988b2bbf24ecf7daadab88c64fb"
    
    //MARK: - Update Annotation
    
    func updateMapViewAnnotations(annotations: Array<ClusterAnnotation>) {
        
        /* 用户滑动时，保留仍然可用的标注，去除屏幕外标注，添加新增区域的标注 */
        let before = NSMutableSet(array: mapView.annotations)
        before.remove(mapView.userLocation)
        let after: Set<NSObject> = NSSet(array: annotations) as Set<NSObject>
        
        /* 保留仍然位于屏幕内的annotation. */
        var toKeep: Set<NSObject> = NSMutableSet(set: before) as Set<NSObject>
        toKeep = toKeep.intersection(after)
        
        /* 需要添加的annotation. */
        let toAdd = NSMutableSet(set: after)
        toAdd.minus(toKeep)
        
        /* 删除位于屏幕外的annotation. */
        let toRemove = NSMutableSet(set: before)
        toRemove.minus(after)
        
        DispatchQueue.main.async(execute: { [weak self] () -> Void in
            self?.mapView.addAnnotations(toAdd.allObjects)
            self?.mapView.removeAnnotations(toRemove.allObjects)
        })
    }
    
    func addAnnotations(toMapView mapView: MAMapView) {
        synchronized(lock: self) { [weak self] in
            
            guard (self?.coordinateQuadTree.root != nil) || self?.shouldRegionChangeReCalculate != false else {
                NSLog("tree is not ready.")
                return
            }
            
            guard let aMapView = self?.mapView else {
                return
            }
            
            let visibleRect = aMapView.visibleMapRect
            let zoomScale = Double(aMapView.bounds.size.width) / visibleRect.size.width
            let zoomLevel = Double(aMapView.zoomLevel)
            print("sdadada: \(zoomScale)")
            
            DispatchQueue.global(qos: .default).async(execute: { [weak self] in
                
                let annotations = self?.coordinateQuadTree.clusteredAnnotations(within: visibleRect, withZoomScale: zoomScale, andZoomLevel: zoomLevel)
                print("cccccc: \(annotations?.count)")
                
                guard let annotations else { return }
                
                var showAnns: [ClusterAnnotation] = []
                for ann in annotations {
                    if let crsAnn = ann as? CRSMapClusterAnnotation {
                        if let showAnn = ClusterAnnotation(coordinate: crsAnn.coordinate, count: crsAnn.anns.count) {
                            showAnns.append(showAnn)
                        }
                    }
                }
                
                self?.updateMapViewAnnotations(annotations: showAnns)
            })
        }
    }
    
    
    
    func synchronized(lock: AnyObject, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    //MARK: - CustomCalloutViewTapDelegate
    
    func didDetailButtonTapped(_ index: Int) {
        let detail = PoiDetailViewController()
        detail.poi = selectedPoiArray[index]
        
        navigationController?.pushViewController(detail, animated: true)
    }
    
    //MARK: - MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        let annotation = view.annotation as! ClusterAnnotation
        
        for poi in annotation.pois {
            selectedPoiArray.append(poi as! AMapPOI)
        }
        
        customCalloutView.poiArray = selectedPoiArray
        customCalloutView.delegate = self
        
        customCalloutView.center = CGPoint(x: Double(view.bounds.midX), y: -Double(customCalloutView.bounds.midY)-Double(view.bounds.midY)-calloutViewMargin)
        
        view.addSubview(customCalloutView)
    }
    
    func mapView(_ mapView: MAMapView!, didDeselect view: MAAnnotationView!) {
        selectedPoiArray.removeAll()
        customCalloutView.dismiss()
        customCalloutView.delegate = nil
    }
    
    func mapView(_ mapView: MAMapView!, regionDidChangeAnimated animated: Bool) {
        addAnnotations(toMapView: self.mapView)
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation is ClusterAnnotation {
            let pointReuseIndetifier = "pointReuseIndetifier"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? ClusterAnnotationView
            
            if annotationView == nil {
                annotationView = ClusterAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView?.annotation = annotation
            annotationView?.count = UInt((annotation as! ClusterAnnotation).count)
            
            return annotationView
        }
        
        return nil
    }
    
    func createPois() {
        selectedPoiArray.removeAll()
        customCalloutView.dismiss()
        mapView.removeAnnotations(mapView.annotations)
        
        var pois: [AMapPOI] = []
        for index in 0...100 {
            let poi = AMapPOI()
            poi.uid = "\(index)"
            let location = AMapGeoPoint()
            location.latitude = CGFloat((Int.random(in: 0...10000))) / 10000.0 + 23.0
            location.longitude = CGFloat((Int.random(in: 0...10000))) / 10000.0 + 114.0
            poi.location = location
            pois.append(poi)
        }
        
        var photoAnns: [CRSSportPhotoAnnotation] = []
        for index in 0...200 {
            let ann = CRSSportPhotoAnnotation()
            let lat = 23.0 + Double(Int.random(in: 0..<10000)) / 10000
            let lon = 114.0 + Double(Int.random(in: 0..<10000)) / 10000
            ann.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            ann.title = "\(index)"
            photoAnns.append(ann)
        }
        
        DispatchQueue.global(qos: .default).async(execute: { [weak self] in
            self?.coordinateQuadTree.build(withAnns: photoAnns)
            self?.shouldRegionChangeReCalculate = true
            DispatchQueue.main.async(execute: {
                self?.addAnnotations(toMapView: (self?.mapView)!)
            })
        })
    }
    
    //MARK: - Button Action
    
    @objc func refreshButtonAction() {
        createPois()
    }
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMapView()
        
        initSearch()
        
        initRefreshButton()
        
        refreshButtonAction()
    }
    
    deinit {
        coordinateQuadTree.clean()
    }
    
    func initMapView() {
        AMapServices.shared().enableHTTPS = true
        AMapServices.shared().apiKey = apiKey
        MAMapView.updatePrivacyShow(.didShow, privacyInfo: .didContain)
        MAMapView.updatePrivacyAgree(.didAgree)
        
        mapView = MAMapView(frame: view.bounds)
        mapView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-CGFloat(buttonHeight))
        mapView.delegate = self
        
        view.addSubview(mapView)
        
        mapView.visibleMapRect = MAMapRectMake(220880104, 101476980, 272496, 466656)
    }
    
    func initSearch() {
        search = AMapSearchAPI()
        search.delegate = self
    }
    
    func initRefreshButton() {
        refreshButton = UIButton(type: .custom)
        refreshButton.frame = CGRect(x: 0, y: Double(mapView.frame.origin.y+mapView.frame.size.height), width: Double(mapView.frame.size.width), height: buttonHeight)
        refreshButton.setTitle("重新加载数据", for: .normal)
        refreshButton.setTitleColor(UIColor.purple, for: .normal)
        
        refreshButton.addTarget(self, action: #selector(self.refreshButtonAction), for: .touchUpInside)
        
        view.addSubview(refreshButton)
    }
    
}
