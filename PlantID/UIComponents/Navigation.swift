//
//  Navigation.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 24.06.25.
//

import UIKit

/// Custom navigation controller for the app with no navigation bar and back swipe enabled
open class Navigation: UINavigationController, UIGestureRecognizerDelegate {
    // MARK: - Lyfecycle
    open override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBarHidden(true, animated: false)
        interactivePopGestureRecognizer?.delegate = self
    }

    // MARK: - UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}

// ВОЗМОЖНО НУЖНО БУДЕТ УДАЛИТЬ
public extension UINavigationController {
    /// Push view controller with completion block
    ///  - Parameters:
    ///     - viewController: View Controller to push
    ///     - animated: Animation flag
    ///     - completion: Block is called when present animation is completed
    func push(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        pushViewController(viewController, animated: animated)
        guard let completion = completion else { return }
        if animated, let coordinator = self.transitionCoordinator {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        }
        else {
            completion()
        }
    }
}


