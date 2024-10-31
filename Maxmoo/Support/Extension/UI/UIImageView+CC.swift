//
//  UIImageView+CC.swift
//  Maxmoo
//
//  Created by 程超 on 2024/7/23.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    func fetchOnlineVideoCoverImage(fromURL videoURL: URL?,
                                    placeHolderImage: UIImage? = nil,
                                    completed: ((_ cover: UIImage?) -> Void)? = nil) {
        guard let videoURL = videoURL else {
            if let placeHolderImage = placeHolderImage {
                image = placeHolderImage
            }
            completed?(nil)
            return
        }
        
        // 读缓存
        if let image = SDImageCache.shared.imageFromCache(forKey: videoURL.absoluteString) {
            self.image = image
            completed?(image)
            return
        }
        
        let asset = AVURLAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        // 设置封面图像的时间点（例如：视频的第一帧）
        let time = CMTime(seconds: 0.0, preferredTimescale: 1)
        imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { [weak self] _, image, _, _, _ in
            guard let self = self else { return }
            if let cgImage = image {
                DispatchQueue.main.async {
                    self.image = UIImage(cgImage: cgImage)
                    // 缓存图片
                    SDImageCache.shared.store(self.image, forKey: videoURL.absoluteString, completion: nil)
                    completed?(self.image)
                }
            } else {
                DispatchQueue.main.async {
                    if let placeHolderImage = placeHolderImage {
                        self.image = placeHolderImage
                    }
                    completed?(nil)
                }
            }
        }
    }
    
}
