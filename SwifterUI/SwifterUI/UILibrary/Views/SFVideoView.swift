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
    
    func prepare(mediaController: UIViewController) {
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

    private func createPlayer(with url: URL) {
        let player = AVPlayer(url: url)
        player.automaticallyWaitsToMinimizeStalling = false
        controller.player = player
    }

    private func startVideoController() {
        addSubview(controller.view)
        controller.view.clipSides()
        delegate?.prepare(mediaController: controller)
    }

    public final func setVideo(with url: URL?) {
        DispatchQueue.global(qos: .background).async {
            guard let url = url else { return }
            self.createPlayer(with: url)
            DispatchQueue.main.async {
                self.startVideoController()
            }
        }
    }
    
    public final func cleanView() {
        controller.view.removeFromSuperview()
        controller.player = nil
        controller.removeFromParent()
    }
    
    public override func removeFromSuperview() {
        cleanView()
        super.removeFromSuperview()
    }
    
    public override func updateColors() {
        backgroundColor = .clear
    }

}
