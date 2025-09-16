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
    
    override func loadView() {
        view = root
        
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
                self.showAddOrEdit()
            }
            root.needToHideBack = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        test1()
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
                
                if let n = $0.notes as? Set<Note> {
                    notes = n.compactMap { val in
                        .init(
                            noteTitle: val.title ?? "No value",
                            noteText: val.noteText ?? "No value"
                        )
                    }
                }
                return
                    .init(
                        photo: photo ?? UIImage(systemName: "photo.circle")!.withTintColor(#colorLiteral(red: 0.6107943058, green: 0.7969731688, blue: 0.4673035145, alpha: 1)),
                        name: $0.name ?? "No value",
                        notes: notes
                    )
            }
            
            root.viewModel =
                .init(
                    textForFirstLbl: TextForGrowthDiary.title,
                    textForSecondLbl: TextForGrowthDiary.subtitle,
                    textForThirdLbl: TextForGrowthDiary.plantStories,
                    stories: stories
                )
        }
    }
    
    private func test1() {
        
        root.viewModel =
            .init(
                textForFirstLbl: TextForGrowthDiary.title,
                textForSecondLbl: TextForGrowthDiary.subtitle,
                textForThirdLbl: TextForGrowthDiary.plantStories,
                stories: [
                    
                    .init(
                        photo: UIImage(systemName: "photo.circle")!.withTintColor(#colorLiteral(red: 0.6107943058, green: 0.7969731688, blue: 0.4673035145, alpha: 1), renderingMode: .alwaysOriginal),
                        name: "Text Name",
                        notes: [
                            .init(
                                noteTitle: "Week 1",
                                noteText: "SomeText week 1 SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText"
                            ),
                            .init(
                                noteTitle: "Week 2",
                                noteText: "SomeText week 2 SomeText SomeText SomeText"
                            )
                        ]),
                    
                        .init(
                            photo: UIImage(systemName: "photo.circle")!.withTintColor(#colorLiteral(red: 0.6107943058, green: 0.7969731688, blue: 0.4673035145, alpha: 1), renderingMode: .alwaysOriginal),
                            name: "Plant 2",
                            notes: [
                                .init(
                                    noteTitle: "Week 3",
                                    noteText: "SomeTe week 3 SomeTextxt SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText SomeText"
                                ),
                                .init(
                                    noteTitle: "Week 4",
                                    noteText: "SomeText week 4 SomeText SomeText  SomeText SomeText SomeText "
                                )
                            ])
                ])
        
    }
    
    // TEST
    private func showAddOrEdit() {
        let vc = AddDiaryViewController()
        vc.viewModel =
            .init(
                textFirstTitle: TextForAddDiary.title,
                textSecondTitle: TextForAddDiary.subtitle,
                textThirdTitle: TextForAddDiary.addNewPlant,
                cellModel:
                        .init(
                            photo: UIImage(named: "fake123"),
                            name: "Some plant",
                            notes: [
                                
                                .init(
                                    title: "Week 1",
                                    text: "Some week 1 text some text some text some text some text some text some text some text some text some text some text"
                                ),
                                
                                .init(
                                    title: "Week 4",
                                    text: "Some week 4 text"
                                )
                            ]),
                textButton: TextForAddDiary.save
            )
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
