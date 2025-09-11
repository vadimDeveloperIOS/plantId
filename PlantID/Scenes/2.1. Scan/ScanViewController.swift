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
        
        // parent
        rootView.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .back:
                self.close()
            case .setting:
                self.tabBarController?.selectedIndex = 4
            }
        }
        
        // child
        rootView.actionHandlerChild = { [weak self] action in
            guard let self else { return }
            
            switch action {
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
        
        guard rootView.thumbnails != [] else {
            print("🟥 [ScanViewController] - \(#function) нет фотографий \n")
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }
        
        PlantIDClient.shared.identifyPlant( images: rootView.thumbnails) { [weak self] result in
            guard let self else { return }
            switch result {
                
            case .success(let result):
                let vc = AboutPlantsViewController()
                
                guard let firstSuggestion = result.result.classification?.suggestions?.first else { return
                }
                
                let size = self.detectSize(
                    from: firstSuggestion.details?.description?.value ?? "No value"
                )
                
                let humidity = self.detectHumidity(
                    from: firstSuggestion.details?.bestLightCondition,
                    watering: nil
                )
                
                let spraying = self.detectSpraying(
                    from: firstSuggestion.details?.description?.value ?? "No value"
                )
                
                let fertilize = self.detectFertilize(
                    from: firstSuggestion.details?.bestSoilType,
                    description: firstSuggestion.details?.description?.value ?? "No value"
                )
                
                
                vc.viewModel =
                    .init(
                        header:
                                .init(
                                    photo: rootView.thumbnails.first!,
                                    title: "",
                                    leftIconName: "navbar_str",
                                    rightTopIconName: "navbar_set",
                                    rightBottomIconName: ""
                                ),
                        aboutInfo:
                                .init(
                                    titlePrimary: "About",
                                    titleAccent: "Plant",
                                    plantNamePrefix: "Plant Name",
                                    plantNameValue: firstSuggestion.name ?? "no_value".localized,
                                    params: [
                                        .init(
                                            iconAsset: "new_size",
                                            title: TextForAboutPlant.size,
                                            value: size
                                        ),
                                        .init(
                                            iconAsset: "new_humidity",
                                            title: TextForAboutPlant.humidity,
                                            value: humidity
                                        ),
                                        .init(
                                            iconAsset: "new_spraying",
                                            title: TextForAboutPlant.spraying,
                                            value: spraying
                                        ),
                                        .init(
                                            iconAsset: "new_fertilze",
                                            title: TextForAboutPlant.fertilize,
                                            value: fertilize
                                        )
                                    ]
                                ),
                        plantInfo:
                                .init(
                                    title: "Plant info",
                                    paragraphs: [
                                        firstSuggestion.details?.description?.value ?? "no_value".localized,
                                        
                                        firstSuggestion.details?.bestWatering ?? ""
                                    ]
                                ),
                        photos:
                                .init(
                                    title: "Photos",
                                    photos: rootView.thumbnails.map {
                                        .init(image: $0)
                                    },
                                    selectedIndex: nil
                                ),
                        primaryCTA:
                                .init(
                                    title: TextForAboutPlant.but,
                                    backgroundImageName: "my_plants_btnn"
                                    
                                )
                    )
                
                vc.plantType = firstSuggestion.details?.taxonomy?.phylum ?? "indoor".localized
                
                vc.currentCondition = "needs_care".localized
                vc.conditionValue = Float(result.result.isHealthy?.probability ?? 0.0)
                vc.isHealthy = result.result.isHealthy?.binary ?? true
                vc.frequencyVal = wateringFrequency(
                    minLevel: firstSuggestion.details?.watering?.min ?? 2,
                    maxLevel: firstSuggestion.details?.watering?.max ?? 2
                )
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print("🟥 🟥 🟥 [ScanViewController] - \(#function) В РЕСПОНСЕ ERROR - - - \(error) \n")
                
                DispatchQueue.main.async {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    // MARK: ДЛЯ ТЕСТОВ (потом удалить)
    /*

    private func goToAboutPlant() {
        
        let arrayPhotos = [UIImage(named: "fake123")!, UIImage(named: "not.plant.2")!]
        let vc = AboutPlantsViewController()
        
        vc.viewModel =
            .init(
                header:
                        .init(
                            photo: UIImage(named: "fake123")!,
                            title: "header - title",
                            leftIconName: "navbar_str",
                            rightTopIconName: "navbar_set",
                            rightBottomIconName: "navbar_q"
                        ),
                aboutInfo:
                        .init(
                            titlePrimary: "aboutInfo - titlePrimary",
                            titleAccent: "aboutInfo - titleAccent",
                            plantNamePrefix: "aboutInfo - plantNamePrefix",
                            plantNameValue: "aboutInfo - plantNameValue",
                            params: [
                                .init(
                                    iconAsset: "new_size",
                                    title: TextForAboutPlant.size,
                                    value: "value"
                                ),
                                .init(
                                    iconAsset: "new_humidity",
                                    title: TextForAboutPlant.humidity,
                                    value: "valuevalue"
                                ),
                                .init(
                                    iconAsset: "new_spraying",
                                    title: TextForAboutPlant.spraying,
                                    value: "valu"
                                ),
                                .init(
                                    iconAsset: "new_fertilze",
                                    title: TextForAboutPlant.fertilize,
                                    value: "va"
                                )
                            ]
                        ),
                plantInfo:
                        .init(
                            title: "title",
                            paragraphs: [
                                "paragraphs paragraphs paragraphs paragraphs paragraphs",
                                "paragraphsparagraphs"
                            ]),
                photos:
                        .init(
                            title: "Photos",
                            photos: [.init(image: UIImage(named: "fake123"))],
                            selectedIndex: 0
                        ),
                primaryCTA:
                        .init(
                            title: TextForAboutPlant.but,
                            backgroundImageName: "my_plants_btnn"
                            
                        )
            )
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
     */
    
    
    private func goToDiagnosticResult() {
        
        guard rootView.thumbnails != [] else {
            print("🟥 [ScanViewController] - \(#function) нет фотографий \n")
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }
        
        PlantIDClient.shared.identifyPlantWithHealth(images: rootView.thumbnails) { [weak self] response in
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
                        header:
                                .init(
                                    photo: rootView.thumbnails.first!,
                                    title: "",
                                    leftIconName: "navbar_str",
                                    rightTopIconName: "navbar_set",
                                    rightBottomIconName: ""
                                ),
                        firstInformation:
                                .init(
                                    namePlant: result.result.classification?.suggestions?.first?.name ?? "no_value".localized,
                                    currentDiagnoses: result.result.disease?.suggestions?.first?.name ?? "no_value".localized,
                                    currentDiagnosesIconName: "currentDiagnosesIconName_new",
                                    currentDiagnosesTitle: "current_diagnoses".localized,
                                    plantType: result.result.classification?.suggestions?.first?.details?.taxonomy?.phylum ?? "indoor".localized,
                                    plantTypeIconName: "plantTypeIconName_new",
                                    currentCondition: "needs_care".localized,
                                    currentConditionIconName: "currentConditionIconName_new"
                                ),
                        photos:
                                .init(
                                    title: "Photos",
                                    photos: rootView.thumbnails.map {
                                        return .init(image: $0)
                                    },
                                    selectedIndex: nil
                                ),
                        condition:
                                .init(
                                    textValue: "Condition",
                                    conditionValue: condVal
                                ),
                        diagnosis:
                                .init(
                                    diagnoses: arrayDiagnos
                                ),
                        button:
                                .init(
                                    title: TextForAboutPlant.but,
                                    backgroundImageName: "my_plants_btnn"
                                    
                                )
                    )
                
                 
                /*
                 
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
                 */
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print("🟥 🟥 🟥 [ScanViewController] - - - \(#function) В РЕСПОНСЕ ERROR - - -\(error) \n")
                
                DispatchQueue.main.async {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
     
    
    // MARK: ДЛЯ ТЕСТОВ (потом удалить)
    /*
    private func goToDiagnosticResult() {
        
        let arrayPhotos = [UIImage(named: "fake123")!, UIImage(named: "not.plant.2")!]

        let vc = DiagnosticResultViewController()
        vc.viewModel =
            .init(
                header:
                        .init(
                            photo: UIImage(named: "fake123")!,
                            title: "title2",
                            leftIconName: "navbar_str",
                            rightTopIconName: "navbar_set",
                            rightBottomIconName: "navbar_q"
                        ),
                firstInformation:
                        .init(
                            namePlant: "namePlant2",
                            currentDiagnoses: "currentDiagnoses23323",
                            currentDiagnosesIconName: "currentDiagnosesIconName_new",
                            currentDiagnosesTitle: "currentDiagnosesTitle",
                            plantType: "plantType",
                            plantTypeIconName: "plantTypeIconName_new",
                            currentCondition: "currentCondition",
                            currentConditionIconName: "currentConditionIconName_new"
                        ),
                photos:
                        .init(
                            title: "",
                            photos: [
                                .init(
                                    image: arrayPhotos.first
                                ),
                                .init(
                                    image: arrayPhotos[1]
                                )
                            ],
                            selectedIndex: nil
                        ),
                condition:
                        .init(
                            textValue: "textValue",
                            conditionValue: 2
                        ),
                diagnosis:
                        .init(
                            diagnoses: [
                                .init(
                                    name: "diagnosis",
                                    probability: 2
                                ),
                                .init(
                                    name: "diagnosis344334",
                                    probability: 3
                                )
                            ]
                        ),
                button:
                        .init(
                            title: TextForAboutPlant.but,
                            backgroundImageName: "my_plants_btnn"
                        )
            )
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
     */

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
    
    // Определение размера растения
    func detectSize(from description: String) -> String {
        if description.lowercased().contains("dwarf") || description.contains("10–15 cm") {
            return "small"
        } else if description.lowercased().contains("shrub") || description.contains("60 cm") {
            return "medium"
        } else {
            return "big"
        }
    }

    // Определение уровня влажности
    func detectHumidity(from bestSoil: String?, watering: String?) -> String {
        if let soil = bestSoil?.lowercased(), soil.contains("sandy") || soil.contains("gravel") {
            return "low"
        } else if watering != nil {
            return "medium"
        } else {
            return "high"
        }
    }

    // Нужно ли опрыскивать
    func detectSpraying(from description: String) -> String {
        if description.lowercased().contains("succulent") || description.lowercased().contains("cactus") {
            return "no"
        } else {
            return "yes"
        }
    }

    // Подкормка
    func detectFertilize(from bestSoil: String?, description: String) -> String {
        if let soil = bestSoil?.lowercased(), soil.contains("poor") {
            return "low"
        } else if description.lowercased().contains("organic matter") {
            return "medium"
        } else {
            return "high"
        }
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
