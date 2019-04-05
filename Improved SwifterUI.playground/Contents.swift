import UIKit
import PlaygroundSupport

// MARK: - Layout

public typealias Constraint = NSLayoutConstraint
public typealias Constraints = [Constraint]

public struct SFDimension {
    
    public var type: SFDimensionType
    public var value: CGFloat
    public static var zero: SFDimension = SFDimension(value: 0)
    
    public enum SFDimensionType {
        case point
        case fraction
    }
    
    public init(type: SFDimensionType = .point, value: CGFloat) {
        self.type = type
        self.value = value
    }
}

public enum ConstraintType: String {
    case width
    case height
    case centerX
    case centerY
    case top
    case right
    case bottom
    case left
}

public enum ConstraintAxis {
    case horizontal
    case vertical
}

public enum ConstraintEdge {
    case top
    case right
    case bottom
    case left
    case centerX
    case centerY
}

public enum ConstraintRelation {
    case equal
    case greater
    case less
}

public extension Constraint {
    
    @discardableResult
    public final func set(identifier: String) -> Self {
        self.identifier = identifier
        return self
    }
    
    @discardableResult
    public final func set(active: Bool) -> Self {
        self.isActive = active
        return self
    }
}

public extension Array where Element: Constraint {
    
    public func activate() { Constraint.activate(self) }
    
    public func deactivate() { Constraint.deactivate(self) }
    
    public func forEachConstraint(where view: UIView, completion: @escaping (Constraint) -> Void) {
        forEach { (constraint) in
            if let firstItem = constraint.firstItem as? UIView, firstItem == view {
                completion(constraint)
            }
        }
    }
}

