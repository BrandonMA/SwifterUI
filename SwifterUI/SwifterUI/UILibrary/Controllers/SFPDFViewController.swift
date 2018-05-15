//
//  SFPDFViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 15/05/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit
import PDFKit

open class SFPDFViewController: SFViewController {
    
    // MARK: - Instance Properties
    
    public lazy var pdfView: PDFView = {
        let view = PDFView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Instance Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pdfView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SFAssets.imageOfShareIcon, style: .done, target: self, action: #selector(shareButtonDidTouch))
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pdfView.clipEdges()
    }
    
    @objc public final func shareButtonDidTouch() {
        // set up activity view controller
        guard let document = pdfView.document else { return }
        let documents = [document]
        let activityViewController = UIActivityViewController(activityItems: documents, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}
