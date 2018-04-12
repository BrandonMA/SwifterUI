//
//  SFVideoView.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 25/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import AVKit

public protocol SFVideoPlayerDelegate: class {
    
    // MARK: - Instance Methods
    
    func prepare(mediaController: UIViewController)
}

public extension SFVideoPlayerDelegate where Self: UIViewController {
    
    // MARK: - Instance Methods
    
    public func prepare(mediaController: UIViewController) {
        mediaController.didMove(toParentViewController: self)
        self.addChildViewController(mediaController)
    }
}


public final class SFVideoView: SFView {

    // MARK: - Instance Properties

    public final var videoView: UIView? = nil

    public final var url: URL? = nil {
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

    public final var controller = AVPlayerViewController()

    public final var player: AVPlayer? {
        didSet {
            DispatchQueue.addAsyncTask(to: .main) {
                self.controller.player = self.player
                self.prepareVideoView()
            }
        }
    }

    public final weak var delegate: SFVideoPlayerDelegate? = nil

    public override init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        controller.allowsPictureInPicturePlayback = true
        controller.entersFullScreenWhenPlaybackBegins = true
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance Methods

    public final func prepareVideoView() {
        delegate?.prepare(mediaController: controller)
        videoView = controller.view
        addSubview(videoView!)
        videoView?.clipEdges()
    }

}