extension NSLayoutDimension {
    func constraint(to anchor: NSLayoutDimension, dimension: SFDimension, relation: ConstraintRelation = .equal, margin: CGFloat = 0.0, priority: UILayoutPriority = .required) -> Constraint {
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

public enum SFError: String, Error {
    case LayoutParent = "No parent found"
}


public protocol SFLayoutView {
    func prepareSubviews()
    func setConstraints()
    func add(subView: UIView)
    func getAnchorView(_ view: UIView?) -> UIView?
    func getAllConstraints() -> Constraints
    func removeAllConstraints()
    func getConstraint(type constraintType: ConstraintType) -> Constraint?
    func removeConstraint(type constraintType: ConstraintType)
    func set(height: SFDimension?, relatedTo view: UIView?, relation: ConstraintRelation, margin: CGFloat, priority: UILayoutPriority) -> Constraint
    func set(width: SFDimension?, relatedTo view: UIView?, relation: ConstraintRelation, margin: CGFloat, priority: UILayoutPriority) -> Constraint
    func clipCenterX(to edge: ConstraintEdge, of view: UIView?, margin: CGFloat, relation: ConstraintRelation, priority: UILayoutPriority, useSafeArea: Bool) -> Constraint
}

extension SFLayoutView where Self: UIView {
    
    public func add(subView: UIView) {
        subView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subView)
    }
    
    public func getAnchorView(_ view: UIView?) -> UIView? {
        if let view = view {
            return view
        } else if let superview = superview {
            return superview
        } else {
            return nil
        }
    }
    
    public func getAllConstraints() -> Constraints {
        
        var constraints: Constraints = []
        
        self.constraints.forEachConstraint(where: self) { (constraint) in
            constraints.append(constraint)
        }
        
        superview?.constraints.forEachConstraint(where: self, completion: { (constraint) in
            constraints.append(constraint)
        })
        
        return constraints
    }
    
    public func removeAllConstraints() {
        guard let superview = superview else { return }
        let constraints = getAllConstraints()
        constraints.forEach { [unowned self] (constraint)  in
            self.removeConstraint(constraint)
            superview.removeConstraint(constraint)
        }
    }
    
    public func getConstraint(type constraintType: ConstraintType) -> Constraint? {
        
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
    
    public func removeConstraint(type constraintType: ConstraintType) {
        guard let oldConstraint = getConstraint(type: constraintType) else { return }
        self.removeConstraint(oldConstraint)
        self.superview?.removeConstraint(oldConstraint)
    }
    
    public func set(height: SFDimension? = nil, relatedTo view: UIView? = nil, relation: ConstraintRelation = .equal, margin: CGFloat = 0.0, priority: UILayoutPriority = .required) -> Constraint {

        guard let anchorView = getAnchorView(view) else { fatalError() }

        let heightConstraint: Constraint
        
        if let height = height {
            heightConstraint = heightAnchor.constraint(to: anchorView.heightAnchor, dimension: height, relation: relation, margin: margin)
        } else {
            heightConstraint = heightAnchor.constraint(equalTo: anchorView.heightAnchor, multiplier: 1)
        }
        
        heightConstraint.set(active: true).set(identifier: ConstraintType.height.rawValue)
        heightConstraint.priority = priority
        
        return heightConstraint
    }
    
    public func set(width: SFDimension? = nil, relatedTo view: UIView? = nil, relation: ConstraintRelation = .equal, margin: CGFloat = 0.0, priority: UILayoutPriority = .required) -> Constraint {
        
        guard let anchorView = getAnchorView(view) else { fatalError() }
        
        let widthConstraint: Constraint
        
        if let width = width {
            widthConstraint = widthAnchor.constraint(to: anchorView.widthAnchor, dimension: width, relation: relation, margin: margin)
        } else {
            widthConstraint = widthAnchor.constraint(equalTo: anchorView.widthAnchor, multiplier: 1)
        }
        
        widthConstraint.set(active: true).set(identifier: ConstraintType.width.rawValue)
        widthConstraint.priority = priority
        
        return widthConstraint
    }
    
    private func clipEdge<Anchor>(childAnchor: NSLayoutAnchor<Anchor>,
                                  parentAnchor: NSLayoutAnchor<Anchor>,
                                  margin: CGFloat,
                                  priority: UILayoutPriority,
                                  relation: ConstraintRelation = .equal) -> Constraint {
        let constraint: NSLayoutConstraint
        switch relation {
        case .equal:
            constraint = childAnchor.constraint(equalTo: parentAnchor, constant: margin)
        case .greater:
            constraint = childAnchor.constraint(greaterThanOrEqualTo: parentAnchor, constant: margin)
        case .less:
            constraint = childAnchor.constraint(lessThanOrEqualTo: parentAnchor, constant: margin)
        }
        constraint.priority = priority
        return constraint
    }
    
    private func clipYAxisAnchor(childAnchor: NSLayoutYAxisAnchor,
                                 to edge: ConstraintEdge,
                                 of view: UIView?,
                                 margin: CGFloat,
                                 relation: ConstraintRelation,
                                 priority: UILayoutPriority,
                                 useSafeArea: Bool) -> Constraint {
        
        guard let anchorView = getAnchorView(view) else { fatalError() }
        
        switch edge {
        case .top:
            return clipEdge(childAnchor: childAnchor,
                            parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.topAnchor : anchorView.topAnchor,
                            margin: margin,
                            priority: priority,
                            relation: relation)
        case .bottom:
            return clipEdge(childAnchor: childAnchor,
                            parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.bottomAnchor : anchorView.bottomAnchor,
                            margin: margin,
                            priority: priority,
                            relation: relation)
        case .centerY:
            return clipEdge(childAnchor: childAnchor,
                            parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.centerYAnchor : anchorView.centerYAnchor,
                            margin: margin,
                            priority: priority,
                            relation: relation)
        default: fatalError()
        }
    }
    
    private func clipXAxisAnchor(childAnchor: NSLayoutXAxisAnchor,
                                 to edge: ConstraintEdge,
                                 of view: UIView?,
                                 margin: CGFloat,
                                 relation: ConstraintRelation,
                                 priority: UILayoutPriority,
                                 useSafeArea: Bool) -> Constraint {
        
        guard let anchorView = getAnchorView(view) else { fatalError() }
        
        switch edge {
        case .right:
            return clipEdge(childAnchor: childAnchor,
                            parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.rightAnchor : anchorView.rightAnchor,
                            margin: margin,
                            priority: priority,
                            relation: relation)
        case .left:
            return clipEdge(childAnchor: childAnchor,
                            parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.leftAnchor : anchorView.leftAnchor,
                            margin: margin,
                            priority: priority,
                            relation: relation)
        case .centerX:
            return clipEdge(childAnchor: childAnchor,
                            parentAnchor: useSafeArea == true ? anchorView.safeAreaLayoutGuide.centerXAnchor : anchorView.centerXAnchor,
                            margin: margin,
                            priority: priority,
                            relation: relation)
        default: fatalError()
        }
    }
    
    public func clipCenterX(to edge: ConstraintEdge,
                            of view: UIView? = nil,
                            margin: CGFloat = 0,
                            relation: ConstraintRelation = .equal,
                            priority: UILayoutPriority = .required,
                            useSafeArea: Bool = true) -> Constraint {
        
        return clipXAxisAnchor(childAnchor: centerXAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               priority: priority,
                               useSafeArea: useSafeArea)
            .set(identifier: ConstraintType.centerX.rawValue)
            .set(active: true)
    }
    
    public func clipCenterY(to edge: ConstraintEdge,
                            of view: UIView? = nil,
                            margin: CGFloat = 0,
                            relation: ConstraintRelation = .equal,
                            priority: UILayoutPriority = .required,
                            useSafeArea: Bool = true) -> Constraint {
        
        return clipYAxisAnchor(childAnchor: centerYAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               priority: priority,
                               useSafeArea: useSafeArea)
            .set(identifier: ConstraintType.centerY.rawValue)
            .set(active: true)
    }
    
    public func clipTop(to edge: ConstraintEdge,
                        of view: UIView? = nil,
                        margin: CGFloat = 0,
                        relation: ConstraintRelation = .equal,
                        priority: UILayoutPriority = .required,
                        useSafeArea: Bool = true) -> Constraint {
        
        return clipYAxisAnchor(childAnchor: topAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               priority: priority,
                               useSafeArea: useSafeArea)
            .set(identifier: ConstraintType.top.rawValue)
            .set(active: true)
    }
    
    public func clipRight(to edge: ConstraintEdge,
                          of view: UIView? = nil,
                          margin: CGFloat = 0,
                          relation: ConstraintRelation = .equal,
                          priority: UILayoutPriority = .required,
                          useSafeArea: Bool = true) -> Constraint {
        
        let margin = margin * -1
        return clipXAxisAnchor(childAnchor: rightAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               priority: priority,
                               useSafeArea: useSafeArea)
            .set(identifier: ConstraintType.right.rawValue)
            .set(active: true)
    }

    public func clipBottom(to edge: ConstraintEdge,
                           of view: UIView? = nil,
                           margin: CGFloat = 0,
                           relation: ConstraintRelation = .equal,
                           priority: UILayoutPriority = .required,
                           useSafeArea: Bool = true) -> Constraint {
        
        let margin = margin * -1
        return clipYAxisAnchor(childAnchor: bottomAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               priority: priority,
                               useSafeArea: useSafeArea)
            .set(identifier: ConstraintType.bottom.rawValue)
            .set(active: true)
    }
    
    public func clipLeft(to edge: ConstraintEdge,
                         of view: UIView? = nil,
                         margin: CGFloat = 0,
                         relation: ConstraintRelation = .equal,
                         priority: UILayoutPriority = .required,
                         useSafeArea: Bool = true) -> Constraint {
        
        return clipXAxisAnchor(childAnchor: leftAnchor,
                               to: edge, of: view,
                               margin: margin,
                               relation: relation,
                               priority: priority,
                               useSafeArea: useSafeArea)
            .set(identifier: ConstraintType.left.rawValue)
            .set(active: true)
    }
    
    public func center(in view: UIView? = nil,
                       margin: CGPoint = .zero,
                       priority: UILayoutPriority = .required) -> [Constraint] {
        
        guard let anchorView = getAnchorView(view) else { fatalError() }
        
        var constraints: [Constraint] = []
        
        constraints.append(clipCenterX(to: .centerX,
                                       of: anchorView,
                                       margin: margin.x,
                                       relation: .equal,
                                       priority: priority,
                                       useSafeArea: false))
        
        constraints.append(clipCenterY(to: .centerY,
                                       of: anchorView,
                                       margin: margin.y,
                                       relation: .equal,
                                       priority: priority,
                                       useSafeArea: false))
        
        return constraints
    }
    
    public func clipSides(to view: UIView? = nil,
                          exclude: [ConstraintEdge] = [],
                          margin: UIEdgeInsets = .zero,
                          relation: ConstraintRelation = .equal,
                          priority: UILayoutPriority = .required,
                          useSafeArea: Bool = true) -> [Constraint] {
        
        var constraints: [Constraint] = []
        
        if exclude.contains(.top) == false {
            constraints.append(clipTop(to: .top,
                                       of: view,
                                       margin: margin.top,
                                       relation: relation,
                                       priority: priority,
                                       useSafeArea: useSafeArea))
        }
        
        if exclude.contains(.right) == false {
            constraints.append(clipRight(to: .right,
                                         of: view,
                                         margin: margin.right,
                                         relation: relation,
                                         priority: priority,
                                         useSafeArea: useSafeArea))
        }
        
        if exclude.contains(.bottom) == false {
            constraints.append(clipBottom(to: .bottom,
                                          of: view,
                                          margin: margin.bottom,
                                          relation: relation,
                                          priority: priority,
                                          useSafeArea: useSafeArea))
        }
        
        if exclude.contains(.left) == false {
            constraints.append(clipLeft(to: .left,
                                        of: view,
                                        margin: margin.left,
                                        relation: relation,
                                        priority: priority,
                                        useSafeArea: useSafeArea))
        }
        
        return constraints
    }
}

// MARK: - Colors

public struct SFColorManager {
    
    private(set) var currentColorScheme: SFColorScheme
    private(set) var colorSchemes: Array<SFColorScheme> = []
    private(set) var viewControllers: Array<SFViewController> = []
    
    public var animationDuration: TimeInterval = 1.0
    
    public init(colorScheme: SFColorScheme) {
        currentColorScheme = colorScheme
        register(colorScheme: colorScheme)
    }
    
    public init(colorSchemes: Array<SFColorScheme>, selectedIndex: Int = 0) {
        currentColorScheme = colorSchemes[selectedIndex]
        self.colorSchemes = colorSchemes
        selectColorScheme(with: selectedIndex)
    }
    
    public mutating func register(colorScheme: SFColorScheme) {
        colorSchemes.append(colorScheme)
    }
    
    public mutating func selectColorScheme(with identifier: String) {
        colorSchemes.forEach { (colorScheme) in
            if colorScheme.identifier == identifier {
                currentColorScheme = colorScheme
                updateColors()
            }
        }
    }
    
    public mutating func selectColorScheme(with index: Int = 0) {
        currentColorScheme = colorSchemes[index]
        updateColors()
    }
    
    public mutating func register(viewController: SFViewController) {
        viewControllers.append(viewController)
        viewController.updateViewColors(with: currentColorScheme)
    }
    
    public mutating func deregister(viewController: SFViewController) {
        viewControllers.removeAll(where: { $0 === viewController })
    }
    
    public func updateColors() {
        let animator = UIViewPropertyAnimator(duration: animationDuration, curve: .easeInOut) {
            self.viewControllers.forEach { (viewController) in
                viewController.updateViewColors(with: self.currentColorScheme)
            }
        }
        animator.startAnimation()
    }
}

public struct SFColorScheme {
    public var identifier: String
    public var backgroundColor: UIColor
    public var textColor: UIColor
    public var contrastBackgroundColor: UIColor
    public var placeholderColor: UIColor
    public var interactiveColor: UIColor
    public var blurEffectStyle: UIBlurEffect.Style
    public var scrollIndicatorStyle: UIScrollView.IndicatorStyle
    public var activityIndicatorStyle: UIActivityIndicatorView.Style
    public var separatorColor: UIColor
    public var barStyle: UIBarStyle
    public var statusBarStyle: UIStatusBarStyle
    public var keyboardStyle: UIKeyboardAppearance
}

public protocol SFColorView {
    func updateColors(with colorScheme: SFColorScheme)
    func updateSubviewsColors(with colorScheme: SFColorScheme)
}

public protocol SFColorController {
    var sfview: SFView! { get }
    func updateViewColors(with colorScheme: SFColorScheme)
}

extension UIViewController: SFColorController {
    
    public var sfview: SFView! { return view as? SFView }
    
    public func updateViewColors(with colorScheme: SFColorScheme) {
        sfview.updateColors(with: colorScheme)
    }
}

// MARK: - Main

open class SFView: UIView, SFLayoutView, SFColorView {
    
    open var identifier = "SFView"
    
    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        prepareSubviews()
        setConstraints()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func prepareSubviews() {
        
    }
    
    open func setConstraints() {
        
    }
    
    public func updateColors(with colorScheme: SFColorScheme) {
        backgroundColor = colorScheme.backgroundColor
        tintColor = colorScheme.interactiveColor
        updateSubviewsColors(with: colorScheme)
    }
    
    public func updateSubviewsColors(with colorScheme: SFColorScheme) {
        subviews.forEach {
            if let view = $0 as? SFColorView {
                view.updateColors(with: colorScheme)
            }
        }
    }
}

open class SFViewController: UIViewController {
    
    // MARK: - Instance Properties
    
    var statusBarIsHidden: Bool = false {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override open var prefersStatusBarHidden: Bool { return self.statusBarIsHidden }
    
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle { return self.statusBarStyle }
    
    var autorotate = true
    
    override open var shouldAutorotate: Bool {
        return self.autorotate
    }
    
    // MARK: - Initializers
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance Methods
    
    open override func loadView() {
        self.view = SFView()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        
        if let navigationController = self.navigationController {
            prepare(navigationController: navigationController)
        }
        
        if let tabBarController = self.tabBarController {
            prepare(tabBarController: tabBarController)
        }
    }
    
    open func prepare(navigationController: UINavigationController) {}
    
    open func prepare(tabBarController: UITabBarController) {}
}

let colorSchemeOne = SFColorScheme(identifier: "White", backgroundColor: .white, textColor: .black, contrastBackgroundColor: .lightGray, placeholderColor: .lightText, interactiveColor: .blue, blurEffectStyle: .dark, scrollIndicatorStyle: .black, activityIndicatorStyle: .gray, separatorColor: .gray, barStyle: .default, statusBarStyle: .default, keyboardStyle: .light)

let colorSchemeTwo = SFColorScheme(identifier: "Black", backgroundColor: .black, textColor: .white, contrastBackgroundColor: .lightGray, placeholderColor: .lightText, interactiveColor: .orange, blurEffectStyle: .dark, scrollIndicatorStyle: .black, activityIndicatorStyle: .gray, separatorColor: .gray, barStyle: .default, statusBarStyle: .default, keyboardStyle: .light)

let colorSchemeThree = SFColorScheme(identifier: "Red", backgroundColor: .red, textColor: .white, contrastBackgroundColor: .lightGray, placeholderColor: .lightText, interactiveColor: .yellow, blurEffectStyle: .dark, scrollIndicatorStyle: .black, activityIndicatorStyle: .gray, separatorColor: .gray, barStyle: .default, statusBarStyle: .default, keyboardStyle: .light)

var colorManager = SFColorManager(colorSchemes: [colorSchemeOne, colorSchemeTwo, colorSchemeThree])

class View: SFView {
    
    lazy var subview: SFView = {
        let view = SFView()
        return view
    }()
    
    override func prepareSubviews() {
        add(subView: subview)
    }
    
    override func setConstraints() {
        subview.set(width: SFDimension(type: .point, value: 50), priority: UILayoutPriority.init(rawValue: 800))
        subview.set(height: SFDimension(type: .point, value: 50), priority: UILayoutPriority.init(rawValue: 800))
        subview.center()
    }
    
    override func updateColors(with colorScheme: SFColorScheme) {
        backgroundColor = colorScheme.interactiveColor
        updateSubviewsColors(with: colorScheme)
    }
}

class ViewController: SFViewController {
    
    lazy var newView = View()
    
    override func viewDidLoad() {
        sfview.add(subView: newView)
        newView.clipSides()
    }
}


let viewController = ViewController()
PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView

colorManager.register(viewController: viewController)

var constraint = viewController.newView.subview.set(width: SFDimension(type: .point, value: 100), priority: UILayoutPriority.init(rawValue: 1000))
constraint.isActive = false

DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
    colorManager.selectColorScheme(with: 1)
    constraint.isActive = true
    UIView.animate(withDuration: 0.3, animations: {
        viewController.sfview.layoutIfNeeded()
    })
}

DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
    colorManager.selectColorScheme(with: 2)
    constraint.isActive = false
    UIView.animate(withDuration: 0.3, animations: {
        viewController.sfview.layoutIfNeeded()
    })
}
