//
//  DiagnosticsViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 24.06.25.
//

import UIKit

class DiagnosticsViewController: UIViewController {

//    private lazy var rootView = DiagnosticsView()
    private let rootView = FirstDiagnosticViewNew()

    override func loadView() {
        view = rootView
        
        rootView.actionHandlerChild = { [weak self] action in
            guard let self else { return }
            switch action {
            case .cont:
                self.showCheckYourPlant()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabBar(false)
    }

    func showCheckYourPlant() {
        let vc = CheckYourPlantViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
