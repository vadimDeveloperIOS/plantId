//
//  CarePlanView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 27.06.25.
//

import UIKit


//-------------------------------------------------------------------------------------
// MARK: - Second Care Plan Information View  (укороченнная версия экрана)
// ---------------

final class CarePlanView: View {
    
    enum Action {
        case back
        case settings
        case save
        case waternigVal(Int)
        case reminderOn(Bool)
        case onShowDropdown(OptionsForFrequency)
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    struct Model {
        let id: UUID?
        let didAddToMyPlans: Bool?
        let name: String // + надо для этого экрана
        let healthNote: String // + надо для этого экрана
        let image: UIImage // + надо для этого экрана
        let photos: [UIImage] // + надо для этого экрана
        let frequencyVal: String? // + надо для этого экрана
        let reminderVal: Bool? // + надо - это переключатель уведомлений
        let amountVal: Int? // + надо
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            // это когда растение уже было сохранено в "мои планы"
            
            if viewModel.didAddToMyPlans == true {
                nextViewModel =
                    .init(
                        header:
                                .init(
                                    photo: viewModel.image,
                                    title: "",
                                    leftIconName: "navbar_str",
                                    rightTopIconName: "navbar_set",
                                    rightBottomIconName: "navbar_q"
                                ),
                        firstInformation:
                                .init(
                                    title: viewModel.name
                                ),
                        healthNote:
                                .init(
                                    text: viewModel.healthNote
                                ),
                        watering:
                                .init(
                                    frequency: viewModel.frequencyVal ?? OptionsForFrequency.every3Days.rawValue.localized,
                                    reminderOn: viewModel.reminderVal ?? false,
                                    amount: viewModel.amountVal ?? 1
                                ),
                        saveButton:
                                .init(
                                    title: "save_care_plan_big".localized,
                                    backgroundImageName: "my_plants_btnn"
                                )
                    )
            }
            // это когда растение не было сохранено в "мои планы" но хранится в базе как история
            // либо растение не хранилось в базе
            else {
                nextViewModel =
                    .init(
                        header:
                                .init(
                                    photo: viewModel.image,
                                    title: "",
                                    leftIconName: "navbar_str",
                                    rightTopIconName: "navbar_set",
                                    rightBottomIconName: "navbar_q"
                                ),
                        firstInformation:
                                .init(
                                    title: viewModel.name
                                ),
                        healthNote:
                                .init(
                                    text: viewModel.healthNote
                                ),
                        watering:
                                .init(
                                    frequency: OptionsForFrequency.every3Days.rawValue.localized,
                                    reminderOn: false,
                                    amount: 1
                                ),
                        saveButton:
                                .init(
                                    title: "save_care_plan_big".localized,
                                    backgroundImageName: "my_plants_btnn"
                                )
                    )
            }
        }
    }
    
    struct NextModel {
        let header: AboutPlantHeaderCellContent.Model
        let firstInformation: HeaderModel
        let healthNote: HealthNoteModel
        let watering: WateringModel
        let saveButton: PrimaryCTAButtonContent.Model
    }

