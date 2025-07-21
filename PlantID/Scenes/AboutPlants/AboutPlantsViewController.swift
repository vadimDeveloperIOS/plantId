//
//  AddToMyPlantsViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 26.06.25.
//

import UIKit

class AboutPlantsViewController: UIViewController {

    private lazy var rootView = AboutPlantsView()
    
    var viewModel: AboutPlantsView.Model? {
        didSet {
            guard let viewModel else { return }
            rootView.viewModel = viewModel
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
        view = rootView
        rootView.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .back:
                self.back()
            case .help:
                print("Click help")
            case .add:
                self.goToCarePlan()
            }
        }
    }
    
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
    
    private func goToCarePlan() {
        let vc = CarePlanViewController()
        if let viewModel {
            vc.viewModel =
                .init(
                    id: createId,
                    didAddToMyPlans: false,
                    name: viewModel.name,
                    healthNote: viewModel.description ?? "The plant is healthy",
                    image: viewModel.photos[0],
                    photos: viewModel.photos,
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
