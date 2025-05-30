//
//  CRSLiveActivityController.swift
//  Maxmoo
//
//  Created by 程超 on 2025/5/29.
//

import UIKit
import ActivityKit
import SwiftUI

class CRSLiveActivityController: UIViewController {

    var status : Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        let startLabel = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        startLabel.setTitle("开始", for: .normal)
        startLabel.setTitleColor(.black, for: .normal)
        startLabel.addTarget(self, action: #selector(live_Start), for: .touchUpInside)
        view.addSubview(startLabel)
        
        let updateLabel = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 100))
        updateLabel.setTitle("更新", for: .normal)
        updateLabel.setTitleColor(.black, for: .normal)
        updateLabel.addTarget(self, action: #selector(live_Update), for: .touchUpInside)
        view.addSubview(updateLabel)
        
        let endLabel = UIButton(frame: CGRect(x: 100, y: 300, width: 100, height: 100))
        endLabel.setTitle("结束", for: .normal)
        endLabel.setTitleColor(.black, for: .normal)
        endLabel.addTarget(self, action: #selector(live_End), for: .touchUpInside)
        view.addSubview(endLabel)
    }

    @objc
    func live_Start() {
        if #available(iOS 16.1, *) {
            startDeliveryPizza()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc
    func live_Update() {
        if #available(iOS 16.1, *) {
            updateDeliveryPizza()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc
    func live_End() {
        if #available(iOS 16.1, *) {
            stopDeliveryPizza()
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    @available(iOS 16.1, *)
    func startDeliveryPizza() {
        //初始化静态数据
        let pizzaDeliveryAttributes = PizzaDeliveryAttributes(numberOfPizzas: 5, totalAmount:"￥99", orderNumber: "23456")
        //初始化动态数据
        let initialContentState = PizzaDeliveryAttributes.PizzaDeliveryStatus(driverName: "小旋风 🚴🏻",driverStatus: status , deliveryTimer: Date()...Date().addingTimeInterval(15 * 60))
                                                  
        do {
            //启用灵动岛
            //灵动岛只支持Iphone，areActivitiesEnabled用来判断设备是否支持，即便是不支持的设备，依旧可以提供不支持的样式展示
            if ActivityAuthorizationInfo().areActivitiesEnabled == true{
                
            }
            let deliveryActivity = try Activity<PizzaDeliveryAttributes>.request(
                attributes: pizzaDeliveryAttributes,
                contentState: initialContentState,
                pushType: nil)
            //判断启动成功后，获取推送令牌 ，发送给服务器，用于远程推送Live Activities更新
            //不是每次启动都会成功，当已经存在多个Live activity时会出现启动失败的情况
            if deliveryActivity.activityState == .active{
                _ = deliveryActivity.pushToken
            }
//            deliveryActivity.pushTokenUpdates //监听token变化
            print("Current activity id -> \(deliveryActivity.id)")
        } catch (let error) {
            print("Error info -> \(error.localizedDescription)")
        }
    }
    
    @available(iOS 16.1, *)
    func updateDeliveryPizza() {
        Task {
            status += 1
            if status > 3 {
                status = 1
            }
            let updatedDeliveryStatus = PizzaDeliveryAttributes.PizzaDeliveryStatus(driverName: "小旋风 🚴🏻",driverStatus: status ,deliveryTimer: Date()...Date().addingTimeInterval(60 * 60))
            //此处只有一个灵动岛，当一个项目有多个灵动岛时，需要判断更新对应的activity
            for activity in Activity<PizzaDeliveryAttributes>.activities{
                await activity.update(using: updatedDeliveryStatus)
            }
        }
    }
    
    @available(iOS 16.1, *)
    func stopDeliveryPizza() {
        Task {
            for activity in Activity<PizzaDeliveryAttributes>.activities{
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }
    
    
    @available(iOS 16.1, *)
    func showAllDeliveries() {
        Task {
            for activity in Activity<PizzaDeliveryAttributes>.activities {
                print("Pizza delivery details: \(activity.id) -> \(activity.attributes)")
            }
        }
    }

}
