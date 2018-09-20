//
//  SFPageViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 13/06/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFPageViewController: SFViewController {
    
    // MARK: - Instance Properties
    
    open var pageView: SFPageView
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, viewControllers: [SFViewController]) {
        pageView = SFPageView(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        pageView.translatesAutoresizingMaskIntoConstraints = false
        pageView.scrollVertically = false
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        add(viewControllers: viewControllers)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pageView)
        pageView.clipSides()
    }
    
    func add(viewController: SFViewController) {
        guard let view = viewController.view else { return }
        addChild(viewController)
        pageView.add(view: view)
    }
    
    func add(viewControllers: [SFViewController]) {
        viewControllers.forEach({ add(viewController: $0) })
    }
}
