//
//  UIView.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UIView {
    
    public func getAllConstraints() -> Constraints {
        
        var constraints: Constraints = []
        
        constraints.append(contentsOf: self.constraints)
        
        guard let superview = superview else { return constraints }
        
        superview.constraints.forEach { (constraint) in
            guard let view = constraint.firstItem as? UIView else { return }
            if view === self {
                constraints.append(constraint)
            }
        }
        return constraints
    }
    
    public func get(constraintType: ConstraintType) -> Constraint? {
        let constraints = getAllConstraints()
        for constraint in constraints {
            if constraint.identifier == constraintType.rawValue {
                return constraint
            }
        }
        return nil
    }
    
    public func remove(constraintType: ConstraintType) {
        guard let oldConstraint = get(constraintType: constraintType) else { return }
        guard let superview = superview else { return }
        removeConstraint(oldConstraint)
        superview.removeConstraint(oldConstraint)
    }
    
    public func removeAllConstraints() {
        let constraints = getAllConstraints()
        guard let superview = superview else { return }
        constraints.forEach { (constraint) in
            self.removeConstraint(constraint)
            superview.removeConstraint(constraint)
        }
    }
    
    private func getAnchorView(view: UIView?) -> UIView? {
        if let view = view { return view }
        else if let superview = superview  { return superview }
        else { return nil }
    }
    
    // MARK: - Sizing
    
    @discardableResult
    private func size(childAnchor: NSLayoutDimension, parentAnchor: NSLayoutDimension, dimension: SFDimension) -> Constraint {
        switch dimension.type {
        case .fraction:
            return childAnchor.constraint(equalTo: parentAnchor, multiplier: dimension.value)
        case .point:
            return childAnchor.constraint(equalToConstant: dimension.value)
        }
    }
    
    public func height(_ height: SFDimension? = nil, comparedTo view: UIView? = nil) {
        
        guard let anchorView = getAnchorView(view: view) else { fatalError("You didn't set a relative view or superview isn't available") }
        
        let heightConstraint: Constraint
        
        if let height = height {
            heightConstraint = size(childAnchor: heightAnchor, parentAnchor: anchorView.heightAnchor, dimension: height)
        } else {
            heightConstraint = heightAnchor.constraint(equalTo: anchorView.heightAnchor, multiplier: 1)
        }
        
        heightConstraint.set(active: true).set(identifier: ConstraintType.height.rawValue)
    }
    
    public func width(_ width: SFDimension? = nil, comparedTo view: UIView? = nil) {
        
        guard let anchorView = getAnchorView(view: view) else { fatalError("You didn't set a relative view or superview isn't available") }
        
        let widthConstraint: Constraint
        
        if let width = width {
            widthConstraint = size(childAnchor: widthAnchor, parentAnchor: anchorView.widthAnchor, dimension: width)
        } else {
            widthConstraint = widthAnchor.constraint(equalTo: anchorView.widthAnchor, multiplier: 1)
        }
        
        widthConstraint.set(active: true).set(identifier: ConstraintType.width.rawValue)
        
    }
    
    // MARK: - Center
    
    public func center(axis: [ConstraintAxis] = [.x, .y], in view: UIView? = nil, offSet: CGPoint = .zero) {
        
        guard let anchorView = getAnchorView(view: view) else { fatalError("You didn't set a relative view or superview isn't available") }
        var constraints: Constraints = []
        
        if axis.contains(.x) {
            constraints.append(centerXAnchor.constraint(equalTo: anchorView.centerXAnchor, constant: offSet.x).set(identifier: ConstraintType.centerX.rawValue))
        }
        if axis.contains(.y) {
            constraints.append(centerYAnchor.constraint(equalTo: anchorView.centerYAnchor, constant: offSet.y).set(identifier: ConstraintType.centerY.rawValue))
        }
        
        constraints.active()
    }
    
    // MARK: - Clip individual edges
    
    @discardableResult
    private func clipEdge<Anchor>(childAnchor: NSLayoutAnchor<Anchor>, parentAnchor: NSLayoutAnchor<Anchor>, margin: CGFloat = 0, relation: ConstraintRelation = .equal) -> Constraint {
        switch relation {
        case .equal:
            return childAnchor.constraint(equalTo: parentAnchor, constant: margin).set(active: true)
        case .greater:
            return childAnchor.constraint(greaterThanOrEqualTo: parentAnchor, constant: margin).set(active: true)
        case .less:
            return childAnchor.constraint(lessThanOrEqualTo: parentAnchor, constant: margin).set(active: true)
        }
    }
    
    @discardableResult
    private func clipYAxisAnchor(childAnchor: NSLayoutYAxisAnchor, to edge: ConstraintEdge, of view: UIView? = nil, margin: CGFloat = 0, relation: ConstraintRelation = .equal, useSafeArea: Bool) -> Constraint? {
        guard let anchorView = getAnchorView(view: view) else { fatalError("You didn't set a relative view or superview isn't available") }
        switch edge {
        case .top:
            return clipEdge(childAnchor: childAnchor, parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.topAnchor : anchorView.topAnchor, margin: margin, relation: relation)
        case .bottom:
            return clipEdge(childAnchor: childAnchor, parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.bottomAnchor : anchorView.bottomAnchor, margin: margin, relation: relation)
        case .centerY:
            return clipEdge(childAnchor: childAnchor, parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.centerYAnchor :
                anchorView.centerYAnchor, margin: margin, relation: relation)
        default:
            print("You can't constraint a bottom anchor to a right/left/leading/trailing anchor")
            return nil
        }
    }
    
    @discardableResult
    private func clipXAxisAnchor(childAnchor: NSLayoutXAxisAnchor, to edge: ConstraintEdge, of view: UIView? = nil, margin: CGFloat = 0, relation: ConstraintRelation = .equal, useSafeArea: Bool) -> Constraint? {
        guard let anchorView = getAnchorView(view: view) else { fatalError("You didn't set a relative view or superview isn't available") }
        switch edge {
        case .right:
            return clipEdge(childAnchor: childAnchor, parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.rightAnchor :
                anchorView.rightAnchor, margin: margin, relation: relation)
        case .left:
            return clipEdge(childAnchor: childAnchor, parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.leftAnchor :
                anchorView.leftAnchor, margin: margin, relation: relation)
        case .centerX:
            return clipEdge(childAnchor: childAnchor, parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.centerXAnchor : anchorView.centerXAnchor, margin: margin, relation: relation)
        default:
            print("You can't constraint a right anchor to a top/bottom anchor")
            return nil
        }
    }
    
    public func clipTop(to edge: ConstraintEdge, of view: UIView? = nil, margin: CGFloat = 0, relation: ConstraintRelation = .equal, useSafeArea: Bool = false) {
        clipYAxisAnchor(childAnchor: topAnchor, to: edge, of: view, margin: margin, relation: relation, useSafeArea: useSafeArea)?.set(identifier: ConstraintType.top.rawValue)
    }
    
    public func clipRight(to edge: ConstraintEdge, of view: UIView? = nil, margin: CGFloat = 0, relation: ConstraintRelation = .equal, useSafeArea: Bool = false) {
        let margin = margin * -1
        clipXAxisAnchor(childAnchor: rightAnchor, to: edge, of: view, margin: margin, relation: relation, useSafeArea: useSafeArea)?.set(identifier: ConstraintType.right.rawValue)
    }
    
    public func clipBottom(to edge: ConstraintEdge, of view: UIView? = nil, margin: CGFloat = 0, relation: ConstraintRelation = .equal, useSafeArea: Bool = false) {
        let margin = margin * -1
        clipYAxisAnchor(childAnchor: bottomAnchor, to: edge, of: view, margin: margin, relation: relation, useSafeArea: useSafeArea)?.set(identifier: ConstraintType.bottom.rawValue)
    }
    
    public func clipLeft(to edge: ConstraintEdge, of view: UIView? = nil, margin: CGFloat = 0, relation: ConstraintRelation = .equal, useSafeArea: Bool = false) {
        clipXAxisAnchor(childAnchor: leftAnchor, to: edge, of: view, margin: margin, relation: relation, useSafeArea: useSafeArea)?.set(identifier: ConstraintType.left.rawValue)
    }
    
    // MARK: - Clip multiple edges
    
    public func clipEdges(to view: UIView? = nil, margin: ConstraintMargin = .zero, exclude: [ConstraintEdge] = [], useSafeArea: Bool = false) {
        
        if exclude.contains(.top) == false {
            clipTop(to: .top, of: view, margin: margin.top, useSafeArea: useSafeArea)
        }
        
        if exclude.contains(.right) == false {
            clipRight(to: .right, of: view, margin: margin.right, useSafeArea: useSafeArea)
        }
        
        if exclude.contains(.bottom) == false {
            clipBottom(to: .bottom, of: view, margin: margin.bottom, useSafeArea: useSafeArea)
        }
        
        if exclude.contains(.left) == false {
            clipLeft(to: .left, of: view, margin: margin.left, useSafeArea: useSafeArea)
        }
        
    }
}

























