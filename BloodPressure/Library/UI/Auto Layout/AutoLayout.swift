import UIKit

typealias Constraint = (_ child: UIView, _ parent: UIView) -> NSLayoutConstraint

// swiftlint:disable:next line_length identifier_name
func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>, _ to: KeyPath<UIView, Anchor>, constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, parent in
        view[keyPath: keyPath].constraint(equalTo: parent[keyPath: to], constant: constant)
    }
}

func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>, constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return equal(keyPath, keyPath, constant: constant)
}

func equalToConstant<Anchor>(_ keyPath: KeyPath<UIView, Anchor>, _ constant: CGFloat) -> Constraint where Anchor: NSLayoutDimension {
    return { view, _ in
        view[keyPath: keyPath].constraint(equalToConstant: constant)
    }
}

extension UIView {
    func addSubview(_ child: UIView, constraints: [Constraint]) {
        addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints.map { $0(child, self) })
    }

    func addSubviewAndConstraintToEdges(_ child: UIView) {
        let constraints = [equal(\.topAnchor), equal(\.bottomAnchor), equal(\.leftAnchor), equal(\.rightAnchor)]
        addSubview(child, constraints: constraints)
    }
}
