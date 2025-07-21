//
//  DiagnosticResultViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 26.06.25.
//

import UIKit

class DiagnosticResultViewController: UIViewController {
    
    private lazy var rootView = DiagnosticsResultView()
    
    var viewModel: DiagnosticsResultView.Model? {
        didSet {
            guard let viewModel else { return }
            rootView.viewModel = viewModel
            saveToHistory()
        }
    }
    
    private let createId = UUID()

    override func loadView() {
        view = rootView
        rootView.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .add:
                self.goToCarePlan()
            case .back:
                self.back()
            case .help:
                print("CLICK HELP")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaultsService.shared.diagnosticsLimit += 1
    }
    
    private func goToCarePlan() {
        let vc = CarePlanViewController()
        if let viewModel {
            vc.viewModel =
                .init(
                    id: createId, //поменять на nil
                    didAddToMyPlans: false, // поменять на nil
                    name: viewModel.namePlant ?? "Plant care",
                    healthNote: viewModel.diseaseDescr ?? "The plant is healthy",
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
        navigationController?.popViewController(animated: true)
    }
    
    private func saveToHistory() {
        guard let viewModel else { return }
        
        let jpegDatas = viewModel.photos
            .compactMap { $0.jpegData(compressionQuality: 0.8) }
        
        let newValue = CoreDataSevice.shared.createPlantInfo()
        newValue.id = createId
        newValue.didAddToMyPlants = false
        newValue.plantName = viewModel.namePlant
        newValue.plantDescr = viewModel.diseaseDescr ?? "The plant is healthy"
        newValue.photos = jpegDatas as NSArray
    
        do {
            try CoreDataSevice.shared.saveData()
            print("✅ Растение успешно сохранено в историю")
        } catch {
            print("🛑 Ошибка сохранения в историю: \(error)")
            return
        }
    }
}
