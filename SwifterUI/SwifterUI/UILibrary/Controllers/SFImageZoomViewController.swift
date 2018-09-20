//
//  SFImageZoomViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 29/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public final class SFImageViewController: SFViewController {
    
    // MARK: - Instance Properties

    public final lazy var imageZoomView: SFImageZoomView = {
        let view = SFImageZoomView()
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

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageZoomView)
        imageZoomView.clipTop(to: .top, useSafeArea: false)
        imageZoomView.clipSides(exclude: [.top])
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageDidTap)))
        imageZoomView.contentSize = image.size
    }
    
    public override func prepare(navigationController: UINavigationController) {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonDidTouch))
        
        if navigationController.viewControllers.first == self {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        }
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageZoomView.minimumZoomScale = minimumZoomScale
        if imageZoomView.zoomScale == 1 {
            imageZoomView.zoomScale = minimumZoomScale
        }
    }
    
    private func centerImage(with scale: CGFloat) {
        let imageVirtualHeight = image.size.height * scale
        let topInset = ((view.bounds.height - imageVirtualHeight) / 2)
        imageZoomView.contentInset.top = topInset > 0 ? topInset : 0
    }
    
    private func hideNavigationBarIfNeeded() {
        if imageZoomView.zoomScale != minimumZoomScale {
            navigationController?.setNavigationBarHidden(true, animated: true)
            statusBarIsHidden = true
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
            statusBarIsHidden = false
        }
    }
    
    @objc final func imageDidTap() {
        guard let navigationController = self.navigationController else { return }
        let hidden = !navigationController.navigationBar.isHidden
        navigationController.setNavigationBarHidden(hidden, animated: true)
        statusBarIsHidden = hidden
    }
    
    @objc final func dismissViewController() {
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

extension SFImageViewController: UIScrollViewDelegate {
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage(with: scrollView.zoomScale)
        hideNavigationBarIfNeeded()
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageZoomView.imageView
    }
}
