//
//  ProFeatureService.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 17.07.25.
//

import Foundation
import ApphudSDK
import StoreKit

enum ProductType: String, CaseIterable {
    case monthly = "monthly.s" // <--- Product ID for monthly
    case weekly = "weekly.s" // <--- Product ID for weekly
    case yearly = "annual.s" // <--- Product ID for yearly
    case sale = "sale.s"
    case sales = "sale.ss"
}

enum ProFeatureServiceError: Error {
    case unexpected
}

protocol ProFeatureServiceObserver: AnyObject {
    
    func didChangeProStatus(newStatus: Bool)
}

final class ProFeatureProduct {
    let apphudProduct: ApphudProduct
    let product: Product?
    
     init(apphudProduct: ApphudProduct, product: Product?) {
        self.apphudProduct = apphudProduct
        self.product = product
    }
}

final class ProFeatureService {
    
    // MARK: - Constants
    
    private enum Constants {
        static let appHudAPIKey = "app_iw1pEXDVeLb71QAm4h5whJxnnra2aF"
    }
    
    // MARK: - Properties
    
    static let shared = ProFeatureService()
    private var observers = [Weak<ProFeatureServiceObserver>]()
    private(set) var appProducts: [SKProduct] = []
    var hasSubscription = false
    
    // MARK: - Init
    
    private init() { }
    
    // MARK: - Interface
    
    @MainActor func initiate() {
        Apphud.start(apiKey: Constants.appHudAPIKey, observerMode: true)
        fetchPlacements { _ in }
    }
    
    // Получение всех продуктов
    func fetchPlacements(completion: @escaping Closure<[SKProduct]>) {
        guard let products = Apphud.products else {
            print("⛔️ ⛔️ ⛔️ Apphud.products равен nil")
            return
        }
        var result = [SKProduct]()
        for product in products {
            result.append(product)
        }
        appProducts = result
        completion(result)
    }
    
    // Покупка подписки с выбранным productID
    func purchase(_ productID: ProductType, completion: @escaping Closure<Swift.Result<Void, Error>>) {
        Task {
            await Apphud.purchase(productID.rawValue) { [weak self] result in
                guard let self else { return }
                if let subscription = result.subscription, subscription.isActive() == true {
                    completion(.success(()))
                } else if let purchase = result.nonRenewingPurchase, purchase.isActive() == true {
                    completion(.success(()))
                } else {
                    completion(.failure(result.error ?? ProFeatureServiceError.unexpected))
                }
                let newStatus = self.getHasActiveSubscription()
                self.hasSubscription = newStatus
                observers.forEach { $0.value?.didChangeProStatus(newStatus: newStatus) }
            }
        }
    }
    
    func getHasActiveSubscription() -> Bool {
        return Apphud.hasActiveSubscription()
    }
    
    func updateStatus() {
        hasSubscription = Apphud.hasActiveSubscription()
    }
    
    func restorePurchases() {
        Task {
            await Apphud.restorePurchases()
        }
    }
    
    func formattedPrice(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale  // Используем локаль продукта
        return formatter.string(from: product.price)
    }

    func addObserver(_ observer: ProFeatureServiceObserver) {
        observers.append(Weak(value: observer))
    }
    
    func removeObserver(_ observer: AnyObject) {
        observers.removeAll(where: { $0 === observer })
    }
}

class Weak<T> {
    private weak var _value: AnyObject?
    
    var value: T? {
        return _value as? T
    }
    
    init(value: T) {
        self._value = value as AnyObject
    }
}

typealias ClosureVoid = () -> Void
typealias Closure<T> = (T) -> Void


extension SKProduct {
    var localizedPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 2
        formatter.locale = self.priceLocale
        
        guard let priceString = formatter.string(from: self.price),
              let period = self.subscriptionPeriod else {
            return nil
        }
        let periodString: String
        switch period.unit {
        case .day: periodString = "/Day"
        case .week: periodString = "/Week"
        case .month: periodString = "/Month"
        case .year: periodString = "/Year"
        @unknown default: periodString = ""
        }
        return "\(priceString) \(periodString)"
    }
}

