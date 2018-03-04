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
    
    open var videoView: UIView? = nil
    
    open var url: URL? = nil {
        didSet {
            DispatchQueue.addAsyncTask(to: .background) {
                guard let url = self.url else {
                    DispatchQueue.addAsyncTask(to: .main, handler: {
                        self.videoView?.removeFromSuperview()
                    })
                    return
                }
                self.player = AVPlayer(url: url)
            }
        }
    }
    
    open var controller = AVPlayerViewController()
    
    open var player: AVPlayer? {
        didSet {
            DispatchQueue.addAsyncTask(to: .main) {
                self.controller.player = self.player
            }
        }
    }
    
    open weak var delegate: SFVideoPlayerDelegate? = nil
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        controller.allowsPictureInPicturePlayback = true
        controller.entersFullScreenWhenPlaybackBegins = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open func prepareVideoView() {
        delegate?.prepare(mediaController: controller)
        videoView = controller.view
        addSubview(videoView!)
        print(subviews.count)
        videoView?.clipEdges()
    }
    
}


