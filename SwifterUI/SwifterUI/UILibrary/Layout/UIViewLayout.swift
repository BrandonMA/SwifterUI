//
//  UIView.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 17/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension UIView {

    // MARK: - Instance Methods

    private func getAnchorView(view: UIView?) -> UIView? {
        if let view = view {
            return view
        } else if let superview = superview {
            return superview
        } else {
            return nil
        }
    }

    // MARK: - Getting and Removing Constraints

    public final func getAllConstraints() -> Constraints {

        var constraints: Constraints = []

        for constraint in self.constraints {
            if let view = constraint.firstItem as? UIView {
                if view === self {
                    constraints.append(constraint)
                }
            }
        }

        if let superview = superview {
            for constraint in superview.constraints {
                if let view = constraint.firstItem as? UIView {
                    if view === self {
                        constraints.append(constraint)
                    }
                }
            }
        }

        return constraints
    }

    public final func removeAllConstraints() {
        guard let superview = superview else { return }
        let constraints = getAllConstraints()
        constraints.forEach { (constraint) in
            self.removeConstraint(constraint)
            superview.removeConstraint(constraint)
        }
    }

    public final func get(constraintType: ConstraintType) -> Constraint? {

        for constraint in self.constraints {
            if let view = constraint.firstItem as? UIView {
                if view === self {
                    if constraint.identifier == constraintType.rawValue {
                        return constraint
                    }
                }
            }
        }

        if let superview = superview {
            for constraint in superview.constraints {
                if let view = constraint.firstItem as? UIView {
                    if view === self {
                        if constraint.identifier == constraintType.rawValue {
                            return constraint
                        }
                    }
                }
            }
        }

        return nil
    }

    public final func remove(constraintType: ConstraintType) {
        guard let superview = superview else { return }
        if let oldConstraint = get(constraintType: constraintType) {
            removeConstraint(oldConstraint)
            superview.removeConstraint(oldConstraint)
        }
    }

    // MARK: - Sizing

    @discardableResult
    private func size(childAnchor: NSLayoutDimension,
                      parentAnchor: NSLayoutDimension,
                      dimension: SFDimension,
                      relation: ConstraintRelation) -> Constraint {
        switch dimension.type {

        case .fraction:
            switch relation {
            case .equal: return childAnchor.constraint(equalTo: parentAnchor, multiplier: dimension.value)
            case .greater: return childAnchor.constraint(greaterThanOrEqualTo: parentAnchor,
                                                         multiplier: dimension.value)
            case .less: return childAnchor.constraint(lessThanOrEqualTo: parentAnchor, multiplier: dimension.value)
            }
        case .point:
            switch relation {
            case .equal: return childAnchor.constraint(equalToConstant: dimension.value)
            case .greater: return childAnchor.constraint(greaterThanOrEqualToConstant: dimension.value)
            case .less: return childAnchor.constraint(lessThanOrEqualToConstant: dimension.value)
            }
        }
        
    }

    @discardableResult
    public final func height(_ height: SFDimension? = nil,
                       comparedTo view: UIView? = nil,
                       relation: ConstraintRelation = .equal) -> Constraint {

        guard let anchorView = getAnchorView(view: view) else {
            fatalError("You didn't set a relative view or superview isn't available")
        }

        let heightConstraint: Constraint

        if let height = height {
            heightConstraint = size(childAnchor: heightAnchor,
                                    parentAnchor: anchorView.heightAnchor,
                                    dimension: height,
                                    relation: relation)
        } else {
            heightConstraint = heightAnchor.constraint(equalTo: anchorView.heightAnchor, multiplier: 1)
        }

        heightConstraint.set(active: true).set(identifier: ConstraintType.height.rawValue)
        return heightConstraint
    }

    @discardableResult
    public final func width(_ width: SFDimension? = nil,
                      comparedTo view: UIView? = nil,
                      relation: ConstraintRelation = .equal) -> Constraint {

        guard let anchorView = getAnchorView(view: view) else {
            fatalError("You didn't set a relative view or superview isn't available")
        }

        let widthConstraint: Constraint

        if let width = width {
            widthConstraint = size(childAnchor: widthAnchor,
                                   parentAnchor: anchorView.widthAnchor,
                                   dimension: width, relation:
                relation)
        } else {
            widthConstraint = widthAnchor.constraint(equalTo: anchorView.widthAnchor, multiplier: 1)
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
            return childAnchor.constraint(equalTo: parentAnchor, constant: margin).set(active: true)
        case .greater:
            return childAnchor.constraint(greaterThanOrEqualTo: parentAnchor, constant: margin).set(active: true)
        case .less:
            return childAnchor.constraint(lessThanOrEqualTo: parentAnchor, constant: margin).set(active: true)
        }
    }

    @discardableResult
    private func clipYAxisAnchor(childAnchor: NSLayoutYAxisAnchor,
                                 to edge: ConstraintEdge,
                                 of view: UIView? = nil,
                                 margin: CGFloat = 0,
                                 relation: ConstraintRelation = .equal,
                                 useSafeArea: Bool) -> Constraint? {

        guard let anchorView = getAnchorView(view: view) else {
            fatalError("You didn't set a relative view or superview isn't available")
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
            print("You can't constraint a bottom anchor to a right/left/leading/trailing anchor")
            return nil
        }
    }

    @discardableResult
    private func clipXAxisAnchor(childAnchor: NSLayoutXAxisAnchor,
                                 to edge: ConstraintEdge,
                                 of view: UIView? = nil,
                                 margin: CGFloat = 0,
                                 relation: ConstraintRelation = .equal,
                                 useSafeArea: Bool) -> Constraint? {

        guard let anchorView = getAnchorView(view: view) else {
            print("\(self) You didn't set a relative view or superview isn't available")
            return nil
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
            print("You can't constraint a right anchor to a top/bottom anchor")
            return nil
        }
    }

    @discardableResult
    public final func clipCenterX(to edge: ConstraintEdge,
                            of view: UIView? = nil,
                            margin: CGFloat = 0,
                            relation: ConstraintRelation = .equal,
                            useSafeArea: Bool = true) -> Constraint? {

        return clipXAxisAnchor(childAnchor: centerXAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               useSafeArea: useSafeArea)?.set(identifier: ConstraintType.centerX.rawValue)

    }

    @discardableResult
    public final func clipCenterY(to edge: ConstraintEdge,
                            of view: UIView? = nil,
                            margin: CGFloat = 0,
                            relation: ConstraintRelation = .equal,
                            useSafeArea: Bool = true) -> Constraint? {

        return clipYAxisAnchor(childAnchor: centerYAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               useSafeArea: useSafeArea)?.set(identifier: ConstraintType.centerY.rawValue)

    }

    @discardableResult
    public final func clipTop(to edge: ConstraintEdge,
                        of view: UIView? = nil,
                        margin: CGFloat = 0,
                        relation: ConstraintRelation = .equal,
                        useSafeArea: Bool = true) -> Constraint? {

        return clipYAxisAnchor(childAnchor: topAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               useSafeArea: useSafeArea)?.set(identifier: ConstraintType.top.rawValue)

    }

    @discardableResult
    public final func clipRight(to edge: ConstraintEdge,
                          of view: UIView? = nil,
                          margin: CGFloat = 0,
                          relation: ConstraintRelation = .equal,
                          useSafeArea: Bool = true) -> Constraint? {

        let margin = margin * -1
        return clipXAxisAnchor(childAnchor: rightAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               useSafeArea: useSafeArea)?.set(identifier: ConstraintType.right.rawValue)

    }

    @discardableResult
    public final func clipBottom(to edge: ConstraintEdge,
                           of view: UIView? = nil,
                           margin: CGFloat = 0,
                           relation: ConstraintRelation = .equal,
                           useSafeArea: Bool = true) -> Constraint? {

        let margin = margin * -1
        return clipYAxisAnchor(childAnchor: bottomAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               useSafeArea: useSafeArea)?.set(identifier: ConstraintType.bottom.rawValue)

    }

    @discardableResult
    public final func clipLeft(to edge: ConstraintEdge,
                         of view: UIView? = nil,
                         margin: CGFloat = 0,
                         relation: ConstraintRelation = .equal,
                         useSafeArea: Bool = true) -> Constraint? {

        return clipXAxisAnchor(childAnchor: leftAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               useSafeArea: useSafeArea)?.set(identifier: ConstraintType.left.rawValue)

    }

    // MARK: - Center

    @discardableResult
    public final func center(axis: [ConstraintAxis] = [.horizontal, .vertical],
                       in view: UIView? = nil,
                       offSet: CGPoint = .zero) -> [Constraint?] {

        guard let anchorView = getAnchorView(view: view) else {
            fatalError("You didn't set a relative view or superview isn't available")
        }
        var constraints: [Constraint?] = []

        if axis.contains(.horizontal) {
            constraints.append(clipCenterX(to: .centerX,
                                           of: anchorView,
                                           margin: offSet.x,
                                           relation: .equal,
                                           useSafeArea: false))
        }
        if axis.contains(.vertical) {
            constraints.append(clipCenterY(to: .centerY,
                                           of: anchorView,
                                           margin: offSet.y,
                                           relation: .equal,
                                           useSafeArea: false))
        }

        return constraints
    }

    // MARK: - Clip multiple edges

    @discardableResult
    public final func clipEdges(to view: UIView? = nil,
                          margin: UIEdgeInsets = .zero,
                          exclude: [ConstraintEdge] = [],
                          relation: ConstraintRelation = .equal,
                          useSafeArea: Bool = true) -> [Constraint?] {

        var constraints: [Constraint?] = []

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
