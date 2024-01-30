//
//  UIView+CC.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit
import Foundation
import CoreTelephony
import SystemConfiguration

@objc enum UIDeviceType: Int {
    case unknown
    case iPhone4
    case iPhone4s
    case iPhone5
    case iPhone5c
    case iPhone5s
    case iPhone6
    case iPhone6s
    case iPhone6Plus
    case iPhone6sPlus
    case iPhone7
    case iPhone7Plus
    case iPhone8
    case iPhone8Plus
    case iPhoneX
    case iPhoneXR
    case iPhoneXS
    case iPhoneXSMax
    case iPhone11
    case iPhone11Pro
    case iPhone11ProMax
    case iPhone12
    case iPhone12mini
    case iPhone12Pro
    case iPhone12ProMax
    case iPhone13mini
    case iPhone13
    case iPhone13Pro
    case iPhone13ProMax
    case iPhone14
    case iPhone14Plus
    case iPhone14Pro
    case iPhone14ProMax
    case iPhoneSE
    case iPhoneSE2
    case iPhoneSE3
    case iPhone15
    case iPhone15Plus
    case iPhone15Pro
    case iPhone15ProMax
}

enum CRSNetworkType {
    case netUnknown
    case netWifi
    case net2G
    case net3G
    case net4G
    case net5G
}

extension UIDevice {
    
    // MARK: 顶部安全区高度
    
