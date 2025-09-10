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
            case .header(_):
                break
            case .aboutInfo(_):
                break
            case .photos(index: let index):
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
        newValue.plantName = viewModel.aboutInfo.titleAccent
        newValue.plantDescr = viewModel.plantInfo.paragraphs.first
        newValue.photos = jpegDatas as NSArray
        newValue.plantSize = "plantSize"
        newValue.plantHumidity = "plantHumidity"
        newValue.plantSpraying = "plantSpraying"
        newValue.plantFertilize = "plantFertilize"
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
                    name: "NAME",
                    healthNote: "The plant is healthy",
                    image: viewModel.photos.photos.first?.image ?? UIImage(named: "fake123")!,
                    photos: viewModel.photos.photos.compactMap { $0.image } ,
                    frequencyVal: nil,
                    reminderVal: nil,
                    amountVal: nil
                )
        }
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
