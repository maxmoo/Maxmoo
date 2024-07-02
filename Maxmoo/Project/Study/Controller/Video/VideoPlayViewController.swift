//
//  VideoPlayViewController.swift
//  Maxmoo
//
//  Created by 程超 on 2024/5/8.
//

import UIKit

class VideoPlayViewController: UIViewController {
    private let player = FFPlayer.init()
    private let playView: XDXPreviewView = {
        let pv = XDXPreviewView(frame: CGRect(x: 0, y: 100, width: kScreenWidth, height: (9.0/16.0) * kScreenWidth))
        pv.backgroundColor = .green
        return pv
    }()
//    private let toolBar = ToolBarView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        if let url = Bundle.main.path(forResource: "i-see-fire", ofType: "mp4") {
            _ = self.player.play(url: url, enableHWDecode: true)
        }
        self.view.addSubview(self.player.displayRender)
        self.player.displayRender.backgroundColor = .black
        self.player.displayRender.frame = CGRect(x: 0, y: 100, width: kScreenWidth, height: (9.0/16.0) * kScreenWidth)
        
//        self.view.addSubview(toolBar)
//        self.toolBar.frame = self.player.displayRender.frame;
//        self.toolBar.delegate = self
        self.player.ffPlayerDelegate = self
        
        view.addSubview(playView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.player.resume()
    }
    
}

extension VideoPlayViewController: FFPlayerProtocol {
    func playerReadyToPlay(_ duration: Float) {
        print("[video play] duration: \(duration)")
    }
    
    func playerCurrentTime(_ currentTime: Float) {
        print("[video play] currentTime: \(currentTime)")
    }
    
    func playerStateChanged(_ state: FFPlayState) {
        print("[video play] state: \(state)")
    }
    
    func playerAVFrame(frame: AVFrame) {
        var useFrame = frame
//        playView.displayAV(&useFrame)
    }
    
//    func seekTo(_ time: Float) {
//        self.player.seekTo(time)
//    }
//    func togglePlayAction() {
//        if self.player.playState() == .pause {
//            self.player.resume()
//        } else if self.player.playState() == .playing {
//            self.player.pause()
//        }
//    }
//    func pause() {
//        self.player.pause()
//    }
}
