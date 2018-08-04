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
        let view = SFPageBar(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, items: titles.count)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.scrollVertically = false
        view.barDelegate = self
        return view
    }()
    
    // MARK: - Instance Methods
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        pageView.delegate = self
        view.addSubview(pageBar)
        
        pageBar.buttons.enumerated().forEach { (index, button) in
            button.title = titles[index]
        }
    }
    
    open override func viewWillLayoutSubviews() {
        pageBar.clipEdges(exclude: [.bottom])
        pageBar.height(SFDimension(value: 44))
        pageView.clipTop(to: .bottom, of: pageBar)
        pageView.clipEdges(exclude: [.top])
    }
    
    override func add(viewController: SFViewController) {
        guard let title = viewController.title else { return }
        titles.append(title)
        super.add(viewController: viewController)
    }
    
    var viewAnimator = UIViewPropertyAnimator()
    var x: CGFloat = 0.0
}

extension SFPageSectionsViewController: UIScrollViewDelegate {
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isSelecting = false
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut, animations: {
        })
        viewAnimator.startAnimation()
        viewAnimator.pauseAnimation()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x > 0 && isSelecting == false {
            
            let scrollValue = scrollView.contentOffset.x / scrollView.bounds.width
            var newIndex = Int(round(scrollValue))
            
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





















