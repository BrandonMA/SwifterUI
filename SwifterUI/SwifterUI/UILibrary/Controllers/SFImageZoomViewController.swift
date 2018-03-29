//
//  SFImageZoomViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 29/03/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFImageZoomViewController: SFViewController {

    open lazy var imageZoomView: SFImageZoomView = {
        let view = SFImageZoomView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.minimumZoomScale = 0
        view.maximumZoomScale = 10
        view.zoomScale = 0
        view.delegate = self
        view.imageView.image = self.image
        return view
    }()

    open var image: UIImage

    public init(with image: UIImage) {
        self.image = image
        super.init(automaticallyAdjustsColorStyle: true)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public required init(automaticallyAdjustsColorStyle: Bool) {
        fatalError("init(automaticallyAdjustsColorStyle:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageZoomView)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
        statusBarIsHidden = true
        imageZoomView.contentSize = image.size
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageZoomView.clipEdges()
    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let widthScale = view.bounds.width / image.size.width
        let heightScale = view.bounds.height / image.size.height
        imageZoomView.zoomScale = CGFloat.minimum(widthScale, heightScale)
        imageZoomView.minimumZoomScale = CGFloat.minimum(widthScale, heightScale)
    }

    @objc open func zoomOut() {
        dismiss(animated: true, completion: nil)
    }
}

extension SFImageZoomViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageZoomView.imageView
    }
}
