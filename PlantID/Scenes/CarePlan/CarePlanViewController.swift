//
//  CarePlanViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 27.06.25.
//

import UIKit

class CarePlanViewController: UIViewController {

    private lazy var rootView = CarePlanView()
    
    var viewModel: CarePlanView.Model? {
        didSet {
            guard let viewModel else { return }
            rootView.viewModel = viewModel
        }
    }
    var waternig: Int?
    var isOnSwitch: Bool?
    var onShowDropdown: OptionsForFrequency?

    override func loadView() {
        view = rootView
        rootView.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .back:
                self.back()
            case .help:
                print("HELP BUTTON")
            case .save:
                self.saveToMyPlants()
            case .waternigVal(let val):
                self.waternig = val
            case .reminderOn(let val):
                self.isOnSwitch = val
            case .onShowDropdown(let val):
                self.onShowDropdown = val
            }
        }
    }
    
    private func back() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    private func saveToMyPlants() {
        
        guard let viewModel else { return }
        
        if viewModel.id == nil {
            createNewPlantAndSave(viewModel)
        }
        
        // План создается из истории или с идентификации
        else if let uuid = viewModel.id,
                viewModel.didAddToMyPlans == false {
            
            do {
                if let plant = try CoreDataSevice.shared.fetchPlantInfo(id: uuid) {
                    plant.didAddToMyPlants = true
                    
                    if let newFrequency = onShowDropdown?.rawValue {
                        plant.frequencyVal = newFrequency
                        print("✅ Обновлен frequencyVal: \(newFrequency)")
                    }
                    
                    // Обновляем reminderVal если есть новое значение
                    if let newReminder = isOnSwitch {
                        plant.reminderVal = newReminder
                        print("✅ Обновлен reminderVal: \(newReminder)")
                    }
                    
                    // Обновляем amountVal если есть новое значение
                    if let newAmount = waternig {
                        plant.amountVal = Int16(newAmount)
                        print("✅ Обновлен amountVal: \(newAmount)")
                    }
                    
                    // Создадим уведомление
                    createNotification(
                        uuid,
                        plant.plantName ?? "NO VALUE",
                        plant.frequencyVal ?? OptionsForFrequency.onceEveryTwoWeeks.rawValue.localized,
                        switchIsOn: plant.reminderVal
                    )
                    try CoreDataSevice.shared.saveData()
                    print("💾 Растение успешно перемещено из ИСТОРИИ в МОИ ПЛАНЫ и сохранено в CoreData")
                }
            }
            catch {
                print("🛑 \(#function) - Данные не обновлены")
            }
        }
        
        // Редактирование уже существующего плана
        else if let uuid = viewModel.id,
                viewModel.didAddToMyPlans == true {
            
            do {
                if let plant = try CoreDataSevice.shared.fetchPlantInfo(id: uuid) {
                    
                    if let newFrequency = onShowDropdown?.rawValue {
                        plant.frequencyVal = newFrequency
                        print("✅ Обновлен frequencyVal: \(newFrequency)")
                    }
                    
                    // Обновляем reminderVal если есть новое значение
                    if let newReminder = isOnSwitch {
                        plant.reminderVal = newReminder
                        print("✅ Обновлен reminderVal: \(newReminder)")
                    }
                    
                    // Обновляем amountVal если есть новое значение
                    if let newAmount = waternig {
                        plant.amountVal = Int16(newAmount)
                        print("✅ Обновлен amountVal: \(newAmount)")
                    }
                    
                    // Создадим уведомление
                    createNotification(
                        uuid,
                        plant.plantName ?? "NO VALUE",
                        plant.frequencyVal ?? OptionsForFrequency.onceEveryTwoWeeks.rawValue.localized,
                        switchIsOn: plant.reminderVal
                    )
                    try CoreDataSevice.shared.saveData()
                    print("💾 Данные успешно сохранены в CoreData")
                }
            }
            catch {
                print("🛑 \(#function) - Данные не обновлены")
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            if let nav = self.navigationController {
                nav.popToRootViewController(animated: true)
            }
            else {
                dismiss(animated: true) {
                    NotificationCenter.default.post(name: .needUpdateInfornation, object: nil)
                }
            }
        }
    }
    
    private func createNewPlantAndSave(_ viewModel: CarePlanView.Model) {
        
        let jpegDatas = viewModel.photos
            .compactMap { $0.jpegData(compressionQuality: 0.8) }
        
        let newValue = CoreDataSevice.shared.createPlantInfo()
        let newId = UUID()
        newValue.id = newId
        newValue.plantName = viewModel.name
        newValue.amountVal = Int16(waternig ?? 1)
        newValue.didAddToMyPlants = true
        newValue.photos = jpegDatas as NSArray
        newValue.reminderVal = isOnSwitch ?? false
        newValue.plantDescr = viewModel.healthNote
        newValue.frequencyVal = onShowDropdown?.rawValue ?? OptionsForFrequency.every3Days.rawValue.localized
        
        print("🌱 Создание нового растения: \(viewModel.name)")
        print("📊 Значения - frequencyVal: \(newValue.frequencyVal ?? "nil"), reminderVal: \(newValue.reminderVal), amountVal: \(newValue.amountVal)")
        
        //Создадим уведомление
        createNotification(
            newId,
            viewModel.name,
            newValue.frequencyVal ?? OptionsForFrequency.onceEveryTwoWeeks.rawValue.localized,
            switchIsOn: newValue.reminderVal
        )
        
        do {
            try CoreDataSevice.shared.saveData()
            print("💾 Новое растение успешно сохранено в CoreData")
        }
        catch {
            print("🛑 Ошибка сохранения нового растения: \(error)")
        }
    }
    
    private func createNotification(_ id: UUID,_ name: String,_ freqVal: String, switchIsOn: Bool) {
        if switchIsOn == true {
            NotificationService.shared.scheduleWateringNotification(
                for: id,
                plantName: name,
                frequency: OptionsForFrequency(rawValue: freqVal.localized) ?? OptionsForFrequency.onceEveryTwoWeeks)
        } else {
            NotificationService.shared.removeNotification(for: id)
        }
    }
}
