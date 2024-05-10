//
//  GyroViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/5/9.
//

import UIKit
import CoreMotion

class GyroViewController: UIViewController {

    private let gyromanager = CMMotionManager()
    /// manager刷新时间间隔（采样频率设置为比屏幕刷新频率1/60稍小）
    public var timestamp:CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        startMotionUpdates()
    }
    

    /// 开始陀螺仪
     private func startMotionUpdates() {
         if self.gyromanager.isGyroAvailable {
             if self.gyromanager.isGyroActive { return }
             self.gyromanager.gyroUpdateInterval = TimeInterval(self.timestamp)
//             self.gyromanager.startGyroUpdates(to: OperationQueue.main) { (data, nil) in
//                 if let gyroData = data {
//                     print("陀螺仪---Updates---0")
//                     print("gyro data: x(\(gyroData.rotationRate.x)) y(\(gyroData.rotationRate.y)) z(\(gyroData.rotationRate.z))")
//                 }
//             }
//             self.gyromanager.startAccelerometerUpdates(to: OperationQueue.main) { data, error in
//                 
//             }
             self.gyromanager.startDeviceMotionUpdates(to: OperationQueue.main) { motion, error in
                 guard let motion = motion else {
                     return
                 }
                 
                  // 设备现在所处的的物理状态
//                 print("--->1   2.",motion.rotationRate)
                 // 设备的转速。
//                 print("--->2   2.",motion.gravity)
                   // 在设备参考系中表示的重力加速度矢量。
                 // (-3.14~3.14)
                 print("--->3   2.",motion.attitude.yaw)
                 // 用户给设备的加速度。
//                 print("--->4   2.",motion.userAcceleration)
             }
         }
     }
     
     /// 停止陀螺仪
     private func stopMotionUpdates() {
         print("陀螺仪---stopMotionUpdates")
         self.gyromanager.stopGyroUpdates()
     }

}
