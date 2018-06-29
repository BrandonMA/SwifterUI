//
//  SFPageViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 04/05/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

open class SFPageSectionsViewController: SFPageViewController {
    
    // MARK: - Instance Properties
    
    open var titles: [String] = []
    private var isSelecting: Bool = false
    
    open lazy var pageBar: SFPageBar = {
        let view = SFPageBar(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.scrollVertically = false
        view.barDelegate = self
        return view
    }()
    
    // MARK: - Instance Methods
    
    open override func loadView() {
        super.loadView()
        pageBar.configure(with: titles)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        pageView.delegate = self
        view.addSubview(pageBar)
    }
    
    open override func viewWillLayoutSubviews() {
        pageBar.clipEdges(exclude: [.bottom])
        pageBar.height(SFDimension(value: 44))
        pageView.clipTop(to: .bottom, of: pageBar)
        pageView.clipEdges(exclude: [.top])
    }
    
    open override func prepare(viewController: SFViewController) {
        super.prepare(viewController: viewController)
        guard let title = viewController.title else { return }
        titles.append(title)
    }
    
}

extension SFPageSectionsViewController: UIScrollViewDelegate {
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isSelecting = false
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 && isSelecting == false {
            var newIndex = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
            if newIndex != pageBar.selectedIndex {
                newIndex = newIndex < 0 ? 0 : newIndex
                pageBar.select(index: Int(newIndex))
            }
        }
    }
}

extension SFPageSectionsViewController: SFPageBarDelegate {
    public func didSelect(index: Int) {
        isSelecting = true
        let offSet = pageView.bounds.width * CGFloat(index)
        pageView.setContentOffset(CGPoint(x: offSet, y: 0), animated: true)
    }
}





















