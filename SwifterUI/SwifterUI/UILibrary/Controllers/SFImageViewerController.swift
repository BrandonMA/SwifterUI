//
//  SFImageViewerController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 18/02/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit


public protocol SFImageViewerControllerDelegate: class {
    
    // MARK: - Instance Methods
    
    func willDismiss()
    
}

public extension SFImageViewerControllerDelegate {
    
    // MARK: - Instance Methods
    
    public func willDismiss() {
    }
    
}

open class SFImageViewerController: SFViewController, UIScrollViewDelegate {
    
    // MARK: - Instance Properties
    
    open weak var delegate: SFImageViewerControllerDelegate? = nil
    
    open lazy var imageViewer: SFImageViewer = {
        let imageViewer = SFImageViewer()
        imageViewer.translatesAutoresizingMaskIntoConstraints = false
        return imageViewer
    }()
    
    // MARK: - Instance Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageViewer)
        imageViewer.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewDidTouch)))
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageViewer.clipEdges()
    }
    
    @objc private func imageViewDidTouch() {
        delegate?.willDismiss()
        dismiss(animated: true, completion: nil)
    }
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewer.imageView
    }
    
}
