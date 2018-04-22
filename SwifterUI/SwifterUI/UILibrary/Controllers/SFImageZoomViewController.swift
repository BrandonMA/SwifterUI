//
//  SFImageZoomViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 29/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public final class SFImageZoomViewController: SFViewController {
    
    // MARK: - Instance Properties

    public final lazy var imageZoomView: SFImageZoomView = {
        let view = SFImageZoomView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.minimumZoomScale = 0
        view.maximumZoomScale = 10
        view.zoomScale = 0
        view.delegate = self
        view.imageView.image = self.image
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()
    
    private var minimumZoomScale: CGFloat {
        let widthScale = view.bounds.width / image.size.width
        let heightScale = view.bounds.height / image.size.height
        return CGFloat.minimum(widthScale, heightScale)
    }

    public final var image: UIImage
    
    // MARK: - Initializers

    public init(with image: UIImage) {
        self.image = image
        super.init(automaticallyAdjustsColorStyle: true)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instace Methods

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageZoomView)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
        imageZoomView.contentSize = image.size
        statusBarIsHidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFAssets.imageOfShareIcon, style: .done, target: self, action: #selector(shareButtonDidTouch))
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageZoomView.clipTop(to: .top, useSafeArea: false)
        imageZoomView.clipRight(to: .right)
        imageZoomView.clipBottom(to: .bottom)
        imageZoomView.clipLeft(to: .left)
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        centerImage(with: minimumZoomScale)
        imageZoomView.zoomScale = minimumZoomScale
        imageZoomView.minimumZoomScale = minimumZoomScale
    }
    
    private func centerImage(with scale: CGFloat) {
        let imageVirtualHeight = image.size.height * scale
        let topInset = ((view.bounds.height - imageVirtualHeight) / 2)
        imageZoomView.contentInset.top = topInset > 0 ? topInset : 0
    }
    
    private func hideNavigationBarIfNeeded() {
        if imageZoomView.zoomScale != minimumZoomScale {
            navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    @objc public final func zoomOut() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc public final func shareButtonDidTouch() {
        // set up activity view controller
        let imageToShare = [self.image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension SFImageZoomViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        centerImage(with: scrollView.zoomScale)
        hideNavigationBarIfNeeded()
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageZoomView.imageView
    }
}
