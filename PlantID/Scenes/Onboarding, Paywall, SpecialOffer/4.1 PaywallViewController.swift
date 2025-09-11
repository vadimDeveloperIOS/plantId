//
//  PaywallViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 8.07.25.
//

import UIKit
import StoreKit

final class PaywallViewController: UIViewController {
    
    private lazy var rootView = OnboardingFourthView()
    private var selectedIndexOfPrice = 0
    
    private var priceModels: [PriceModelPayWall] {
        return ProFeatureService.shared.appProducts.compactMap { product in
            guard let type = ProductType.allCases.first(where: { $0.rawValue == product.productIdentifier }) else {
                return nil // если не найдётся соответствия — пропускаем
            }
            let fullPrice = product.localizedPrice ?? "No value"
            let weekly = weeklyPriceString(for: product)

            return PriceModelPayWall(
                price: fullPrice,
                priceWeek: weekly,
                productType: type
            )
        }
    }

    var nextPageHandler: (() -> Void)?
    
    override func loadView() {
        view = rootView
        rootView.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .continueAndMakePay:
                self.makePurchase(selectedIndexOfPrice)
            case .selectPlan(let index):
                self.selectedIndexOfPrice = index
            case .noPaymentNow:
                print("нажата кнопка noPaymentNow")
            case .showHomeView:
                self.leaveView()
            case .privacyPolicy:
                self.presentPrivacyPolicy()
            case .termsOfUse:
                self.presentTermsOfUse()
            case .restorePurchases:
                ProFeatureService.shared.restorePurchases()
            case .scrolledDown:
                self.rootView.needToShowNoPaymentNow = true
            case .startedScroll:
                self.rootView.needToHideAnimation = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaultsService.shared.hasSeenOnboarding = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // это убрать
        if priceModels == [] {
            rootView.viewModel =
                .init(
                    header: .init(page: 3),
                    price: [
                        .init(price: "The $ no price/ no period", priceWeek: "0.00", productType: .yearly),
                        
                    ],
                    comments: .init(i: true)
                )
        }
        else {
        // до этой строчки (включительно) удалить
        
            rootView.viewModel =
                .init(
                    header: .init(page: 3),
                    price: priceModels,
                    comments: .init(i: true))
        } // и это
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) { [weak self] in
            guard let self else { return }
            self.rootView.needToShowXButton = true
        }
    }
    
    private func leaveView() {
        if let _ = navigationController {
            nextPageHandler?()
        } else {
            dismiss(animated: true)
        }
    }
    
    private func makePurchase(_ indexCell: Int) {
        let models = priceModels
        guard indexCell < models.count else { return }
        let product = models[indexCell].productType

        ProFeatureService.shared.purchase(product) { [weak self] response in
            guard let self else { return }

            switch response {
            case .success():
                DispatchQueue.main.async {
                    self.leaveView()
                }
            case .failure(let error):
                print("🛑 🛑 🛑 Ошибка при совершении покупки - - -", error)
                let alert = UIAlertController(
                    title: "Payment error",
                    message: "Please try paying for your subscription later.",
                    preferredStyle: .alert
                )
                alert.addAction(.init(title: "OK", style: .default))
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    private func weeklyPriceString(for product: SKProduct) -> String {
        guard let period = product.subscriptionPeriod else { return "" }

        // Подсчитываем количество недель в периоде
        let weeksInPeriod: Decimal
        switch period.unit {
        case .day:
            weeksInPeriod = Decimal(period.numberOfUnits) / 7
        case .week:
            weeksInPeriod = Decimal(period.numberOfUnits)
        case .month:
            weeksInPeriod = Decimal(period.numberOfUnits) * 4.345 // среднее недель в месяце
        case .year:
            weeksInPeriod = Decimal(period.numberOfUnits) * 52
        @unknown default:
            return ""
        } 

        // Считаем цену в неделю
        let price = product.price as Decimal
        let weeklyPrice = price / weeksInPeriod

        // Форматируем как строку с 2 знаками после запятой
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2

        return formatter.string(from: weeklyPrice as NSDecimalNumber) ?? ""
    }
}
