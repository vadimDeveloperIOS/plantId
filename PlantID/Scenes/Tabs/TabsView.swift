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
            switch selectedIndex {
            case 0: customBar.selectedIndex = 0
            case 1: customBar.selectedIndex = 1
            case 2: customBar.selectedIndex = -1
            case 3: customBar.selectedIndex = 2
            case 4: customBar.selectedIndex = 3
            default: customBar.selectedIndex = -1
            }
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
            let vcIndex = [0, 1, 3, 4][index]
            let actions: [Action] = [.home, .plant, .myPlans, .settings]
            self.selectedIndex = vcIndex
            self.actionHandler(actions[index])
        }
        view.centerAction = { [weak self] in
            guard let self else { return }
            self.selectedIndex = 2
            self.actionHandler(.diagnostics)
        }

        view.items = [
            RegularTabBarItem(
                image: UIImage(named: "tabbar_home"), // TODO: home icon name
                selectedImage: UIImage(named: "tabbar_home_selected") // TODO: selected home icon
            ),
            RegularTabBarItem(
                image: UIImage(named: "tabbar_myplants"), // TODO: my plants icon name
                selectedImage: UIImage(named: "tabbar_myplants_selected") // TODO: selected my plants icon
            ),
            RegularTabBarItem(
                image: UIImage(named: "tabbar_careplan"), // TODO: care plan icon name
                selectedImage: UIImage(named: "tabbar_careplan_selected") // TODO: selected care plan icon
            ),
            RegularTabBarItem(
                image: UIImage(named: "tabbar_settings"), // TODO: settings icon name
                selectedImage: UIImage(named: "tabbar_settings_selected") // TODO: selected settings icon
            )
        ]
        view.centerImage = UIImage(named: "tabbar_scan") // TODO: center scan icon name
        view.centerSelectedImage = UIImage(named: "tabbar_scan_selected") // TODO: selected center icon
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

