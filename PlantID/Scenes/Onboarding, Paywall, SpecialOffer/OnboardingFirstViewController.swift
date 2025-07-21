//
//  OnboardingFirstViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 7.07.25.
//

import UIKit
import AdSupport
import AppTrackingTransparency
import ApphudSDK


final class OnboardingFirstViewController: UIViewController {
    
    private lazy var rootView = OnboardingFirstView()
    var nextPageHandler: (() -> Void)?
    
    override func loadView() {
        view = rootView
        rootView.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .cont:
                nextPageHandler?()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.requestTrackingPermission()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.currentPage = 0
    }
    
    private func requestTrackingPermission() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .notDetermined:
                print("notDetermined")
            case .restricted:
                print("restricted")
            case .denied:
                print("denied")
            case .authorized:
                let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                let idfv = UIDevice.current.identifierForVendor?.uuidString
                Apphud.setDeviceIdentifiers(idfa: idfa, idfv: idfv)
            @unknown default:
                print("@unknown")
            }
        }
    }
}
