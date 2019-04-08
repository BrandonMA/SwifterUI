//
//  UIView.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public enum SFLayoutError: String, Error {
    case noConstraint = "No constraint found"
}

extension NSLayoutDimension {
    func constraint(to anchor: NSLayoutDimension, dimension: SFDimension, relation: ConstraintRelation = .equal, margin: CGFloat = 0.0, priority: UILayoutPriority = UILayoutPriority.required) -> Constraint {
        let newConstraint: Constraint
        switch dimension.type {
            case .fraction:
                switch relation {
                case .equal: newConstraint = constraint(equalTo: anchor, multiplier: dimension.value, constant: margin)
                case .greater: newConstraint = constraint(greaterThanOrEqualTo: anchor, multiplier: dimension.value, constant: margin)
                case .less: newConstraint = constraint(lessThanOrEqualTo: anchor, multiplier: dimension.value, constant: margin)
                }
            case .point:
                switch relation {
                case .equal: newConstraint = constraint(equalToConstant: dimension.value)
                case .greater: newConstraint = constraint(greaterThanOrEqualToConstant: dimension.value)
                case .less: newConstraint = constraint(lessThanOrEqualToConstant: dimension.value)
                }
        }
        newConstraint.priority = priority
        return newConstraint
    }
}

public extension UIView {
    
    /**
     Return view passed or superview if they are not nil, throw if there is no anchor view.
     */
    private func getAnchorView(_ view: UIView?) -> UIView? {
        if let view = view {
            return view
        } else if let superview = superview {
            return superview
        } else {
            return nil
        }
    }
    
    // MARK: - Getting and Removing Constraints
    
    /**
     Return all constraints for the current view.
     */
    final func getAllConstraints() -> Constraints {
        
        var constraints: Constraints = []
        
        self.constraints.forEachConstraint(where: self) { (constraint) in
            constraints.append(constraint)
        }
        
        superview?.constraints.forEachConstraint(where: self, completion: { (constraint) in
            constraints.append(constraint)
        })
        
        return constraints
    }
    
    /**
     Remove all constraints for the current view.
     */
    final func removeAllConstraints() {
        guard let superview = superview else { return }
        let constraints = getAllConstraints()
        constraints.forEach { [unowned self] (constraint)  in
            self.removeConstraint(constraint)
            superview.removeConstraint(constraint)
        }
    }
    
    /**
     Return an specific constraint if it exists.
     */
    @discardableResult
    final func getConstraint(type constraintType: ConstraintType) -> Constraint? {
        
        var finalConstraint: Constraint?
        
        func check(constraint: Constraint) {
            if constraint.identifier == constraintType.rawValue {
                finalConstraint = constraint
                return
            }
        }
        
        constraints.forEachConstraint(where: self) { check(constraint: $0) }
        
        if finalConstraint == nil {
            superview?.constraints.forEachConstraint(where: self, completion: { check(constraint: $0) })
        }
        
        return finalConstraint
    }
    
    /**
     Remove an specific constraint if it exists.
     */
    final func removeConstraint(type constraintType: ConstraintType) {
        guard let oldConstraint = getConstraint(type: constraintType) else { return }
        self.removeConstraint(oldConstraint)
        self.superview?.removeConstraint(oldConstraint)
    }
    
    // MARK: - Sizing
    
    @discardableResult
    final func setHeight(_ height: SFDimension? = nil,
                             comparedTo view: UIView? = nil,
                             relation: ConstraintRelation = .equal,
                             margin: CGFloat = 0.0) -> Constraint {
        
        guard let anchorView = getAnchorView(view) else {
            debugPrint("\(self) You didn't set a relative view or superview isn't available")
            fatalError()
        }
        
        let heightConstraint: Constraint
        
        if let height = height {
            heightConstraint = heightAnchor.constraint(to: anchorView.heightAnchor, dimension: height, relation: relation, margin: margin)
        } else {
            heightConstraint = heightAnchor.constraint(equalTo: anchorView.heightAnchor, multiplier: 1)
            heightConstraint.priority = UILayoutPriority(rawValue: 999)
        }
        
        heightConstraint.set(active: true).set(identifier: ConstraintType.height.rawValue)
        return heightConstraint
    }
    