    var nextViewModel: NextModel? {
        didSet {
            guard let m = nextViewModel else { return }
            var snapshot = Snapshot()
            snapshot.appendSections(Section.allCases)

            snapshot.appendItems([.header(m.header)], toSection: .header)
            snapshot.appendItems([.firstInformation(m.firstInformation)], toSection: .firstInformation)
            snapshot.appendItems([.healthNote(m.healthNote)], toSection: .healthNote)
            snapshot.appendItems([.watering(m.watering)], toSection: .watering)
            snapshot.appendItems([.saveButton(m.saveButton)], toSection: .saveButton)

            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    // MARK: Section & Item

    private enum Section: Hashable, CaseIterable {
        case header
        case firstInformation
        case healthNote
        case watering
        case saveButton
    }

    private enum Item: Hashable {
        case header(AboutPlantHeaderCellContent.Model)
        case firstInformation(HeaderModel)
        case healthNote(HealthNoteModel)
        case watering(WateringModel)
        case saveButton(PrimaryCTAButtonContent.Model)
    }

    // MARK: CollectionView + DataSource

    private typealias Snapshot   = NSDiffableDataSourceSnapshot<Section, Item>
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

    private lazy var collectionView: UICollectionView = {
        let layout = CarePlanView.makeLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.contentInsetAdjustmentBehavior = .never
        cv.bounces = false
        cv.contentInset = .init(top: 0, left: 0, bottom: 40, right: 0)
        return cv
    }()

    private lazy var dataSource: DataSource = {
        // Регистрация каждой ячейки
        
        let headerReg = UICollectionView.CellRegistration<AboutPlantHeaderCell, AboutPlantHeaderCellContent.Model> { cell, _, model in
            cell.viewModel = model
            cell.actionHandler = { [weak self] action in
                guard let self else { return }
                
                switch action {
                case .tapLeft:
                    self.actionHandler(.back)
                case .tapRightTop:
                    self.actionHandler(.settings)
                }
            }
        }
        let firstInformationReg = UICollectionView.CellRegistration<HeaderSectionCell, HeaderModel> { cell, _, model in
            cell.viewModel = model
        }
        
        let healthReg = UICollectionView.CellRegistration<HealthNoteCell, HealthNoteModel> { cell, _, model in
            cell.viewModel = model
        }
        let wateringReg = UICollectionView.CellRegistration<WateringCell, WateringModel> { cell, _, model in
            cell.viewModel = model
            cell.actionHandler = { [weak self] action in
                guard let self else { return }
                
                switch action {
                case .waternigVal(let val):
                    self.actionHandler(.waternigVal(val))
                case .switchIsOn(let val):
                    self.actionHandler(.reminderOn(val))
                case .onShowDropdown:
                    let dropdown = DropdownMenuView()
                      self.addSubview(dropdown)
                      
                      // Привяжем dropdown к тому прямоугольнику:
                    dropdown.translatesAutoresizingMaskIntoConstraints = false
                    dropdown.widthAnchor ~= 191
                    dropdown.heightAnchor ~= 196
                    dropdown.rightAnchor ~= cell.rightAnchor - 2
                    dropdown.bottomAnchor ~= cell.topAnchor + 50
                    
                    dropdown.didSelectOption = { selected in
                        switch selected {
                            
                        case .every3Days:
                            cell.dropdownVal = .every3Days
                            self.actionHandler(.onShowDropdown(.every3Days))
                        case .onceAWeek:
                            cell.dropdownVal = .onceAWeek
                            self.actionHandler(.onShowDropdown(.onceAWeek))
                        case .onceEveryTwoWeeks:
                            cell.dropdownVal = .onceEveryTwoWeeks
                            self.actionHandler(.onShowDropdown(.onceEveryTwoWeeks))
                        case .onceAMonth:
                            cell.dropdownVal = .onceAMonth
                            self.actionHandler(.onShowDropdown(.onceAMonth))
                        }
                    }
                }
            }
        }
        let saveReg = UICollectionView.CellRegistration<PrimaryCTAButtonCell, PrimaryCTAButtonContent.Model> { cell, _, model in
            cell.viewModel = model
            cell.actionHandler = { [weak self] in
                guard let self else { return }
                self.actionHandler(.save)
            }
        }
        let ds = DataSource(collectionView: collectionView) { cv, ip, item in
            switch item {
            case .header(let m):
                return cv.dequeueConfiguredReusableCell(using: headerReg, for: ip, item: m)
            case .firstInformation(let m):
                return cv.dequeueConfiguredReusableCell(using: firstInformationReg, for: ip, item: m)
            case .healthNote(let m):
                return cv.dequeueConfiguredReusableCell(using: healthReg, for: ip, item: m)
            case .watering(let m):
                return cv.dequeueConfiguredReusableCell(using: wateringReg, for: ip, item: m)
            case .saveButton(let m):
                return cv.dequeueConfiguredReusableCell(using: saveReg, for: ip, item: m)
            }
        }
        return ds
    }()

    // MARK: Setup

    override func setupContent() {
        backgroundColor = #colorLiteral(red: 0.9816413522, green: 0.9965692163, blue: 0.9747518897, alpha: 1)
        addSubview(collectionView)
    }

    override func setupLayout() {
        collectionView.pinToSuperview()
    }

    // MARK: Layout Factory

    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .header:
                return defaultSingleItemSection(
                    estimatedHeight: 360,
                    inset: 0,
                    top: 0,
                    bot: 0
                )
            case .firstInformation:
                return defaultSingleItemSection(
                    estimatedHeight: 50,
                    inset: 16,
                    top: 0,
                    bot: 0
                )
            case .healthNote:
                return defaultSingleItemSection(
                    estimatedHeight: 120,
                    inset: 16,
                    top: 0,
                    bot: 0
                )
            case .watering:
                return defaultSingleItemSection(
                    estimatedHeight: 181,
                    inset: 26,
                    top: 0,
                    bot: 0
                )
            case .saveButton:
                return defaultSingleItemSection(
                    estimatedHeight: 60,
                    inset: 0,
                    top: 24,
                    bot: 40
                )
            }
        }
    }

    private static func defaultSingleItemSection(
        estimatedHeight: CGFloat,
        inset: CGFloat = 16,
        top: CGFloat = 20,
        bot: CGFloat = 20,
        betweenCells: CGFloat = 12
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(estimatedHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: top,
            leading: inset,
            bottom: bot,
            trailing: inset
        )
        section.interGroupSpacing = betweenCells
        return section
    }
}

extension CarePlanView: UICollectionViewDelegate {}
