//
//  FFVideoRender.swift
//  FFmpegPlayer-Swift
//
//  Created by youxiaobin on 2021/1/6.
//

import Foundation
import UIKit

protocol FFVideoRender {
    var pixFMT: AVPixelFormat { get }
    var render: UIView { get }
    func display(with frame: UnsafeMutablePointer<AVFrame>)
}
