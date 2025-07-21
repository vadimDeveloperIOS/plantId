//
//  OnboardingSecondViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 7.07.25.
//

import UIKit
import StoreKit

final class OnboardingSecondViewController: UIViewController {
    
    private lazy var rootView = OnboardingSecondView()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.showStoreAlert()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.currentPage = 1
    }
    
    private func showStoreAlert() {
        if let scene = view.window?.windowScene {
            SKStoreReviewController.requestReview(in: scene)
        } else {
            SKStoreReviewController.requestReview()
        }
    }
}
