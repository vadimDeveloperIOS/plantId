//
//  TabsView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit

final class TabsView: View {
    enum Action: Int {
        case home
        case plant
        case diagnostics
        case myPlans
        case settings
    }
    var actionHandler: (Action) -> Void = { _ in }

    var selectedIndex: Int = 0 {
        didSet {
            self.customBar.selectedIndex = selectedIndex
        }
    }
    
    struct Model {
        let items: [TabBarItem]
    }

    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            customBar.items = viewModel.items
        }
    }

    private lazy var customBar: CustomTabBarView = {
        let view = CustomTabBarView()
        view.actionTap = { [weak self] index in
            guard let self else { return }
            let item = self.customBar.items[index]
            self.selectedIndex = index
            self.actionHandler(Action(rawValue: index) ?? .home)
        }
        
        view.items = [
            RegularTabBarItem(
                image: UIImage(named: "tabbar_home"),
                selectedImage: UIImage(named: "selected.home")
            ),
            RegularTabBarItem(
                image: UIImage(named: "tabbar_plant"),
                selectedImage: UIImage(named: "selected.plant")
            ),
            RegularTabBarItem(
                image: UIImage(named: "tabbar_diagnostics"),
                selectedImage: UIImage(named: "selected.diagnostic")
            ),
            RegularTabBarItem(
                image: UIImage(named: "tabbar_myPlans"),
                selectedImage: UIImage(named: "selected.Myplans")
            ),
            RegularTabBarItem(
                image: UIImage(named: "tabbar_settings"),
                selectedImage: UIImage(named: "selected.settings")
            )
        ]
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius = 28
        return view
    }()

    override func setupContent() {
        super.setupContent()
        backgroundColor = .white
        addSubview(customBar)
    }

    override func setupLayout() {
        super.setupLayout()
        customBar.leftAnchor ~= leftAnchor
        customBar.rightAnchor ~= rightAnchor
        customBar.bottomAnchor ~= bottomAnchor
        customBar.topAnchor ~= topAnchor
    }
}