    @objc static var safeAreaTop: CGFloat {
        var targetWindow = UIApplication.shared.windows.first
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            if let windowScene = scene as? UIWindowScene, let window = windowScene.windows.first {
                targetWindow = window
            }
        }
        guard let targetWindow = targetWindow else {
            return 0
        }
        let orientation = screenOrientation
        if orientation == .landscapeLeft {
            return targetWindow.safeAreaInsets.left
        } else if orientation == .landscapeRight {
            return targetWindow.safeAreaInsets.right
        } else if orientation == .portraitUpsideDown ||
                    orientation == .portraitUpsideDown {
            return targetWindow.safeAreaInsets.top
        }
        return targetWindow.safeAreaInsets.top
    }
    
    // MARK: 底部安全区高度
    
    @objc static var safeAreaBottom: CGFloat {
        var targetWindow = UIApplication.shared.windows.first
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            if let windowScene = scene as? UIWindowScene, let window = windowScene.windows.first {
                targetWindow = window
            }
        }
        guard let targetWindow = targetWindow else { return 0 }
        return targetWindow.safeAreaInsets.bottom
    }
    
    // MARK: 屏幕宽高
    
    @objc static var screenWidth: CGFloat {
        var width = UIScreen.main.bounds.size.width
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            if let windowScene = scene as? UIWindowScene, let window = windowScene.windows.first {
                width = window.screen.bounds.width
            }
        }
        return width
    }
    
    @objc static var screenHeight: CGFloat {
        var height = UIScreen.main.bounds.size.height
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            if let windowScene = scene as? UIWindowScene, let window = windowScene.windows.first {
                height = window.screen.bounds.height
            }
        }
        return height
    }
    
    // MARK: 顶部状态栏高度（包括安全区）
    
    @objc static var statusBarHeight: CGFloat {
        var statusBarHeight = UIApplication.shared.statusBarFrame.height
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            if let windowScene = scene as? UIWindowScene, let statusBarManager = windowScene.statusBarManager {
                statusBarHeight = statusBarManager.statusBarFrame.height
            }
        }
        return statusBarHeight
    }
    
    // MARK: 导航栏高度
    
    @objc static var navigationBarHeight: CGFloat { 44.0 }
    
    // MARK: 状态栏+导航栏的高度
    
    @objc static var navigationFullHeight: CGFloat { UIDevice.statusBarHeight + UIDevice.navigationBarHeight }
    
    // MARK: 底部tabbar的高度
    
    @objc static var tabBarHeight: CGFloat { 49.0 }
    
    // MARK: 底部tabbar的高度（包括安全区）
    
    @objc static var tabBarFullHeight: CGFloat { UIDevice.tabBarHeight + UIDevice.safeAreaBottom }
    
    // MARK: 当前的语言
    
    @objc static var currentLanguage: String {
        if #available(iOS 16, *) {
            return Locale.current.language.languageCode?.identifier ?? "zh"
        }
        return Locale.current.languageCode ?? "zh"
    }
    
    // MARK: 当前的屏幕方向
    
    @objc static var screenOrientation: UIInterfaceOrientation {
        var orientation = UIApplication.shared.statusBarOrientation
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            if let windowScene = scene as? UIWindowScene  {
                orientation = windowScene.interfaceOrientation
            }
        }
        return orientation
    }
    
    // MARK: windows
    
    private static var _windows: [UIWindow]?
    
    @objc static var windows: [UIWindow] {
        var _private: [UIWindow] {
            var windows = UIApplication.shared.windows
            if #available(iOS 15.0, *) {
                let scene = UIApplication.shared.connectedScenes.first
                if let windowScene = scene as? UIWindowScene {
                    windows = windowScene.windows
                }
            }
            return windows
        }
        if _windows?.isEmpty ?? true {
            _windows = _private
        }
        return _windows ?? []
    }
    
    // MARK: 是否是中文
    
    @objc static var isChinese: Bool {
        return currentLanguage.lowercased() == "zh"
    }
    
    // MARK: 当前地区
    
    @objc static var countryCode: String {
        if #available(iOS 16, *) {
            return Locale.current.region?.identifier ?? "CN"
        }
        return Locale.current.regionCode ?? "CN"
    }
    
    // MARK: 是否是中国
    
    // 系统的地区设置
    @objc static var isChina: Bool { countryCode.lowercased() == "cn" }
    
    // 优先判断sim卡归属地，然后再判断ip，最后判断系统的地区设置
    @objc static var crsIsChina: Bool {
        let code = fetchSimInfo().lowercased()
        if !code.isEmpty {
            return code == "cn"
        }
        return isChina
    }
    
    // MARK: 当前时区
    
    @objc static var currentTimeZone: String { NSTimeZone.local.identifier }
    @objc static var currentTimeZoneCode: Int {
        let local = NSTimeZone.local
        let timeOffset = local.secondsFromGMT() // 单位为秒
        return timeOffset / 15 / 60 // 每15分钟作为一个分割
    }
    
    // MARK: 是否是公英制
    
    @objc static var isMetric: Bool {
        let locale = Locale.current
        var isMetric = true
        if #available(iOS 16, *) {
            let identifier = locale.measurementSystem.identifier.lowercased()
            isMetric = identifier == "metric"
        } else {
            isMetric = locale.usesMetricSystem
        }
        return isMetric
    }
    
    // MARK: SIM卡信息
    
    @objc static func fetchSimInfo() -> String {
        let info = CTTelephonyNetworkInfo()
        let carrier = info.subscriberCellularProvider
        let isoCountryCode = carrier?.isoCountryCode ?? ""
        if isoCountryCode == "--" {
            return ""
        }
        return isoCountryCode
    }
    
    // MARK: 设备存储空间
    
    @objc static var freeDiskspace: UInt {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        guard let path = path else {
            return 0
        }
        let dictionary = try? FileManager.default.attributesOfFileSystem(forPath: path)
        guard let dictionary = dictionary else {
            return 0
        }
        let size = dictionary[FileAttributeKey.systemFreeSize] as? UInt
        guard let size = size else {
            return 0
        }
        return size
    }
    
    @objc static var totalDickSpace: UInt {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        guard let path = path else {
            return 0
        }
        let dictionary = try? FileManager.default.attributesOfFileSystem(forPath: path)
        guard let dictionary = dictionary else {
            return 0
        }
        let size = dictionary[FileAttributeKey.systemSize] as? UInt
        guard let size = size else {
            return 0
        }
        return size
    }
    
    // MARK: 设备类型
    
    @objc static var deviceType: UIDeviceType {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let platform = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        if platform == "iPhone3,1" || platform == "iPhone3,2" || platform == "iPhone3,3" { return .iPhone4 }
        if platform == "iPhone4,1" { return .iPhone4s }
        if platform == "iPhone5,1" || platform == "iPhone5,2" { return .iPhone5 }
        if platform == "iPhone5,3" || platform == "iPhone5,4" { return .iPhone5c }
        if platform == "iPhone6,1" || platform == "iPhone6,2" { return .iPhone5s }
        if platform == "iPhone7,2" { return .iPhone6 }
        if platform == "iPhone7,1" { return .iPhone6Plus }
        if platform == "iPhone8,1" { return .iPhone6s }
        if platform == "iPhone8,2" { return .iPhone6sPlus }
        if platform == "iPhone8,3" || platform == "iPhone8,4" { return .iPhoneSE }
        if platform == "iPhone9,1" || platform == "iPhone9,3" { return .iPhone7 }
        if platform == "iPhone9,2" || platform == "iPhone9,4" { return .iPhone7Plus }
        if platform == "iPhone10,1" || platform == "iPhone10,4" { return .iPhone8 }
        if platform == "iPhone10,2" || platform == "iPhone10,5" { return .iPhone8Plus }
        if platform == "iPhone10,3" || platform == "iPhone10,6" { return .iPhoneX }
        if platform == "iPhone11,2" { return .iPhoneXS }
        if platform == "iPhone11,4" || platform == "iPhone11,6" { return .iPhoneXSMax }
        if platform == "iPhone11,8" { return .iPhoneXR }
        if platform == "iPhone12,1" { return .iPhone11 }
        if platform == "iPhone12,3" { return .iPhone11Pro }
        if platform == "iPhone12,5" { return .iPhone11ProMax }
        if platform == "iPhone12,8" { return .iPhoneSE2 }
        if platform == "iPhone13,1" { return .iPhone12mini }
        if platform == "iPhone13,2" { return .iPhone12 }
        if platform == "iPhone13,3" { return .iPhone12Pro }
        if platform == "iPhone13,4" { return .iPhone12ProMax }
        if platform == "iPhone14,2" { return .iPhone13Pro }
        if platform == "iPhone14,3" { return .iPhone13ProMax}
        if platform == "iPhone14,4" { return .iPhone13mini }
        if platform == "iPhone14,5" { return .iPhone13 }
        if platform == "iPhone14,6" { return .iPhoneSE3 }
        if platform == "iPhone14,7" { return .iPhone14}
        if platform == "iPhone14,8" { return .iPhone14Plus }
        if platform == "iPhone15,2" { return .iPhone14Pro }
        if platform == "iPhone15,3" { return .iPhone14ProMax }
        if platform == "iPhone15,4" { return .iPhone15 }
        if platform == "iPhone15,5" { return .iPhone15Plus }
        if platform == "iPhone16,1" { return .iPhone15Pro }
        if platform == "iPhone16,2" { return .iPhone15ProMax }
        
        return .unknown
    }
    
    // MARK: 是否是小屏幕手机
    
    // 每次对比耗时，做个缓存
    private static var _isSmallScreen: Bool?
    
    @objc static var crs_isSmallDevice: Bool {
        if _isSmallScreen == nil {
            _isSmallScreen = isSmallScreenDevice
        }
        return _isSmallScreen ?? false
    }
    
    @objc static var isSmallScreenDevice: Bool {
        if _isSmallScreen == nil {
            var _private: Bool {
                let type = UIDevice.deviceType
                return type == .iPhone4 ||
                type == .iPhone5 ||
                type == .iPhone4s ||
                type == .iPhone5s ||
                type == .iPhone5c ||
                type == .iPhone6 ||
                type == .iPhone6s ||
                type == .iPhone7 ||
                type == .iPhone8 ||
                type == .iPhoneSE ||
                type == .iPhoneSE2 ||
                type == .iPhoneSE3
            }
            _isSmallScreen = _private
        }
        return _isSmallScreen ?? false
    }
    
    // MARK: 打开app设置页面
    
    @objc static func openAppSettings() {
        let urlString = UIApplication.openSettingsURLString
        let url = URL(string: urlString)
        if let url = url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: keywindow
    
    private static var _keyWindow: UIWindow?
    
    @objc static var keyWindow: UIWindow? {
        var _private: UIWindow? {
            if #available(iOS 13.0, *) {
                let scene = UIApplication.shared.connectedScenes.first
                let windowScene = scene as? UIWindowScene
                return windowScene?.windows.first { $0.isKeyWindow }
            } else if #available(iOS 11.0, *) {
                return UIApplication.shared.windows.first { $0.isKeyWindow }
            }
            return UIApplication.shared.keyWindow
        }
        if _keyWindow == nil {
            _keyWindow = _private
        }
        return _keyWindow
    }
    
    // MARK: 当前截屏
    
    @objc static func screenshot() -> UIImage? {
        let windows = UIDevice.windows
        let orientation = UIDevice.screenOrientation
        var imageSize = CGSize.zero
        if orientation.isPortrait {
            imageSize = .init(width: UIDevice.screenWidth, height: UIDevice.screenHeight)
        } else {
            imageSize = .init(width: UIDevice.screenHeight, height: UIDevice.screenHeight)
        }
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        for window in windows {
            context.saveGState()
            context.translateBy(x: window.center.x, y: window.center.y)
            context.concatenate(window.transform)
            context.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x, y: -window.bounds.size.height * window.layer.anchorPoint.y)
            if orientation == .landscapeLeft {
                context.rotate(by: .pi / 2.0)
                context.translateBy(x: 0, y: -imageSize.width)
            } else if orientation == .landscapeRight {
                context.rotate(by: -.pi / 2.0)
                context.translateBy(x: -imageSize.height, y: 0)
            } else if orientation == .portraitUpsideDown {
                context.rotate(by: .pi)
                context.translateBy(x: -imageSize.width, y: -imageSize.height)
            }
            if window.responds(to: #selector(UIView.drawHierarchy(in:afterScreenUpdates:))) {
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
            } else {
                window.layer.render(in: context)
            }
            context.restoreGState()
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    // MARK: 网络类型
    
    static func networkType() -> CRSNetworkType {
        var domain = "www.google.com"
        if isChina {
            domain = "www.baidu.com"
        }
        guard let reachability = SCNetworkReachabilityCreateWithName(nil, domain) else {
            return .netUnknown
        }
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        if flags.contains(.isWWAN) {
            let networkInfo = CTTelephonyNetworkInfo()
            if #available(iOS 14.1, *) {
                if let radioAccessTechnology = networkInfo.serviceCurrentRadioAccessTechnology?[CTRadioAccessTechnologyNR],
                   radioAccessTechnology.count > 0 {
                    return .net5G
                }
                if let radioAccessTechnology = networkInfo.serviceCurrentRadioAccessTechnology?[CTRadioAccessTechnologyNRNSA],
                   radioAccessTechnology.count > 0 {
                    return .net5G
                }
            }
            if let radioAccessTechnology = networkInfo.currentRadioAccessTechnology {
                switch radioAccessTechnology {
                case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
                    return .net2G
                case CTRadioAccessTechnologyWCDMA, CTRadioAccessTechnologyHSDPA, CTRadioAccessTechnologyHSUPA, CTRadioAccessTechnologyCDMAEVDORev0, CTRadioAccessTechnologyCDMAEVDORevA, CTRadioAccessTechnologyCDMAEVDORevB, CTRadioAccessTechnologyeHRPD:
                    return .net3G
                case CTRadioAccessTechnologyLTE:
                    return .net4G
                default:
                    return .netUnknown
                }
            }
        } else if flags.contains(.reachable) {
            return .netWifi
        }
        return .netUnknown
    }
    
    // MARK: 是否是12小时制
    
    @objc static func is12HourFormat() -> Bool {
        let formatStringForHours = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)
        return formatStringForHours?.contains("a") ?? false
    }
    
}