    @discardableResult
    final func setWidth(_ width: SFDimension? = nil,
                            comparedTo view: UIView? = nil,
                            relation: ConstraintRelation = .equal,
                            margin: CGFloat = 0.0) -> Constraint {
        
        guard let anchorView = getAnchorView(view) else {
            debugPrint("\(self) You didn't set a relative view or superview isn't available")
            fatalError()
        }
        
        let widthConstraint: Constraint
        
        if let width = width {
            widthConstraint = widthAnchor.constraint(to: anchorView.widthAnchor, dimension: width, relation: relation, margin: margin)
        } else {
            widthConstraint = widthAnchor.constraint(equalTo: anchorView.widthAnchor, multiplier: 1)
            widthConstraint.priority = UILayoutPriority(rawValue: 999)
        }
        
        widthConstraint.set(active: true).set(identifier: ConstraintType.width.rawValue)
        return widthConstraint
    }
    
    // MARK: - Clip individual edges
    
    @discardableResult
    private func clipEdge<Anchor>(childAnchor: NSLayoutAnchor<Anchor>,
                                  parentAnchor: NSLayoutAnchor<Anchor>,
                                  margin: CGFloat = 0,
                                  relation: ConstraintRelation = .equal) -> Constraint {
        switch relation {
        case .equal:
            let constraint = childAnchor.constraint(equalTo: parentAnchor, constant: margin)
            constraint.priority = UILayoutPriority(rawValue: 999)
            return constraint.set(active: true)
        case .greater:
            let constraint = childAnchor.constraint(greaterThanOrEqualTo: parentAnchor, constant: margin)
            constraint.priority = UILayoutPriority(rawValue: 999)
            return constraint.set(active: true)
        case .less:
            let constraint = childAnchor.constraint(lessThanOrEqualTo: parentAnchor, constant: margin)
            constraint.priority = UILayoutPriority(rawValue: 999)
            return constraint.set(active: true)
        }
    }
    
    @discardableResult
    private func clipYAxisAnchor(childAnchor: NSLayoutYAxisAnchor,
                                 to edge: ConstraintEdge,
                                 of view: UIView? = nil,
                                 margin: CGFloat = 0,
                                 relation: ConstraintRelation = .equal,
                                 useSafeArea: Bool) -> Constraint {
        
        guard let anchorView = getAnchorView(view) else {
            debugPrint("\(self) You didn't set a relative view or superview isn't available")
            fatalError()
        }
        
        switch edge {
        case .top:
            return clipEdge(childAnchor: childAnchor,
                            parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.topAnchor : anchorView.topAnchor,
                            margin: margin,
                            relation: relation)
        case .bottom:
            return clipEdge(childAnchor: childAnchor,
                            parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.bottomAnchor : anchorView.bottomAnchor,
                            margin: margin,
                            relation: relation)
        case .centerY:
            return clipEdge(childAnchor: childAnchor,
                            parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.centerYAnchor : anchorView.centerYAnchor,
                            margin: margin,
                            relation: relation)
        default:
            debugPrint("You can't constraint a bottom anchor to a right/left/leading/trailing anchor")
            fatalError()
        }
    }
    
    @discardableResult
    private func clipXAxisAnchor(childAnchor: NSLayoutXAxisAnchor,
                                 to edge: ConstraintEdge,
                                 of view: UIView? = nil,
                                 margin: CGFloat = 0,
                                 relation: ConstraintRelation = .equal,
                                 useSafeArea: Bool) -> Constraint {
        
        guard let anchorView = getAnchorView(view) else {
            debugPrint("\(self) You didn't set a relative view or superview isn't available")
            fatalError()
        }
        
        switch edge {
        case .right:
            return clipEdge(childAnchor: childAnchor,
                            parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.rightAnchor : anchorView.rightAnchor,
                            margin: margin,
                            relation: relation)
        case .left:
            return clipEdge(childAnchor: childAnchor,
                            parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.leftAnchor : anchorView.leftAnchor,
                            margin: margin,
                            relation: relation)
        case .centerX:
            return clipEdge(childAnchor: childAnchor,
                            parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.centerXAnchor : anchorView.centerXAnchor,
                            margin: margin,
                            relation: relation)
        default:
            debugPrint("You can't constraint a right anchor to a top/bottom anchor")
            fatalError()
        }
    }
    
    @discardableResult
    final func clipCenterX(to edge: ConstraintEdge,
                                  of view: UIView? = nil,
                                  margin: CGFloat = 0,
                                  relation: ConstraintRelation = .equal,
                                  useSafeArea: Bool = true) -> Constraint {
        
        return clipXAxisAnchor(childAnchor: centerXAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               useSafeArea: useSafeArea).set(identifier: ConstraintType.centerX.rawValue)
        
    }
    
