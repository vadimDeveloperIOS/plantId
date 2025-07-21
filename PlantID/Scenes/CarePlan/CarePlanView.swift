//
//  CarePlanView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 27.06.25.
//

import UIKit

// MARK: – Root View
final class CarePlanView: View {
    
    enum Action {
        case back
        case help
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
            bgImage.image = viewModel.image
            // это когда растение уже было сохранено в "мои планы"
            if viewModel.didAddToMyPlans == true {
                infoView.viewModel =
                    .init(
                        header:
                                .init(title: viewModel.name),
                        healthNote:
                                .init(text: viewModel.healthNote),
                        watering:
                                .init(
                                    frequency: viewModel.frequencyVal ?? OptionsForFrequency.every3Days.rawValue.localized,
                                    reminderOn: viewModel.reminderVal ?? false,
                                    amount: viewModel.amountVal ?? 1
                                ),
                        saveButton:
                                .init(title: "save.care.plan"))
            }
            // это когда растение не было сохранено в "мои планы" но хранится в базе как история
            // либо растение не хранилось в базе
            else {
                infoView.viewModel =
                    .init(
                        header:
                                .init(title: viewModel.name),
                        healthNote:
                                .init(text: viewModel.healthNote),
                        watering:
                                .init(
                                    frequency: OptionsForFrequency.every3Days.rawValue.localized,
                                    reminderOn: false,
                                    amount: 1
                                ),
                        saveButton:
                                .init(title: "save.care.plan"))
            }
        }
    }
    
    private lazy var header: HeaderViewWithCustomBack = {
        let view = HeaderViewWithCustomBack()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleForButton = "CREATE \nA CARE PLAN"
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .back:
                self.actionHandler(.back)
            case .help:
                self.actionHandler(.help)
            }
        }
        return view
    }()
    
    private lazy var bgImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "fake123")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var infoView: SecondCarePlanInformationView = {
        let v = SecondCarePlanInformationView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .save:
                self.actionHandler(.save)
            case .waternigVal(let val):
                self.actionHandler(.waternigVal(val))
            case .switchIsOn(let val):
                self.actionHandler(.reminderOn(val))
            case .onShowDropdown(let val):
                self.actionHandler(.onShowDropdown(val))
            }
        }
        return v
    }()
    
    override func setupContent() {
        addSubview(bgImage)
        addSubview(header)
        addSubview(infoView)
        
        infoView.layer.cornerRadius = 32
        infoView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        infoView.layer.masksToBounds = true
    }
    
    override func setupLayout() {
        bgImage.pinToSuperview()
        
        header.topAnchor     ~= topAnchor + 80
        header.leftAnchor    ~= leftAnchor
        header.rightAnchor   ~= rightAnchor
        header.heightAnchor  ~= 100
        
        infoView.bottomAnchor  ~= bottomAnchor
        infoView.leftAnchor    ~= leftAnchor
        infoView.rightAnchor   ~= rightAnchor
        infoView.heightAnchor ~= 550
    }
}


// MARK: - CarePlanInformationView

// __________________________________________
// CarePlanInformationView - не используется
// ------------------------------------------

final class CarePlanInformationView: View {
    
    enum Action {
        case add
    }
    var actionHandler: (Action) -> Void = { _ in }

    // MARK: Section & Item

    private enum Section: Hashable, CaseIterable {
        case header, healthNote,
             watering, light, temperature,
             fertilizing, pruning, notifications,
             saveButton
    }

    private enum Item: Hashable {
        case header(HeaderModel)
        case healthNote(HealthNoteModel)
        case watering(WateringModel)
        case light(LightModel)
        case temperature(TemperatureModel)
        case fertilizing(FertilizingModel)
        case pruning(PruningModel)
        case notifications(NotificationModel)
        case saveButton(SaveButtonModel)
    }

    // MARK: ViewModel

    struct Model {
        let header: HeaderModel
        let healthNote: HealthNoteModel
        let watering: WateringModel
        let light: LightModel
        let temperature: TemperatureModel
        let fertilizing: FertilizingModel
        let pruning: PruningModel
        let notifications: NotificationModel
        let saveButton: SaveButtonModel
    }

