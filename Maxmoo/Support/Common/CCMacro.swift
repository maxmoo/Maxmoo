//
//  CCPublic.swift
//  Maxmoo
//
//  Created by 程超 on 2023/8/28.
//

import UIKit
import Foundation

// MARK: - 屏幕相关
// MARK: -- 机型的屏幕大小
let IS_IPHONE4 = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 960).equalTo((UIScreen.main.currentMode?.size)!) : false)
let IS_IPHONE5 = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 640, height: 1136).equalTo((UIScreen.main.currentMode?.size)!) : false)
let IS_IPHONE6 = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 750, height: 1334).equalTo((UIScreen.main.currentMode?.size)!) : false)
let IS_IPHONE6_PLUS = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1242, height: 2208).equalTo((UIScreen.main.currentMode?.size)!) : false)
let IS_IPHONE6_PLUS_SCALE = (UIScreen.instancesRespond(to: #selector(getter: UIScreen.main.currentMode)) ? CGSize(width: 1125, height: 2001).equalTo((UIScreen.main.currentMode?.size)!) : false)
let isIphoneSmall = (IS_IPHONE4 || IS_IPHONE5)

// MARK: -- 屏幕尺寸
let kScreenBounds                           = UIScreen.main.bounds
let kScreenSize                             = kScreenBounds.size
let kScreenWidth                            = kScreenSize.width
let kScreenHeight                           = kScreenSize.height
let kNaviHeight                             = UINavigationController().navigationBar.frame.size.height
let kStatusBarHeight                        = UIApplication.shared.statusBarFrame.size.height
let kNavigationAndStatuBarHeight            = kNaviHeight + kStatusBarHeight
