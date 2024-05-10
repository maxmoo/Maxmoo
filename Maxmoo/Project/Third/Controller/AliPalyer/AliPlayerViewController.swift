//
//  AliPlayerViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/1/3.
//

import UIKit
//import AliyunPlayer

class AliPlayerViewController: UIViewController {

//    lazy var player: AliPlayer? = {
//        let p = AliPlayer()
//        p?.playerView = playerView
//        p?.delegate = self
//        // 是否自动播放
////        p?.isAutoPlay = true
//        // 音量调节0~2
//        p?.volume = 1.0
//        // 是否静音
////        p?.isMuted = false
//        // 倍速播放0.5~5
//        p?.rate = 1.0
//        return p
//    }()
//    
//    lazy var playerView: UIView = {
//        let v = UIView(frame: CGRect(x: 0, y: 200, width: kScreenWidth, height: kScreenWidth*(9.0/16.0)))
//        v.backgroundColor = .lightGray
//        return v
//    }()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        urlPlay()
////        vidAuthPlay()
//    }
//
//    // 播放方式
//    // 点播URL
//    func urlPlay() {
//        let urlSource = AVPUrlSource().url(with: "https://alivc-demo-vod.aliyuncs.com/7324abc905c7431f885f168846876dd3/7cd3b03f315f6d40b9323274bfcd7527-fd.mp4")
//        self.player?.setUrlSource(urlSource)
//        
//        self.player?.prepare()
//        self.player?.start()
//    }
//    
//    // 点播VidAuth播放
//    func vidAuthPlay() {
//        let vidSource = AVPVidAuthSource()
//        // 必选参数，视频ID（VideoId）
//        vidSource.vid = "xxxx"
//        // 必选参数，播放凭证，需要调用点播服务的GetVideoPlayAuth接口生成。
//        vidSource.playAuth = "xxxxxx"
//        // 必选参数，点播服务的接入地域，默认为cn-shanghai
//        vidSource.region = "xxxxxxxxxx"
//        self.player?.setAuthSource(vidSource)
//        
//        self.player?.prepare()
//        self.player?.start()
//    }
//    
//    func setupUI() {
//        view.backgroundColor = .white
//        view.addSubview(playerView)
//    }
}


//extension AliPlayerViewController: AVPDelegate {
// 
//    func onError(_ player: AliPlayer!, errorModel: AVPErrorModel!) {
//        
//    }
//    
//    func onPlayerStatusChanged(_ player: AliPlayer!, oldStatus: AVPStatus, newStatus: AVPStatus) {
//        switch newStatus {
//        case AVPStatusPrepared:
//            print("准备完成")
//        case AVPStatusStarted:
//            print("正在播放")
//        default:
//            break
//        }
//    }
//    
//    func onPlayerEvent(_ player: AliPlayer!, eventType: AVPEventType) {
//        switch eventType {
//        case AVPEventPrepareDone:
//            // 时长
//            print("duration: \(self.player?.duration ?? 0)")
//        default:
//            break
//        }
//    }
//    
//    func onCurrentPositionUpdate(_ player: AliPlayer!, position: Int64) {
//        // 当前进度
//        print("current position: \(position)")
//    }
//    
//    func onBufferedPositionUpdate(_ player: AliPlayer!, position: Int64) {
//        // 缓冲进度
//        print("Buffered position: \(position)")
//    }
//    
//    func onTrackReady(_ player: AliPlayer!, info: [AVPTrackInfo]!) {
//        
//    }
//    
//    func onSubtitleShow(_ player: AliPlayer!, trackIndex: Int32, subtitleID: Int, subtitle: String!) {
//        
//    }
//    
//    func onSubtitleHide(_ player: AliPlayer!, trackIndex: Int32, subtitleID: Int) {
//        
//    }
//    
//    func onCaptureScreen(_ player: AliPlayer!, image: UIImage!) {
//        
//    }
//    
//    func onTrackChanged(_ player: AliPlayer!, info: AVPTrackInfo!) {
//        
//    }
//    
//}
