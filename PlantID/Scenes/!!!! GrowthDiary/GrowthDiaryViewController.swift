//
//  GrowthDiaryViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 16.09.25.
//

import UIKit

final class GrowthDiaryViewController: UIViewController {
    
    private let root = GrowthDiaryView()
    private let viewModel = GrowthDiaryViewModel()
    private let startRoot = StartGrowthDiaryView()
    
    override func loadView() {
        view = startRoot
        
        root.actionHandler = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .back:
                self.navigationController?.popToRootViewController(animated: true)
            case .setting:
                self.tabBarController?.selectedIndex = 4
            }
        }
        root.actionHandlerChild = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .edit(index: let index):
                self.editDiary(index: index)
            case .addNew:
                self.addNewDiadry()
            }
        }
        startRoot.actionHandler = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .back:
                self.navigationController?.popToRootViewController(animated: true)
            case .setting:
                self.tabBarController?.selectedIndex = 4
            }
        }
        startRoot.actionHandlerChild = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .addNewPlant:
//                self.addNewDiadry()
                self.showNext()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabBar(true)
        getStories()
    }
    
    private func getStories() {
        viewModel.getData { [weak self] in
            guard let self else { return }
            
            let stories: [GrowthDiaryContent.Model] = self.viewModel.diares.compactMap {
                
                var photo: UIImage?
                if let data = $0.photo, let img = UIImage(data: data) {
                    photo = img
                }
                    
                var notes: [GrowthDiaryContent.Model.NoteModel] = []
                
//                if let n = $0.notes as? Set<Note> {
//                    notes = n.compactMap { val in
//                        .init(
//                            noteTitle: val.title ?? "No value",
//                            noteText: val.noteText ?? "No value"
//                        )
//                    }
//                }
                if let n = $0.notes as? Set<Note> {
                    notes = n
                        .sorted { (lhs: Note, rhs: Note) in
                            let left = Int(lhs.title?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ?? "") ?? 0
                            let right = Int(rhs.title?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ?? "") ?? 0
                            return left < right
                        }
                        .map { val in
                                .init(
                                    noteTitle: val.title ?? "No value",
                                    noteText: val.noteText ?? "No value"
                                )
                        }
                }
                return
                    .init(
                        photo: photo ?? UIImage(named: "empty_photo_add_diary")!,
                        name: $0.name ?? "No value",
                        notes: notes
                    )
            }
            
            startRoot.viewModel = StartGrowthDiaryView.Model(
                headerTitle: TextForStartGrowthDiary.title,
                headerSubtitle: TextForStartGrowthDiary.subtitle,
                steps: [
                    .init(
                        imageName: "step1_icon",
                        stepTitle: TextForStartGrowthDiary.step1Title,
                        stepSubtitle: TextForStartGrowthDiary.step1Subtitle
                    ),
                    .init(
                        imageName: "step2_icon",
                        stepTitle: TextForStartGrowthDiary.step2Title,
                        stepSubtitle: TextForStartGrowthDiary.step2Subtitle
                    ),
                    .init(
                        imageName: "step3_icon",
                        stepTitle: TextForStartGrowthDiary.step3Title,
                        stepSubtitle: TextForStartGrowthDiary.step3Subtitle
                    )
                ],
                bottomText: TextForStartGrowthDiary.bottomText,
                buttonTitle: TextForStartGrowthDiary.addNewPlant
            )
            
            root.viewModel =
                .init(
                    textForFirstLbl: TextForGrowthDiary.title,
                    textForSecondLbl: TextForGrowthDiary.subtitle,
                    textForThirdLbl: TextForGrowthDiary.plantStories,
                    stories: stories,
                    btn:
                            .init(
                                title: "add_new_plant_title".localized,
                                backgroundImageName: "my_plants_btnn"
                            )
                )
        }
    }
    
    private func editDiary(index: Int) {
        guard index >= 0, index < viewModel.diares.count else { return }

        let vc = AddDiaryViewController()
        let selectedDiary = viewModel.diares[index]
        
        var photo: UIImage?
        if let data = selectedDiary.photo, let img = UIImage(data: data) {
            photo = img
        }
        
        var notes: [AddDiaryContent.Model.Note] = []
//        if let n = selectedDiary.notes as? Set<Note> {
//            notes = n.compactMap { val in
//                .init(
//                    title: val.title ?? "No value",
//                    text: val.noteText ?? "No value"
//                )
//            }
//        }
        if let n = selectedDiary.notes as? Set<Note> {
            notes = n
                .sorted { (lhs: Note, rhs: Note) in
                    let left = Int(lhs.title?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ?? "") ?? 0
                    let right = Int(rhs.title?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ?? "") ?? 0
                    return left < right
                }
                .map { val in
                    AddDiaryContent.Model.Note(
                        title: val.title ?? "No value",
                        text: val.noteText ?? "No value"
                    )
                }
        }
        vc.viewModel =
            .init(
                textFirstTitle: TextForAddDiary.title,
                textSecondTitle: TextForAddDiary.subtitle,
                textThirdTitle: TextForAddDiary.addNewPlant,
                cellModel:
                        .init(
                            id: selectedDiary.id,
                            photo: photo,
                            name: selectedDiary.name,
                            notes: notes
                        ),
                textButton: TextForAddDiary.save
                
            )
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addNewDiadry() {
        
        let vc = AddDiaryViewController()
        vc.viewModel =
            .init(
                textFirstTitle: TextForAddDiary.title,
                textSecondTitle: TextForAddDiary.subtitle,
                textThirdTitle: TextForAddDiary.addNewPlant,
                cellModel:
                        .init(
                            id: nil,
                            photo: nil,
                            name: nil,
                            notes: [ ]),
                textButton: TextForAddDiary.save
            )
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showNext() {
        view = root
    }
}
