//
//  SFVideoView.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 25/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import AVKit

open class SFVideoView: SFView {
    
    // MARK: - Instance Properties
    
    private var videoView: UIView? = nil
//    private var youtubeView: YouTubePlayerView? = nil
    open var url: URL? = nil //{ didSet { prepareVideoView() } }
//    open var youtubeURL: URL? = nil { didSet { prepareYoutubeView() } }
    open weak var delegate: SFVideoPlayerDelegate? = nil
    
    // MARK: - Instance Methods
    
    open func prepareVideoView() {
        
        guard let url = self.url else {
            self.videoView?.removeFromSuperview()
            return
        }
        
        let controller = AVPlayerViewController()
        let player = AVPlayer(url: url)
        controller.player = player
        controller.allowsPictureInPicturePlayback = true
        controller.entersFullScreenWhenPlaybackBegins = true
        delegate?.prepare(mediaController: controller)
        videoView = controller.view
        addSubview(videoView!)
        videoView?.clipEdges()
    }
    
//    private func prepareYoutubeView() {
//        youtubeView = YouTubePlayerView()
//        guard let youtubeURL = self.youtubeURL else {
//            self.youtubeView.removeFromSuperview()
//            return
//        }
//        youtubeView.loadVideoURL(youtubeURL)
//        youtubeView?.clipEdges()
//    }
    
}