    var viewModel: Model? {
        didSet {
            guard let m = viewModel else { return }
            var snapshot = Snapshot()
            snapshot.appendSections(Section.allCases)

            snapshot.appendItems([.header(m.header)], toSection: .header)
            snapshot.appendItems([.healthNote(m.healthNote)], toSection: .healthNote)
            snapshot.appendItems([.watering(m.watering)], toSection: .watering)
            snapshot.appendItems([.light(m.light)], toSection: .light)
            snapshot.appendItems([.temperature(m.temperature)], toSection: .temperature)
            snapshot.appendItems([.fertilizing(m.fertilizing)], toSection: .fertilizing)
            snapshot.appendItems([.pruning(m.pruning)], toSection: .pruning)
            snapshot.appendItems([.notifications(m.notifications)], toSection: .notifications)
            snapshot.appendItems([.saveButton(m.saveButton)], toSection: .saveButton)

            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    // MARK: CollectionView + DataSource

    private typealias Snapshot   = NSDiffableDataSourceSnapshot<Section, Item>
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

    private lazy var collectionView: UICollectionView = {
        let layout = CarePlanInformationView.makeLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        return cv
    }()

    private lazy var dataSource: DataSource = {
        // Регистрация каждой ячейки
        let headerReg = UICollectionView.CellRegistration<HeaderSectionCell, HeaderModel> { cell, _, model in
            cell.viewModel = model
        }
        let healthReg = UICollectionView.CellRegistration<HealthNoteCell, HealthNoteModel> { cell, _, model in
            cell.viewModel = model
        }
        let wateringReg = UICollectionView.CellRegistration<WateringCell, WateringModel> { cell, _, model in
            cell.viewModel = model
        }
        let lightReg = UICollectionView.CellRegistration<LightCell, LightModel> { cell, _, model in
            cell.viewModel = model
        }
        let tempReg = UICollectionView.CellRegistration<TemperatureCell, TemperatureModel> { cell, _, model in
            cell.viewModel = model
        }
        let fertReg = UICollectionView.CellRegistration<FertilizingCell, FertilizingModel> { cell, _, model in
            cell.viewModel = model
        }
        let pruneReg = UICollectionView.CellRegistration<PruningCell, PruningModel> { cell, _, model in
            cell.viewModel = model
        }
        let notifReg = UICollectionView.CellRegistration<NotificationsCell, NotificationModel> { cell, _, model in
            cell.viewModel = model
        }
        let saveReg = UICollectionView.CellRegistration<SaveButtonCell, SaveButtonModel> { cell, _, model in
            cell.viewModel = model
        }

        let ds = DataSource(collectionView: collectionView) { cv, ip, item in
            switch item {
            case .header(let m):
                return cv.dequeueConfiguredReusableCell(using: headerReg,    for: ip, item: m)
            case .healthNote(let m):
                return cv.dequeueConfiguredReusableCell(using: healthReg,    for: ip, item: m)
            case .watering(let m):
                return cv.dequeueConfiguredReusableCell(using: wateringReg,  for: ip, item: m)
            case .light(let m):
                return cv.dequeueConfiguredReusableCell(using: lightReg,     for: ip, item: m)
            case .temperature(let m):
                return cv.dequeueConfiguredReusableCell(using: tempReg,      for: ip, item: m)
            case .fertilizing(let m):
                return cv.dequeueConfiguredReusableCell(using: fertReg,      for: ip, item: m)
            case .pruning(let m):
                return cv.dequeueConfiguredReusableCell(using: pruneReg,     for: ip, item: m)
            case .notifications(let m):
                return cv.dequeueConfiguredReusableCell(using: notifReg,     for: ip, item: m)
            case .saveButton(let m):
                return cv.dequeueConfiguredReusableCell(using: saveReg,      for: ip, item: m)
            }
        }
        return ds
    }()

    // MARK: Setup

    override func setupContent() {
        let color2: UIColor = .white
        let color1 = #colorLiteral(red: 0.8757615685, green: 0.9425374866, blue: 0.8915592432, alpha: 1)
        
        backgroundGradient = .init(
            colors: [color1, color2, color2, color2, color2]
        )
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
                return headerSection()
            case .healthNote:
                return singleItemSection(estimatedHeight: 180, inset: 16, topPlusBottom: 2)
            case .watering:
                return singleItemSection(estimatedHeight: 120, inset: 16)
            case .light:
                return singleItemSection(estimatedHeight: 100, inset: 16)
            case .temperature:
                return singleItemSection(estimatedHeight: 100, inset: 16)
            case .fertilizing:
                return singleItemSection(estimatedHeight: 140, inset: 16)
            case .pruning:
                return singleItemSection(estimatedHeight: 160, inset: 16)
            case .notifications:
                return singleItemSection(estimatedHeight: 100, inset: 16)
            case .saveButton:
                return singleItemSection(estimatedHeight: 60,  inset: 16)
            }
        }
    }

    private static func headerSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(70)
        )
        let item  = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }

    private static func singleItemSection(estimatedHeight: CGFloat, inset: CGFloat, topPlusBottom: CGFloat = 10) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(estimatedHeight)
        )
        let item  = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: topPlusBottom,
            leading: inset,
            bottom: topPlusBottom,
            trailing: inset
        )
        return section
    }
}

extension CarePlanInformationView: UICollectionViewDelegate {}



// ---------------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------------
// MARK: - Second Care Plan Information View  (укороченнная версия экрана)
// ---------------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------------

final class SecondCarePlanInformationView: View {
    
    enum Action {
        case save
        case waternigVal(Int)
        case switchIsOn(Bool)
        case onShowDropdown(OptionsForFrequency)
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    // MARK: Section & Item

