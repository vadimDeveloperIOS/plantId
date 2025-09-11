//
//  SceneDelegate.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let pageVC = PageContainerViewController()
        let nav = UINavigationController(rootViewController: pageVC)

        if UserDefaultsService.shared.hasSeenOnboarding == false {
            nav.navigationBar.isHidden = true
            window.rootViewController = nav
        }
        else {
            let tabsViewController = TabsViewController()
            window.rootViewController = tabsViewController
        }
        
        window.makeKeyAndVisible()
        self.window = window
    
//        guard let _ = (scene as? UIWindowScene) else { return }
        
        // выглядит криво, если будет время, переписать
        if let item = connectionOptions.shortcutItem {
            switch item.type {
            case "hasProblem":
                if let url = URL(string: "mailto:\("arxivicedorona11364@gmail.com")"),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                    return
                    
                } else {
                    let alert = UIAlertController(
                        title: "Mail Unavailable",
                        message: "Please set up Mail on your device.",
                        preferredStyle: .alert
                    )
                    alert.addAction(.init(title: "OK", style: .default))
                    nav.present(alert, animated: true)
                }

            case "deleteApp":
                let offerVC = SpecialOfferViewController()
                
                if let roootWithNav = window.rootViewController as? UINavigationController {
                    roootWithNav.pushViewController(offerVC, animated: true)
                }
                else if let root = window.rootViewController as? UITabBarController,
                        let selectedNav = root.selectedViewController as? UINavigationController {
                    selectedNav.pushViewController(offerVC, animated: true)
                }
                else if let root = window.rootViewController,
                        let nav = root.navigationController {
                    nav.pushViewController(offerVC, animated: true)
                }
                
            default:
                break
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        Task {
          ProFeatureService.shared.initiate()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        UIApplication.shared.shortcutItems =
        [
            UIApplicationShortcutItem(
                type: "hasProblem", localizedTitle: "Any problems? Get help", localizedSubtitle: "We’re here if you need assistance.", icon: nil
                ),
            UIApplicationShortcutItem(
                type: "deleteApp", localizedTitle: "Wait! Don’t Delete Me!", localizedSubtitle: "Try now with 50% off. Get full access at half the price", icon: nil
                )
        ]
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func windowScene(_ windowScene: UIWindowScene,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        
        let handled = handleShortcut(shortcutItem)
        completionHandler(handled)
    }
    
    @discardableResult private func handleShortcut(_ item: UIApplicationShortcutItem) -> Bool {
        guard let root = window?.rootViewController else { return false }
        
        var navigController = UINavigationController()
        
        if let vc = root as? UINavigationController {
            navigController = vc
        }
        else if let vc = root as? UITabBarController,
                let selectedNav = vc.selectedViewController as? UINavigationController {
            navigController = selectedNav
        }
        else if let vc = root.navigationController {
            navigController = vc
        }
        
        switch item.type {
        case "hasProblem":
            if let url = URL(string: "mailto:\("arxivicedorona11364@gmail.com")"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                
            } else {
                let alert = UIAlertController(
                    title: "Mail Unavailable",
                    message: "Please set up Mail on your device.",
                    preferredStyle: .alert
                )
                alert.addAction(.init(title: "OK", style: .default))
                navigController.present(alert, animated: true)
            }
            return true

        case "deleteApp":
            let offerVC = SpecialOfferViewController()
            navigController.pushViewController(offerVC, animated: true)
            return true

        default:
            return false
        }
    }
}

