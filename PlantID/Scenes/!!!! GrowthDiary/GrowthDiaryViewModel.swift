//
//  GrowthDiaryViewModel.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 16.09.25.
//

import Foundation

final class GrowthDiaryViewModel {
    
    private(set) var diares: [GrowthDiary] = []
    
    func getData(completion: @escaping () -> Void) {
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
