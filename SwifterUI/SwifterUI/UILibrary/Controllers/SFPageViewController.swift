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
    
    open lazy var pageView: SFPageView = {
        let pageView = SFPageView(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        pageView.scrollVertically = false
        return pageView
    }()
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, viewControllers: [SFViewController]) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        add(viewControllers: viewControllers)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func viewWillPrepareSubViews() {
        view.addSubview(pageView)
        super.viewWillPrepareSubViews()
    }
    
    open override func viewWillSetConstraints() {
        pageView.clipSides()
        super.viewWillSetConstraints()
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
