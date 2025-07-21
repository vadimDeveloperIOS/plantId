//
//  UIView+Layout.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit

public extension UIView {
    func pinToSuperview(left: CGFloat = 0, top: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0) {
        guard let pinView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: pinView.leftAnchor, constant: left).isActive = true
        topAnchor.constraint(equalTo: pinView.topAnchor, constant: top).isActive = true
        rightAnchor.constraint(equalTo: pinView.rightAnchor, constant: -right).isActive = true
        bottomAnchor.constraint(equalTo: pinView.bottomAnchor, constant: -bottom).isActive = true
    }

    func pinToSuperview(padding: CGFloat) {
        pinToSuperview(left: padding, top: padding, right: padding, bottom: padding)
    }

    enum ViewEdge {
        case top
        case left
        case right
        case bottom
    }

    func pinToSuperview(excluding edges: [ViewEdge], padding: CGFloat = 0) {
        guard let pinView = superview else { return }

        var allSet = Set<ViewEdge>(arrayLiteral: .top, .bottom, .left, .right)
        allSet.subtract(edges)
        translatesAutoresizingMaskIntoConstraints = false
        for edge in allSet {
            switch edge {
            case .top:
                topAnchor.constraint(equalTo: pinView.topAnchor, constant: padding).isActive = true
            case .left:
                leadingAnchor.constraint(equalTo: pinView.leadingAnchor, constant: padding).isActive = true
            case .right:
                trailingAnchor.constraint(equalTo: pinView.trailingAnchor, constant: -padding).isActive = true
            case .bottom:
                bottomAnchor.constraint(equalTo: pinView.bottomAnchor, constant: -padding).isActive = true
            }
        }
    }

    func pinToSuperviewCenter(dx: CGFloat = 0, dy: CGFloat = 0, restrictEdges: Bool = true) {
        guard let pinView = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: pinView.centerXAnchor, constant: dx).isActive = true
        centerYAnchor.constraint(equalTo: pinView.centerYAnchor, constant: dy).isActive = true
        if restrictEdges {
            topAnchor.constraint(greaterThanOrEqualTo: pinView.topAnchor).isActive = true
            leadingAnchor.constraint(greaterThanOrEqualTo: pinView.leadingAnchor).isActive = true
        }
    }


    func getAllConstraints() -> [NSLayoutConstraint] {
        // array will contain self and all superviews
        var views = [self]

        // get all superviews
        var view = self
        while let superview = view.superview {
            views.append(superview)
            view = superview
        }

        // transform views to constraints and filter only those
        // constraints that include the view itself
        return views.flatMap({ $0.constraints }).filter { constraint in
            return constraint.firstItem as? UIView == self ||
            constraint.secondItem as? UIView == self
        }
    }
}

public struct ConstraintAttribute<T: AnyObject> {
    let anchor: NSLayoutAnchor<T>
    let const: CGFloat
}

public struct LayoutGuideAttribute {
    let guide: UILayoutSupport
    let const: CGFloat
}

public func + <T>(lhs: NSLayoutAnchor<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
    return ConstraintAttribute(anchor: lhs, const: rhs)
}

public func + (lhs: UILayoutSupport, rhs: CGFloat) -> LayoutGuideAttribute {
    return LayoutGuideAttribute(guide: lhs, const: rhs)
}

public func - <T>(lhs: NSLayoutAnchor<T>, rhs: CGFloat) -> ConstraintAttribute<T> {
    return ConstraintAttribute(anchor: lhs, const: -rhs)
}

public func - (lhs: UILayoutSupport, rhs: CGFloat) -> LayoutGuideAttribute {
    return LayoutGuideAttribute(guide: lhs, const: -rhs)
}

// ~= is used instead of == because Swift can't overload == for NSObject subclass
@discardableResult
public func ~= (lhs: NSLayoutYAxisAnchor, rhs: UILayoutSupport) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.bottomAnchor)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func <= <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(lessThanOrEqualTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func >= <T>(lhs: NSLayoutAnchor<T>, rhs: NSLayoutAnchor<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(greaterThanOrEqualTo: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.anchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= (lhs: NSLayoutYAxisAnchor, rhs: LayoutGuideAttribute) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalTo: rhs.guide.bottomAnchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func ~= (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    let constraint = lhs.constraint(equalToConstant: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func <= <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(lessThanOrEqualTo: rhs.anchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func <= (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    let constraint = lhs.constraint(lessThanOrEqualToConstant: rhs)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func >= <T>(lhs: NSLayoutAnchor<T>, rhs: ConstraintAttribute<T>) -> NSLayoutConstraint {
    let constraint = lhs.constraint(greaterThanOrEqualTo: rhs.anchor, constant: rhs.const)
    constraint.isActive = true
    return constraint
}

@discardableResult
public func >= (lhs: NSLayoutDimension, rhs: CGFloat) -> NSLayoutConstraint {
    let constraint = lhs.constraint(greaterThanOrEqualToConstant: rhs)
    constraint.isActive = true
    return constraint
}

