//
//  TabsViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit

final class TabsViewController: UITabBarController {

    private(set) lazy var tabsView = TabsView()
    private var index: Int = 0

    override var viewControllers: [UIViewController]? {
        didSet {
            viewControllers?.forEach { viewController in
                viewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tabsView)
        tabBar.isHidden = true
        tabBar.layer.zPosition = -1

        tabsView.pinToSuperview(excluding: [.top, .bottom])
        tabsView.bottomAnchor ~= tabBar.bottomAnchor
        tabsView.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
                
            case .home:
                self.showHome()
                
            case .plant:
                self.showPlant()
                
            case .diagnostics:
                self.showDiagnostics()

            case .myPlans:
                self.showMyPlants()
                
            case .settings:
                self.showSettings()

            }
        }
        showInitial()
        showHome()
        
//        NotificationService.shared.requestAuthorization { granted in
//            if granted {
//                print("Пользователь разрешил уведомления")
//            } else {
//                print("Пользователь запретил уведомления")
//            }
//        }
    }

    override var selectedIndex: Int {
        didSet {
            tabsView.selectedIndex = selectedIndex
        }
    }

    override func hideTabBar(_ hide: Bool) {
        tabsView.isHidden = hide
    }
    
    func showInitial() {
        viewControllers = [
            Navigation(rootViewController: HomeViewController()),
            Navigation(rootViewController: PlantViewController()),
            Navigation(rootViewController: DiagnosticsViewController()),
            Navigation(rootViewController: MyPlantsViewController()),
            Navigation(rootViewController: SettingsViewController())
        ]
        if index != 0 {
            selectedIndex = index
        }
    }
    
    func showHome() {
        if self.selectedIndex == 0 {
            if let navController = viewControllers?[0] as? UINavigationController {
                navController.popToRootViewController(animated: true)
            }
        }
        selectedIndex = 0
    }
    
    func showPlant() {
        if self.selectedIndex == 1 {
            if let navController = viewControllers?[1] as? UINavigationController {
                navController.popToRootViewController(animated: true)
            }
        }
        selectedIndex = 1
    }
    
    func showDiagnostics() {
        if self.selectedIndex == 2 {
            if let navController = viewControllers?[2] as? UINavigationController {
                navController.popToRootViewController(animated: true)
            }
        }
        selectedIndex = 2
    }
    
    func showMyPlants() {
        if self.selectedIndex == 3 {
            if let navController = viewControllers?[3] as? UINavigationController {
                navController.popToRootViewController(animated: true)
            }
        }
        selectedIndex = 3
    }
    
    func showSettings() {
        if self.selectedIndex == 4 {
            if let navController = viewControllers?[4] as? UINavigationController {
                navController.popToRootViewController(animated: true)
            }
        }
        selectedIndex = 4
    }
}

extension UITabBarController {
    @objc func hideTabBar(_ hide: Bool) {}
}