    @discardableResult
    final func clipCenterY(to edge: ConstraintEdge,
                                  of view: UIView? = nil,
                                  margin: CGFloat = 0,
                                  relation: ConstraintRelation = .equal,
                                  useSafeArea: Bool = true) -> Constraint {
        
        return clipYAxisAnchor(childAnchor: centerYAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               useSafeArea: useSafeArea).set(identifier: ConstraintType.centerY.rawValue)
        
    }
    
    @discardableResult
    final func clipTop(to edge: ConstraintEdge,
                              of view: UIView? = nil,
                              margin: CGFloat = 0,
                              relation: ConstraintRelation = .equal,
                              useSafeArea: Bool = true) -> Constraint {
        
        return clipYAxisAnchor(childAnchor: topAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               useSafeArea: useSafeArea).set(identifier: ConstraintType.top.rawValue)
        
    }
    
    @discardableResult
    final func clipRight(to edge: ConstraintEdge,
                                of view: UIView? = nil,
                                margin: CGFloat = 0,
                                relation: ConstraintRelation = .equal,
                                useSafeArea: Bool = true) -> Constraint {
        
        let margin = margin * -1
        return clipXAxisAnchor(childAnchor: rightAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               useSafeArea: useSafeArea).set(identifier: ConstraintType.right.rawValue)
        
    }
    
    @discardableResult
    final func clipBottom(to edge: ConstraintEdge,
                                 of view: UIView? = nil,
                                 margin: CGFloat = 0,
                                 relation: ConstraintRelation = .equal,
                                 useSafeArea: Bool = true) -> Constraint {
        
        let margin = margin * -1
        return clipYAxisAnchor(childAnchor: bottomAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               useSafeArea: useSafeArea).set(identifier: ConstraintType.bottom.rawValue)
        
    }
    
    @discardableResult
    final func clipLeft(to edge: ConstraintEdge,
                               of view: UIView? = nil,
                               margin: CGFloat = 0,
                               relation: ConstraintRelation = .equal,
                               useSafeArea: Bool = true) -> Constraint {
        
        return clipXAxisAnchor(childAnchor: leftAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               useSafeArea: useSafeArea).set(identifier: ConstraintType.left.rawValue)
        
    }
    
    // MARK: - Center
    
    @discardableResult
    final func center(in view: UIView? = nil,
                             margin: CGPoint = .zero) -> [Constraint] {
        
        guard let anchorView = getAnchorView(view) else {
            fatalError("You didn't set a relative view or superview isn't available")
        }
        
        var constraints: [Constraint] = []
        
        constraints.append(clipCenterX(to: .centerX,
                                       of: anchorView,
                                       margin: margin.x,
                                       relation: .equal,
                                       useSafeArea: false))
        
        constraints.append(clipCenterY(to: .centerY,
                                       of: anchorView,
                                       margin: margin.y,
                                       relation: .equal,
                                       useSafeArea: false))
        
        return constraints
    }
    
    // MARK: - Clip multiple edges
    
    @discardableResult
    final func clipSides(to view: UIView? = nil,
                                exclude: [ConstraintEdge] = [],
                                margin: UIEdgeInsets = .zero,
                                relation: ConstraintRelation = .equal,
                                useSafeArea: Bool = true) -> [Constraint] {
        
        var constraints: [Constraint] = []
        
        if exclude.contains(.top) == false {
            constraints.append(clipTop(to: .top,
                                       of: view,
                                       margin: margin.top,
                                       relation: relation,
                                       useSafeArea: useSafeArea))
        }
        
        if exclude.contains(.right) == false {
            constraints.append(clipRight(to: .right,
                                         of: view,
                                         margin: margin.right,
                                         relation: relation,
                                         useSafeArea: useSafeArea))
        }
        
        if exclude.contains(.bottom) == false {
            constraints.append(clipBottom(to: .bottom,
                                          of: view,
                                          margin: margin.bottom,
                                          relation: relation,
                                          useSafeArea: useSafeArea))
        }
        
        if exclude.contains(.left) == false {
            constraints.append(clipLeft(to: .left,
                                        of: view,
                                        margin: margin.left,
                                        relation: relation,
                                        useSafeArea: useSafeArea))
        }
        
        return constraints
    }
    
}
