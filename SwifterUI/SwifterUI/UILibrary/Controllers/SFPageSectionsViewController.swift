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
    
    var viewAnimator = UIViewPropertyAnimator()
    
    open var titles: [String] = []
    private var isSelecting: Bool = false
    
    open lazy var pageBar: SFPageBar = {
        let pageBar = SFPageBar(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle, items: viewControllers.count)
        pageBar.scrollVertically = false
        pageBar.barDelegate = self
        return pageBar
    }()
    
    // MARK: - Instance Methods
    
    open override func viewWillPrepareSubViews() {
        super.viewWillPrepareSubViews()
        pageView.delegate = self
        view.addSubview(pageBar)
        view.clipsToBounds = true
        pageBar.buttons.enumerated().forEach { (index, button) in
            button.title = titles[index]
        }
    }
    
    open override func viewWillSetConstraints() {
        pageBar.clipSides(exclude: [.bottom])
        pageBar.setHeight(SFDimension(value: 44))
        pageView.clipTop(to: .bottom, of: pageBar)
        pageView.clipSides(exclude: [.top])
        super.viewWillSetConstraints()
    }
    
    override func add(viewController: SFViewController) {
        guard let title = viewController.title else { return }
        titles.append(title)
        super.add(viewController: viewController)
    }
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
