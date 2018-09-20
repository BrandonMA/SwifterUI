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
        addChild(mediaController)
        mediaController.didMove(toParent: self)
    }
}


public final class SFVideoView: SFView {

    // MARK: - Instance Properties

    private final var controller = AVPlayerViewController()

    public final weak var delegate: SFVideoPlayerDelegate?
    
    // MARK: - Initializer

    public override init(automaticallyAdjustsColorStyle: Bool = true, useAlternativeColors: Bool = false, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, useAlternativeColors: useAlternativeColors, frame: frame)
        controller.allowsPictureInPicturePlayback = true
        controller.entersFullScreenWhenPlaybackBegins = true
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance Methods

    public final func setVideo(with url: URL?) {
        
        DispatchQueue.global(qos: .background).async {
            guard let url = url else { return }
            let player = AVPlayer(url: url)
            player.automaticallyWaitsToMinimizeStalling = false
            self.controller.player = player
            
            DispatchQueue.main.async {
                self.addSubview(self.controller.view)
                self.controller.view.translatesAutoresizingMaskIntoConstraints = false
                self.controller.view.clipSides()
                self.delegate?.prepare(mediaController: self.controller)
            }
        }
    }
    
    public final func cleanView() {
        self.controller.view.removeFromSuperview()
        controller.player = nil
        controller.removeFromParent()
    }
    
    public override func removeFromSuperview() {
        cleanView()
        super.removeFromSuperview()
    }

}


