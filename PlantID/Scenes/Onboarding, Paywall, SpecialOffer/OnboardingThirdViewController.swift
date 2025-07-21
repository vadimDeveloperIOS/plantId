//
//  OnboardingThirdViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 7.07.25.
//

import UIKit

final class OnboardingThirdViewController: UIViewController {
    
    private lazy var rootView = OnboardingThirdView()
    var nextPageHandler: (() -> Void)?
    
    override func loadView() {
        view = rootView
        rootView.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .cont:
                self.nextPageHandler?()
            case .privacy:
                self.presentPrivacyPolicy()
            case .terms:
                self.presentTermsOfUse()
            case .restore:
                ProFeatureService.shared.restorePurchases()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.currentPage = 2
    }
}
