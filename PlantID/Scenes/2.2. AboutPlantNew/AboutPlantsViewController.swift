//
//  AddToMyPlantsViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 26.06.25.
//

import UIKit

class AboutPlantsViewController: UIViewController {

//    private lazy var rootView = AboutPlantsView()
    private lazy var testRoot = AboutPlantViewNew()
    
    var viewModel: AboutPlantViewNew.Model? {
        didSet {
            guard let viewModel else { return }
            testRoot.viewModel = viewModel
            saveToHistory()
        }
    }
    private let createId = UUID()
    var plantType: String?
    var currentCondition: String?
    var conditionValue: Float?
    var isHealthy: Bool?
    var frequencyVal: String?
    
    override func loadView() {
        view = testRoot
        
        testRoot.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
//            case .back:
//                self.back()
//            case .help:
//                print("Click help")
//            case .add:
//                self.goToCarePlan()
            case .header(let vi):
                switch vi {
                case .tapLeft:
                    back()
                case .tapRightTop:
                    self.tabBarController?.selectedIndex = 4
                }
            case .aboutInfo(_):
                break
            case .photos(_):
                break
            case .addToMyPlants:
                self.goToCarePlan()
            }
        }
    }
    
    /*
    private func saveToHistory() {
        guard let viewModel else { return }
        
        let jpegDatas = viewModel.photos
            .compactMap { $0.jpegData(compressionQuality: 0.8) }
                
        let newValue = CoreDataSevice.shared.createPlantInfo()
        newValue.id = createId
        newValue.didAddToMyPlants = false
        newValue.plantName = viewModel.name
        newValue.plantDescr = viewModel.description
        newValue.photos = jpegDatas as NSArray
        newValue.plantSize = viewModel.size
        newValue.plantHumidity = viewModel.humidity
        newValue.plantSpraying = viewModel.spraying
        newValue.plantFertilize = viewModel.fertilize
        do {
            try CoreDataSevice.shared.saveData()
            print("✅ Растение успешно сохранено в историю")
        } catch {
            print("🛑 Ошибка сохранения в историю: \(error)")
            return
        }
    }
     */
    // Для теста, удалить
    private func saveToHistory() {
        guard let viewModel else { return }
        
        let jpegDatas = viewModel.photos.photos.compactMap { $0.image?.jpegData(compressionQuality: 0.8) }
        
        let newValue = CoreDataSevice.shared.createPlantInfo()
        newValue.id = createId
        newValue.didAddToMyPlants = false
        newValue.plantName = viewModel.aboutInfo.plantNameValue
        newValue.plantDescr = viewModel.plantInfo.paragraphs.first
        newValue.photos = jpegDatas as NSArray
        newValue.plantSize = nil
        newValue.plantHumidity = nil
        newValue.plantSpraying = nil
        newValue.plantFertilize = nil
        do {
            try CoreDataSevice.shared.saveData()
            print("✅ Растение успешно сохранено в историю")
        } catch {
            print("🛑 Ошибка сохранения в историю: \(error)")
            return
        }
    }
    
    private func goToCarePlan() {
        let vc = CarePlanViewController()
        if let viewModel {
            vc.viewModel =
                .init(
                    id: createId,
                    didAddToMyPlans: false,
                    name: viewModel.aboutInfo.plantNameValue,
                    healthNote: (viewModel.plantInfo.paragraphs.last ?? viewModel.plantInfo.paragraphs.first) ?? "The plant is healthy",
                
                    image: viewModel.photos.photos.first?.image ?? UIImage(named: "not.plant.1")!,
                    photos: viewModel.photos.photos.compactMap { $0.image } ,
                    frequencyVal: nil,
                    reminderVal: nil,
                    amountVal: nil
                )
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
