//
//  RecorderViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/5/10.
//

import UIKit
import MediaPlayer
import AVKit

class RecorderViewController: UIViewController {

    lazy var startButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 100, width: 100, height: 50))
        button.centerX = kScreenWidth / 2
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(startRecorder), for: .touchUpInside)
        button.setTitle("strat", for: .normal)
        return button
    }()
    
    lazy var stopButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 200, width: 100, height: 50))
        button.centerX = kScreenWidth / 2
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(stopRecorder), for: .touchUpInside)
        button.setTitle("stop", for: .normal)
        return button
    }()
    
    lazy var contentView: UIView = {
        let vv = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        vv.backgroundColor = .lightGray
        return vv
    }()
    
    lazy var moveView: UIView = {
        let ve = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        ve.backgroundColor = .purple
        return ve
    }()
    
    lazy var recorder: ZYSScreenRecorder = {
        let re = ZYSScreenRecorder()
        re.captureView = contentView
        re.frameRate = 25
        return re
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: contentView.bounds)
        imageView.image = UIImage(named: "screen")
        imageView.backgroundColor = .red
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .link
        
        view.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(moveView)
        
        view.addSubview(startButton)
        view.addSubview(stopButton)

    }

    @objc
    func startRecorder() {
//        SMScreenRecording.shareManager().start(withScreenView: self.contentView) { error in
//            
//        }
        recorder.startRecording()
    }
    
    @objc
    func stopRecorder() {
//        SMScreenRecording.shareManager().end { error, path in
//            if let path {
//                let playerController = AVPlayerViewController()
//                playerController.showsPlaybackControls = true
//                playerController.player = AVPlayer(url: NSURL(fileURLWithPath: path) as URL)
//                playerController.player?.play()
//                self.present(playerController, animated: true)
//            }
//        }
        recorder.stopRecording { [weak self] path in
            guard let self else { return }
            if let path {
                self.playPath(path: path)
            }
        }
    }
    
    func playPath(path: String) {
        let playerController = AVPlayerViewController()
        playerController.showsPlaybackControls = true
        playerController.player = AVPlayer(url: NSURL(fileURLWithPath: path) as URL)
        playerController.player?.play()
        self.present(playerController, animated: true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point:CGPoint = (event?.allTouches?.first?.location(in: self.contentView))!
        moveView.center = point
    }
}
