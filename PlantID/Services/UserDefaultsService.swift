//
//  UserDefaultsService.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 15.07.25.
//

import Foundation

final class UserDefaultsService {
    
    static let shared = UserDefaultsService()
    
    private init() {}

    private let defaults = UserDefaults.standard
    
    // onboardingKey
    private let onboardingKey = "hasSeenOnboarding"

    var hasSeenOnboarding: Bool {
        get {
            defaults.bool(forKey: onboardingKey)
        }
        set {
            defaults.set(newValue, forKey: onboardingKey)
        }
    }
    
    private let limitKey = "diagnosticsLimit"
    
    var diagnosticsLimit: Int {
        get {
            defaults.integer(forKey: limitKey)
        }
        set {
            defaults.set(newValue, forKey: limitKey)
        }
    }
}
