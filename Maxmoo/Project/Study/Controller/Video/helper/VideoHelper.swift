//
//  VideoHelper.swift
//  Maxmoo
//
//  Created by 程超 on 2024/5/8.
//

import Foundation

@objc
class CCVideoHelper: NSObject {
    @objc
    static let shared = CCVideoHelper()
    
    private var pixelBufferPool: CVPixelBufferPool? = nil
    
    private func setupCVPixelBufferIfNeed(_ frame: UnsafeMutablePointer<AVFrame>) {
        guard pixelBufferPool == nil else { return }
        var pixelBufferAttributes: [String: Any] = [:]
        if frame.pointee.color_range == AVCOL_RANGE_MPEG {
            pixelBufferAttributes[kCVPixelBufferPixelFormatTypeKey as String] = kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
        } else {
            pixelBufferAttributes[kCVPixelBufferPixelFormatTypeKey as String] = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
        }
        pixelBufferAttributes[kCVPixelBufferMetalCompatibilityKey as String] = true
        pixelBufferAttributes[kCVPixelBufferWidthKey as String] = frame.pointee.width
        pixelBufferAttributes[kCVPixelBufferHeightKey as String] = frame.pointee.height
        pixelBufferAttributes[kCVPixelBufferBytesPerRowAlignmentKey as String] = frame.pointee.linesize.0
        let ret = CVPixelBufferPoolCreate(kCFAllocatorDefault, nil, pixelBufferAttributes as CFDictionary, &pixelBufferPool)
        guard ret == kCVReturnSuccess else {
            fatalError("initialize CVPixelBufferPool failed")
        }
    }
    
    @objc
    public func makeCVPixelBuffer(from frame: UnsafeMutablePointer<AVFrame>) -> CVPixelBuffer? {
        guard let pixelBufferPool = self.pixelBufferPool else { return nil }
        var pixelBuffer: CVPixelBuffer! = nil
        let ret = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferPool, &pixelBuffer)
        guard ret == kCVReturnSuccess else { return nil }
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.init(rawValue: 0))
        let ySizePerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 0)
        let uvSizePerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer, 1)
        let yBaseAddress = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0)
        let uvBaseAddress = CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 1)
        memcpy(yBaseAddress, frame.pointee.data.0, ySizePerRow * Int(frame.pointee.height))
        memcpy(uvBaseAddress, frame.pointee.data.1, uvSizePerRow * Int(frame.pointee.height) / 2)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags.init(rawValue: 0))
        return pixelBuffer
    }
}
