//
//  HomeViewModel.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 3.07.25.
//

import Foundation

final class HomeViewModel {
    
    private(set) var myPlants: [PlantInfo] = []
    private(set) var history: [PlantInfo] = []
    private(set) var diares: [GrowthDiary] = []
    
    func getArrayOfPlants(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let plants: [PlantInfo] = try CoreDataSevice.shared.fetchCarePlans()
                DispatchQueue.main.async {
                    self.myPlants = plants.filter { $0.didAddToMyPlants }
                    self.history = plants.filter { !$0.didAddToMyPlants }
                    completion()
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func getDiaries(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let stories: [GrowthDiary] = try CoreDataSevice.shared.getGrowthDiaries()
                DispatchQueue.main.async {
                    self.diares = stories
                    completion()
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
}
