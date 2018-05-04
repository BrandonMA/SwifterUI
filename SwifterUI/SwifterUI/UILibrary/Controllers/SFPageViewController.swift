//
//  SFPageViewController.swift
//  SwifterUI
//
//  Created by brandon maldonado alonso on 04/05/18.
//  Copyright © 2018 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public protocol SFPageBarDelegate: class {
    func didSelect(index: Int)
}

open class SFPageBar: SFScrollView {
    
    open var titles: [String] = []
    open var selectedIndex = 0
    open lazy var buttons: [SFButton] = []
    open weak var barDelegate: SFPageBarDelegate?
    
    open lazy var buttonStackView: SFStackView = {
        let stackView = SFStackView(arrangedSubviews: buttons)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        contentView.addSubview(buttonStackView)
        showsHorizontalScrollIndicator = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configure(with titles: [String]) {
        self.titles = titles
        self.buttons = titles.enumerated().map({ (index, title) -> SFButton in
            let button = SFButton(automaticallyAdjustsColorStyle: self.automaticallyAdjustsColorStyle)
            button.addTarget(self, action: #selector(didTouch(sfbutton:)), for: .touchUpInside)
            button.setTitle(title, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.useClearColor = true
            button.titleLabel?.alpha = selectedIndex == index ? 1 : 0.7
            buttonStackView.addArrangedSubview(button)
            return button
        })
    }
    
    open override func layoutIfBoundsChanged() {
        super.layoutIfBoundsChanged()
        buttonStackView.clipEdges(margin: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        contentView.clipBottom(to: .bottom, of: buttonStackView)
    }
    
    @objc open func didTouch(sfbutton: UIButton) {
        buttons.enumerated().forEach { (index, button) in
            if sfbutton == button {
                selectedIndex = index
            }
        }
        barDelegate?.didSelect(index: selectedIndex)
        select(index: selectedIndex)
    }
    
    open func select(index: Int) {
        selectedIndex = index
        buttons.enumerated().forEach { (index, button) in
            UIView.animate(withDuration: 0.4, animations: {
                button.titleLabel?.alpha = self.selectedIndex == index ? 1 : 0.7
            })
        }
    }
}

open class SFPageView: SFScrollView {
    
    open var selectedIndex = 0
    open lazy var views: [UIView] = []
    open lazy var viewsStackView: SFStackView = {
        let stackView = SFStackView(arrangedSubviews: views)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .horizontal
        return stackView
    }()
    
    public override init(automaticallyAdjustsColorStyle: Bool = true, frame: CGRect = .zero) {
        super.init(automaticallyAdjustsColorStyle: automaticallyAdjustsColorStyle, frame: frame)
        contentView.addSubview(viewsStackView)
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configure(with views: [UIView]) {
        self.views = views
        views.enumerated().forEach { (index, view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = index % 2 == 0 ? UIColor.red : UIColor.blue
            viewsStackView.addArrangedSubview(view)
            view.width(SFDimension(type: .fraction, value: 1), comparedTo: self)
        }
    }
    
    open override func layoutIfBoundsChanged() {
        super.layoutIfBoundsChanged()
        viewsStackView.clipEdges(exclude: [.bottom])
        contentView.clipBottom(to: .bottom, of: viewsStackView)
    }
    
}

open class SFPageViewController: SFViewController {
    
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
        pageBar.height(SFDimension(value: 48))
        pageView.clipTop(to: .bottom, of: pageBar)
        pageView.clipLeft(to: .left)
        pageView.clipRight(to: .right)
        pageView.clipBottom(to: .bottom)
    }
    
}

extension SFPageViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == pageView {
            var newIndex = floor(scrollView.contentOffset.x / scrollView.bounds.width)
            newIndex = newIndex < 0 ? 0 : newIndex
            pageBar.select(index: Int(newIndex))
        }
    }
    
}

extension SFPageViewController: SFPageBarDelegate {
    public func didSelect(index: Int) {
        let offSet = pageView.bounds.width * CGFloat(index)
        pageView.setContentOffset(CGPoint(x: offSet, y: 0), animated: true)
    }
}





