    private enum Section: Hashable, CaseIterable {
        case header, healthNote, watering, saveButton
    }

    private enum Item: Hashable {
        case header(HeaderModel)
        case healthNote(HealthNoteModel)
        case watering(WateringModel)
        case saveButton(SaveButtonModel)
    }

    // MARK: ViewModel

    struct Model {
        let header: HeaderModel
        let healthNote: HealthNoteModel
        let watering: WateringModel
        let saveButton: SaveButtonModel
    }

    var viewModel: Model? {
        didSet {
            guard let m = viewModel else { return }
            var snapshot = Snapshot()
            snapshot.appendSections(Section.allCases)

            snapshot.appendItems([.header(m.header)], toSection: .header)
            snapshot.appendItems([.healthNote(m.healthNote)], toSection: .healthNote)
            snapshot.appendItems([.watering(m.watering)], toSection: .watering)
            snapshot.appendItems([.saveButton(m.saveButton)], toSection: .saveButton)

            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    // MARK: CollectionView + DataSource

    private typealias Snapshot   = NSDiffableDataSourceSnapshot<Section, Item>
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

    private lazy var collectionView: UICollectionView = {
        let layout = SecondCarePlanInformationView.makeLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        return cv
    }()

    private lazy var dataSource: DataSource = {
        // Регистрация каждой ячейки
        let headerReg = UICollectionView.CellRegistration<HeaderSectionCell, HeaderModel> { cell, _, model in
            cell.viewModel = model
        }
        let healthReg = UICollectionView.CellRegistration<HealthNoteCell, HealthNoteModel> { cell, _, model in
            cell.viewModel = model
        }
        let wateringReg = UICollectionView.CellRegistration<WateringCell, WateringModel> { cell, _, model in
            cell.viewModel = model
            cell.actionHandler = { [weak self] action in
                switch action {
                case .waternigVal(let val):
                    self?.actionHandler(.waternigVal(val))
                case .switchIsOn(let val):
                    self?.actionHandler(.switchIsOn(val))
                case .onShowDropdown:
                    let dropdown = DropdownMenuView()
                      self?.addSubview(dropdown)
                      
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
                            self?.actionHandler(.onShowDropdown(.every3Days))
                        case .onceAWeek:
                            cell.dropdownVal = .onceAWeek
                            self?.actionHandler(.onShowDropdown(.onceAWeek))
                        case .onceEveryTwoWeeks:
                            cell.dropdownVal = .onceEveryTwoWeeks
                            self?.actionHandler(.onShowDropdown(.onceEveryTwoWeeks))
                        case .onceAMonth:
                            cell.dropdownVal = .onceAMonth
                            self?.actionHandler(.onShowDropdown(.onceAMonth))

                        }
                    }
                }
            }
        }
        let saveReg = UICollectionView.CellRegistration<SaveButtonCell, SaveButtonModel> { cell, _, model in
            cell.viewModel = model
            cell.actionHandler = { [weak self] action in
                guard let self else { return }
                switch action {
                case .save:
                    self.actionHandler(.save)
                }
            }
        }
        let ds = DataSource(collectionView: collectionView) { cv, ip, item in
            switch item {
            case .header(let m):
                return cv.dequeueConfiguredReusableCell(using: headerReg,    for: ip, item: m)
            case .healthNote(let m):
                return cv.dequeueConfiguredReusableCell(using: healthReg,    for: ip, item: m)
            case .watering(let m):
                return cv.dequeueConfiguredReusableCell(using: wateringReg,  for: ip, item: m)
            case .saveButton(let m):
                return cv.dequeueConfiguredReusableCell(using: saveReg,      for: ip, item: m)
            }
        }
        return ds
    }()

    // MARK: Setup

    override func setupContent() {
        let color2 = UIColor(hex: "#F8F8F8")
        let color1 = #colorLiteral(red: 0.8757615685, green: 0.9425374866, blue: 0.8915592432, alpha: 1)
        
        if let color2 {
            backgroundGradient = .init(
                colors: [color1, color2, color2, color2, color2]
            )
        }
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
                return headerSection()
            case .healthNote:
                return singleItemSection(estimatedHeight: 100, inset: 16, topPlusBottom: 2)
            case .watering:
                return singleItemSection(estimatedHeight: 120, inset: 16)
            case .saveButton:
                return singleItemSection(estimatedHeight: 200,  inset: 16)
            }
        }
    }

    private static func headerSection() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(70)
        )
        let item  = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }

    private static func singleItemSection(estimatedHeight: CGFloat, inset: CGFloat, topPlusBottom: CGFloat = 10) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(estimatedHeight)
        )
        let item  = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: topPlusBottom,
            leading: inset,
            bottom: topPlusBottom,
            trailing: inset
        )
        return section
    }
}

extension SecondCarePlanInformationView: UICollectionViewDelegate {}
