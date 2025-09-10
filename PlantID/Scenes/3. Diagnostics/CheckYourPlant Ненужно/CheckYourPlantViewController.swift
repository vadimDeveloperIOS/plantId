//
//  CheckYourPlantViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 25.06.25.
//

import UIKit

class CheckYourPlantViewController: UIViewController {

    private lazy var rootView = CheckYourPlantView()

    override func loadView() {
        view = rootView
        
        rootView.actionHandler = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .back:
                self.back()
            case .help:
                break
            case .scan:
                self.showScan()
            }
        }
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func showScan() {
        if UserDefaultsService.shared.diagnosticsLimit == 1 && ProFeatureService.shared.getHasActiveSubscription() == false {
            let vc = PaywallViewController()
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
            return
        }
        
        let vc = ScanViewController()
        vc.whichRequest = .diagnostic
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
