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
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pdfView.clipEdges()
    }
    
}
