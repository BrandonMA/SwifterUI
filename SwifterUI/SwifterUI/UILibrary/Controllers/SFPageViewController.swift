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
        let view = SFPageView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.scrollVertically = false
        return view
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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pageView)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pageView.clipEdges()
    }
    
    func add(viewController: SFViewController) {
        guard let view = viewController.view else { return }
        addChildViewController(viewController)
        pageView.add(view: view)
    }
    
    func add(viewControllers: [SFViewController]) {
        viewControllers.forEach({ add(viewController: $0) })
    }
}
