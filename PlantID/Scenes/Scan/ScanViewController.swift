//
//  ScanViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit
import PhotosUI

class ScanViewController: UIViewController {
    
    enum WhichRequest {
        case ident
        case diagnostic
    }
    
    var whichRequest: WhichRequest = .ident
    
    private lazy var rootView = ScannerView()
    
    override func loadView() {
//        rootView.enableScanning = true

        view = rootView
        rootView.actionHandlerChild = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .back:
                self.close()
            case .gallery:
                self.openMultiPicker()
            case .createPhoto:
                break
            case .add:
                self.rootView.enableScanning = false
                switch whichRequest {
                case .ident:
                    self.goToAboutPlant()
                case .diagnostic:
                    self.goToDiagnosticResult()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        rootView.enableScanning = true
        tabBarController?.hideTabBar(true)
        rootView.needToHideIndicztor = true
    }
    
    func close() {
        self.navigationController?.popViewController(animated: true)
        tabBarController?.hideTabBar(false)
    }
        
    private func goToAboutPlant() {
        let arrayPhotos = rootView.thumbnails
        PlantIDClient.shared.identifyPlant(
            images: arrayPhotos) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let result):
                    let vc = AboutPlantsViewController()
                    vc.viewModel = .init(
                        name: result.result.classification?.suggestions?[0].name ?? "no_value".localized,
                        description: result.result.classification?.suggestions?[0].details?.description?.value,
                        photos: arrayPhotos,
                        size: "medium".localized,
                        humidity: wateringFrequency(
                            minLevel: result.result.classification?.suggestions?[0].details?.watering?.min ?? 2,
                            maxLevel: result.result.classification?.suggestions?[0].details?.watering?.max ?? 2
                        ),
                        spraying: "in_4_days".localized,
                        fertilize: "in_30_days".localized
                    )
                    vc.plantType = result.result.classification?.suggestions?[0].details?.taxonomy?.phylum ?? "indoor".localized
                    vc.currentCondition = "needs_care".localized
                    vc.conditionValue = Float(result.result.isHealthy?.probability ?? 0.0)
                    vc.isHealthy = result.result.isHealthy?.binary ?? true
                    vc.frequencyVal = wateringFrequency(
                        minLevel: result.result.classification?.suggestions?[0].details?.watering?.min ?? 2,
                        maxLevel: result.result.classification?.suggestions?[0].details?.watering?.max ?? 2
                    )
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                case .failure(let error):
                    print("🟥 🟥 🟥 ОШИБКА \(#function) В РЕСПОНСЕ ERROR - - -", error)
                    let vc = CouldntIdentifyViewController()
                    vc.tabBarController?.hideTabBar(true)
                    
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
    }
    
    private func goToDiagnosticResult() {
        let arrayPhotos = rootView.thumbnails
        PlantIDClient.shared.identifyPlantWithHealth(images: arrayPhotos) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let result):
                let vc = DiagnosticResultViewController()
                
                var arrayDiagnos: [DiagnosesCell.Model] = []
                if let disease = result.result.disease?.suggestions {
                    for d in disease {
                        arrayDiagnos.append(
                            .init(
                                name: d.name,
                                probability: Float(d.probability))
                        )
                    }
                }
                let condVal = setupConditionValue(arrayDiagnos)
                vc.viewModel =
                    .init(
                        namePlant: result.result.classification?.suggestions?[0].name ?? "no_value".localized,
                        diseaseDescr: result.result.disease?.suggestions?[0].details?.description,
                        currentDiagnoses: result.result.disease?.suggestions?[0].name,
                        plantType: result.result.classification?.suggestions?[0].details?.taxonomy?.phylum ?? "indoor".localized,
                        currentCondition: "needs_care".localized,
                        photos: arrayPhotos,
                        conditionValue: condVal,
                        isHealthy: result.result.isHealthy?.binary ?? true,
                        disease: .init(diagnoses: arrayDiagnos)
                    )
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print("🟥 🟥 🟥 ОШИБКА \(#function) В РЕСПОНСЕ ERROR - - -", error)
                let vc = CouldntIdentifyViewController()
                vc.tabBarController?.hideTabBar(true)
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    private func wateringFrequency(minLevel: Int, maxLevel: Int) -> String {
        // Шкала: 1 = dry, 2 = medium, 3 = wet
        switch (minLevel, maxLevel) {
        case (1, 1):
            // Сухо–сухо: очень редкий полив
            return "1_time_in_7_days".localized
        case (1, 2):
            // Сухо–средне
            return "1_time_in_5_days".localized
        case (2, 2):
            // Средне–средне
            return "1_time_in_3_days".localized
        case (2, 3):
            // Средне–влажно
            return "2_times_in_3_days".localized
        case (3, 3):
            // Влажно–влажно
            return "every_day".localized
        default:
            // Любые другие сочетания
            return "1_time_in_4_days".localized
        }
    }
    
    private func setupConditionValue(_ array: [DiagnosesCell.Model]) -> Float {
        var sumVal: Float = 0
        array.forEach { val in
            sumVal = val.probability + sumVal
            print("- - - - - ЗНАЧЕНИЕ : \(sumVal)")
        }
        let result = sumVal / Float(array.count)
        print("RESULT РЕЗУЛЬТАТ", result)
        return result
    }
    
    private func openMultiPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 5    // разрешаем выбрать до 5 штук
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension ScanViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                guard let img = object as? UIImage, error == nil else { return }
                DispatchQueue.main.async {
                    self.rootView.addThumbnail(img)
                }
            }
        }
    }
}
