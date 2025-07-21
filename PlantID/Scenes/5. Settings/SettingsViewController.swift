//
//  SettingsViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 24.06.25.
//

import UIKit
import StoreKit
import MessageUI

class SettingsViewController: UIViewController {

    private lazy var rootView = SettingsView()

    override func loadView() {
        view = rootView
        
        rootView.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .showPaywall:
                self.showPaywall()
            case .notification:
                self.goToAppSettingsForChangeStatusNotif()
            case .support:
                self.showSupport()
            case .privacyPolicy:
                self.showPrivacyPolicy()
            case .termOfUse:
                self.showTeamOfUse()
            case .rateUs:
                self.showRateUs()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationService.shared.checkAuthorizationStatus { [weak self] status in
            guard let self else { return }
            switch status {
            case .notDetermined:
                // Пользователь ещё не отвечал
                self.rootView.needToGetNotifications = false
                
            case .denied:
                // Пользователь явно отказался в прошлый раз
                self.rootView.needToGetNotifications = false

            case .authorized:
                // Пользователь разрешил показывать уведомления
                self.rootView.needToGetNotifications = true
                
            case .provisional:
                // Доступны лишь «мягкие» уведомления
                self.rootView.needToGetNotifications = true

            case .ephemeral:
                // Специальный статус для App Clips: уведомления разрешены автоматически, но только на время жизни App Clip, без диалога.
                self.rootView.needToGetNotifications = true

            @unknown default:
                self.rootView.needToGetNotifications = false

            }
        }
        rootView.needToHidePremium = ProFeatureService.shared.hasSubscription
    }
    
    private func goToAppSettingsForChangeStatusNotif() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
    }
    
    private func showPaywall() {
        let vc = PaywallViewController()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    private func showSupport() {
        SupportService.shared.presentSupport(from: self)
    }
    
    private func showPrivacyPolicy() {
        presentPrivacyPolicy()
    }
    
    private func showTeamOfUse() {
        presentTermsOfUse()
    }
    
    private func showRateUs() {
        if let windowScene = view.window?.windowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        } else {
            SKStoreReviewController.requestReview()
        }
    }
}


extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: (any Error)?
    ) {
        dismiss(animated: true)
    }
}
