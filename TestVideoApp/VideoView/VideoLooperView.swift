//
//  VideoLooperView.swift
//  TestVideoApp
//
//  Created by Станислав Климов on 24.09.2020.
//

import UIKit
import AVFoundation

class VideoLooperView: UIView {

    let videos: [URL]
    let videoPlayerView = VideoPlayerView()
    @objc private let player = AVQueuePlayer()
    private var token: NSKeyValueObservation?
    
    init(videos: [URL]) {
        self.videos = videos
        super.init(frame:.zero)
        initializePlayer()
    }
    
    override func layoutSubviews() {
        addSubview(videoPlayerView)
        videoPlayerView.frame = bounds
    }
    
    func play() {
        player.play()
    }
    
    private func initializePlayer() {
        videoPlayerView.player = player
        addAllVideosToPlayer()
        player.volume = 0.0
        player.play()
        token = player.observe(\.currentItem, changeHandler: { (player, _) in
            if self.player.items().count == 1 {
                self.addAllVideosToPlayer()
            }
        })
    }
    
    private func addAllVideosToPlayer() {
        for video in videos {
            let asset = AVURLAsset(url: video)
            let item = AVPlayerItem(asset: asset)
            player.insert(item, after: player.items().last)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

