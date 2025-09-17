//
//  AddDiaryViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 16.09.25.
//

import UIKit
import PhotosUI

final class AddDiaryViewController: UIViewController, PHPickerViewControllerDelegate {
    
    private let root = AddDiaryView()
    
    var viewModel: AddDiaryView.Model? {
        didSet {
            guard let viewModel else { return }
            root.viewModel = viewModel
        }
    }
    
    var selectedPhoto: UIImage? {
        didSet {
            guard let selectedPhoto else { return }
            root.cell.changePhoto = selectedPhoto
        }
    }
    
    override func loadView() {
        view = root

        root.actionHandler = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .back:
                self.navigationController?.popViewController(animated: true)
            case .setting:
                self.tabBarController?.selectedIndex = 4
            }
        }
        root.actionHandlerChild = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .addPhoto:
                self.presentPicker()
            case .save:
                self.saveDiary()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        tabBarController?.hideTabBar(true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: MEth
    
    private func saveDiary() {
        
        guard let viewModel else {
            print("🛑 [AddDiaryViewController] ViewModel равен nil")
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }
        
        guard let txtName = root.cell.fieldName.text,
              txtName != " ", txtName.isEmpty == false else {
            print("🛑 [AddDiaryViewController] пустые поле имени")
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }
        
        //когда создаем новый дневник
        
        if viewModel.cellModel?.id == nil {
            
            let newDiary = CoreDataSevice.shared.createGrowthDiary()
            newDiary.id = UUID()
            newDiary.name = txtName
            newDiary.photo = selectedPhoto?.pngData()
            
            if let weekNumber = root.cell.fieldWeekNumber.text,
               weekNumber != " ", weekNumber.isEmpty == false,
               let noteTxt = root.cell.note.text,
               noteTxt != " ", noteTxt.isEmpty == false {
                
                let newNote = CoreDataSevice.shared.createNote()
                newNote.title = TextForAddDiary.week + " " + weekNumber
                newNote.noteText = noteTxt
                newDiary.addToNotes(newNote)
            }
            
            do {
                try CoreDataSevice.shared.saveData()
                print("💾 [AddDiaryViewController] Новый дневник успешно сохранен в CoreData \n")
            }
            catch {
                print("🛑 [AddDiaryViewController] Ошибка сохранения нового дневника \n")
            }
        }
        
        //редактирование существующего дневника
        
        else if let uuid = viewModel.cellModel?.id {
            
            do {
                let selectedDiary = try CoreDataSevice.shared.getDiary(id: uuid)
                selectedDiary?.name = txtName
                
                if selectedDiary?.photo == nil {
                    selectedDiary?.photo = selectedPhoto?.pngData()
                }
                
                if let weekNumber = root.cell.fieldWeekNumber.text,
                   weekNumber != " ", weekNumber.isEmpty == false,
                   let noteTxt = root.cell.note.text,
                   noteTxt != " ", noteTxt.isEmpty == false {
                    
                    let newNote = CoreDataSevice.shared.createNote()
                    newNote.title = TextForAddDiary.week + " " + weekNumber
                    newNote.noteText = noteTxt
                    selectedDiary?.addToNotes(newNote)
                }

                try CoreDataSevice.shared.saveData()
                print("💾 [AddDiaryViewController] Изменения дневник `\(String(describing: selectedDiary?.name))` успешно сохранены в CoreData \n")
            }
            catch {
                print("🛑 [AddDiaryViewController] Ошибка сохранения отредактированного дневника \n")
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: PICKER
    
    private func presentPicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1          // одно фото
        config.filter = .images            // только изображения
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)

        guard let item = results.first?.itemProvider,
              item.canLoadObject(ofClass: UIImage.self) else { return }
        
        item.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            DispatchQueue.main.async {
                if let img = image as? UIImage {
                    guard let self else { return }
                    self.selectedPhoto = img
                }
            }
        }
    }
    
    // MARK: клава
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        let keyboardHeight = frame.height
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardHeight / 2  // 👈 поднимаем экран
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0  // 👈 возвращаем обратно
        }
    }
}
