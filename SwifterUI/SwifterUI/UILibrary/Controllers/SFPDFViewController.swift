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
        return view
    }()
    
    var pdfURL: URL!
    
    // MARK: - Initializers
    
    public init(data: Data, automaticallyAdjustsColorStyle: Bool = true) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(UUID().uuidString)
        FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
        pdfURL = URL(fileURLWithPath: path)
        pdfView.document = PDFDocument(url: pdfURL)
    }
    
    public init(url: URL, automaticallyAdjustsColorStyle: Bool = true) {
        self.pdfURL = url
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        pdfView.document = PDFDocument(url: pdfURL)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func viewWillPrepareSubViews() {
        view.addSubview(pdfView)
        pdfView.autoScales = true
        super.viewWillPrepareSubViews()
    }
    
    open override func viewWillSetConstraints() {
        pdfView.clipSides()
        super.viewWillSetConstraints()
    }
    
    open override func prepare(navigationController: UINavigationController) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonDidTouch))
    }
    
    @objc public final func shareButtonDidTouch() {
        let activityViewController = UIActivityViewController(activityItems: [pdfURL as Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view // iPads won't crash
        present(activityViewController, animated: true, completion: nil)
    }
}
