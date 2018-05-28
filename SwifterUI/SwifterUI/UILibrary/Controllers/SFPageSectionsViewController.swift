//
//  SFPageViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 04/05/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFPageSectionsViewController: SFViewController {
    
    // MARK: - Instance Properties
    
    open var titles: [String] = []
    open var views: [UIView] = []
    
    open lazy var pageBar: SFPageBar = {
        let view = SFPageBar(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.scrollVertically = false
        view.barDelegate = self
        return view
    }()
    
    open lazy var pageView: SFPageView = {
        let view = SFPageView(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.scrollVertically = false
        view.delegate = self
        return view
    }()
    
    // MARK: - Initializers
    
    public init(automaticallyAdjustsColorStyle: Bool = true, viewControllers: [SFViewController]) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle)
        for controller in viewControllers {
            addChildViewController(controller)
            guard let title = controller.title else { continue }
            guard let view = controller.view else { continue }
            titles.append(title)
            views.append(view)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pageBar)
        view.addSubview(pageView)
        pageBar.configure(with: titles)
        pageView.configure(with: views)
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pageBar.clipEdges(exclude: [.bottom])
        pageBar.height(SFDimension(value: 36))
        pageView.clipTop(to: .bottom, of: pageBar)
        pageView.clipEdges(exclude: [.top])
    }
    
}

extension SFPageSectionsViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var newIndex = floor(scrollView.contentOffset.x / scrollView.bounds.width)
        if Int(newIndex) != pageBar.selectedIndex {
            newIndex = newIndex < 0 ? 0 : newIndex
            pageBar.select(index: Int(newIndex))
        }
    }
}

extension SFPageSectionsViewController: SFPageBarDelegate {
    public func didSelect(index: Int) {
        let offSet = pageView.bounds.width * CGFloat(index)
        pageView.setContentOffset(CGPoint(x: offSet, y: 0), animated: true)
    }
}





















