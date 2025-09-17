//
//  HomeView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit

final class HomeView: View {
        
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionItem, CellItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SectionItem, CellItem>
    private typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<CellItem>
    
    // CELLS REGISTRATION
    private typealias SearchCell = UICollectionView.CellRegistration<SearchHomeCell, SearchHomeCellContent.Model>
    private typealias LearnAboutPlants = UICollectionView.CellRegistration<LearnAboutPlantsHomeCell, LearnAboutPlantsHomeCellContent.BigCellModel>
    private typealias MyPlants = UICollectionView.CellRegistration<MyPlantsHomeCell, MyPlantsCellContent.Model>
    private typealias AIAssistant = UICollectionView.CellRegistration<AIAssistantHomeCell, String>
    private typealias History = UICollectionView.CellRegistration<HistoryHomeCell, HistoryCellContent.BigCellModel>
    private typealias Sounds = UICollectionView.CellRegistration<SoundsHomeCell, SoundsHomeContent.Model>
    private typealias Diaries = UICollectionView.CellRegistration<GrowthDiaryCell, GrowthDiaryContent.Model>
    
    // SECTIONS REGISTRATION
    private typealias SectionSnap = NSDiffableDataSourceSectionSnapshot<CellItem>
    
    // MARK: - COLLECTIONVIEW SETTINGS
    
    private enum SectionItem: Hashable, CaseIterable {
        case search
        case learnAboutPlants
        case myPlants
        case aiAssistant
        case history
        case sounds
        case diaries
    }
    
    private enum CellItem: Hashable {
        case search(SearchHomeCellContent.Model)
        case learnAboutPlants(LearnAboutPlantsHomeCellContent.BigCellModel)
        case myPlants(MyPlantsCellContent.Model)
        case aiAssistant
        case history(HistoryCellContent.BigCellModel)
        case sounds(SoundsHomeContent.Model)
        case diaries(GrowthDiaryContent.Model)
    }
    
    enum Action {
        case readMore
        case add(indexPath: Int)
        case viewAllMyPlants
        case viewAllHistory
        case playOrStopMusic(Int)
        case viewAllSounds
        case viewAllDiaries
    }
    var actionHandler: (Action) -> Void = { _ in }

    struct Model {
        let search: SearchHomeCellContent.Model
        let learnAboutPlants: [LearnAboutPlantsHomeCellContent.BigCellModel]
        let myPlants: [MyPlantsCellContent.Model]
        let history: [HistoryCellContent.BigCellModel]
        var sounds: [SoundsHomeContent.Model]
        let diaries: [GrowthDiaryContent.Model]
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            
            var snapshot = Snapshot()
            snapshot.appendSections([
                .search,
                .learnAboutPlants,
                .myPlants,
                .aiAssistant,
                .history,
                .sounds,
                .diaries
            ])
            let search = viewModel.search
            snapshot.appendItems( [.search(search)], toSection: .search)
            
            let myPlants = viewModel.myPlants.map {
                CellItem.myPlants($0)
            }
            snapshot.appendItems(myPlants, toSection: .myPlants)
            
            let historyPrefix = viewModel.history.prefix(2)
            let history = historyPrefix.map {
                CellItem.history($0)
            }
            snapshot.appendItems(history, toSection: .history)
            
            let sounds = viewModel.sounds.map {
                CellItem.sounds($0)
            }
            snapshot.appendItems(sounds, toSection: .sounds)
            
            let diariesPrefix = viewModel.diaries.prefix(2)
            let diaries = diariesPrefix.map {
                CellItem.diaries($0)
            }
            snapshot.appendItems(diaries, toSection: .diaries)
            
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    var updateSoundCellIndex: Int? {
        didSet {
            guard var vm = viewModel, let index = updateSoundCellIndex else { return }
            
            if index == 8 {
                for i in vm.sounds.indices {
                    vm.sounds[i].isPlaying = false
                }
                self.viewModel?.sounds = vm.sounds

                var snapshot = dataSource.snapshot()
                let items = snapshot.itemIdentifiers(inSection: .sounds)
                snapshot.reloadItems(items)
                dataSource.apply(snapshot, animatingDifferences: true)
                return
            }

            // 1) Запоминаем, играла ли выбранная до нажатия
            let wasPlaying = vm.sounds[index].isPlaying

            // 2) Вырубаем у всех
            for i in vm.sounds.indices {
                vm.sounds[i].isPlaying = false
            }

            // 3) У выбранной ставим инверсию прошлого состояния
            vm.sounds[index].isPlaying = !wasPlaying

            // 4) Обновляем модель
            self.viewModel?.sounds = vm.sounds

            // 5) Обновляем UI (перезагрузим всю секцию sounds)
            var snapshot = dataSource.snapshot()
            let items = snapshot.itemIdentifiers(inSection: .sounds)
            snapshot.reloadItems(items)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: HomeView.layout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.contentInset = .init(top: 0, left: 0, bottom: 120, right: 0)
        view.contentInsetAdjustmentBehavior = .never
        view.bounces = false
        return view
    }()
    
    private lazy var dataSource: DataSource = {
        
        let searchCellRegistration = SearchCell { cell, indexPath, itemIdentifier in
            cell.viewModel = itemIdentifier
            cell.onQueryChange = { [weak self] query in
                guard let self else { return }
                self.applyFilter(query: query)
            }
        }
        
        let learnAboutPlantsCellRegistration = LearnAboutPlants { cell, indexPath, itemIdentifier in
            cell.viewModel = itemIdentifier
            cell.actionHandler = { [weak self] action in
                guard let self else { return }
                switch action {
                case .readMore:
                    self.actionHandler(.readMore)
                }
            }
        }
        
        let myPlantsCellRegistration = MyPlants { cell, indexPath, itemIdentifier in
            cell.viewModel = itemIdentifier
        }
        
        let aiAssistantCellRegistration = AIAssistant { _, _, _ in
            
        }
        
        let historyCellRegistration = History {cell, indexPath, itemIdentifier in
            cell.viewModel = itemIdentifier
            cell.actionHandler = { [weak self] action in
                guard let self else { return }
                switch action {
                case .add:
                    self.actionHandler(.add(indexPath: indexPath.row))
                }
            }
        }
        
        let soundsRegistration = Sounds { cell, indexPath, itemIdentifier in
            cell.viewModel = itemIdentifier
            cell.actionHandler = { [weak self] action in
                guard let self else { return }
                switch action {
                case .playOrStop:
                    self.actionHandler(.playOrStopMusic(indexPath.item))
                }
            }
        }
        
        let diariesRegistration = Diaries { cell, indexPath, itemIdentifier in
            cell.viewModel = itemIdentifier
            cell.hideEditButton = false
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>(
            elementKind: "Header"
        ) { [weak self] view, kind, indexPath in
//            guard let section = self?.dataSource.snapshot().sectionIdentifiers[indexPath.section] else { return }
            
            guard let section = self?.dataSource.sectionIdentifier(for: indexPath.section) else { return }
            
            view.textForSection = nil
            view.needToShowButton = false
            view.actionHandler = { _ in }
            
//            if section == .learnAboutPlants {
//                view.textForSection = TextForHomeScene.learnAboutPlants
//            }
            if section == .myPlants {
                view.textForSection = TextForHomeScene.myPlants
                view.needToShowButton = true
                view.actionHandler = { [weak self] action in
                    guard let self else { return }
                    switch action {
                    case .viewAll:
                        self.actionHandler(.viewAllMyPlants)
                    }
                }
            }
            if section == .history {
                view.textForSection = TextForHomeScene.history
                view.needToShowButton = true
                view.actionHandler = { [weak self] action in
                    guard let self else { return }
                    switch action {
                    case .viewAll:
                        self.actionHandler(.viewAllHistory)
                    }
                }
            }
            
            if section == .sounds {
                view.textForSection = TextForSounds.title
                view.needToShowButton = true
                view.actionHandler = { [weak self] action in
                    guard let self else { return }
                    switch action {
                    case .viewAll:
                        self.actionHandler(.viewAllSounds)
                    }
                }
            }
            if section == .diaries {
                view.textForSection = TextForStartGrowthDiary.title
                view.needToShowButton = true
                view.actionHandler = { [weak self] action in
                    guard let self else { return }
                    switch action {
                    case .viewAll:
                        self.actionHandler(.viewAllDiaries)
                    }
                }
            }
        }
        
        let dataSource = DataSource (
            collectionView: collectionView
        ) { collectionView, indexPath, item -> UICollectionViewCell in
            
            switch item {
                
            case .search(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: searchCellRegistration,
                    for: indexPath,
                    item: viewModel
                )
            case .learnAboutPlants(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: learnAboutPlantsCellRegistration,
                    for: indexPath,
                    item: viewModel
                )
            case .myPlants(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: myPlantsCellRegistration,
                    for: indexPath,
                    item: viewModel
                )
            case .aiAssistant:
                return collectionView.dequeueConfiguredReusableCell(
                    using: aiAssistantCellRegistration,
                    for: indexPath,
                    item: ""
                )
            case .history(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: historyCellRegistration,
                    for: indexPath,
                    item: viewModel
                )
            case .sounds(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: soundsRegistration,
                    for: indexPath,
                    item: viewModel
                )
            case .diaries(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: diariesRegistration,
                    for: indexPath,
                    item: viewModel
                )
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == "Header" else { return nil }
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: indexPath
            )
        }
        return dataSource
    }()
    
    override func setupContent() {
        backgroundColor = .white
        addSubview(collectionView)
    }
    
    override func setupLayout() {
        collectionView.pinToSuperview()
        
        collectionView.topAnchor ~= topAnchor
        collectionView.leftAnchor ~= leftAnchor
        collectionView.rightAnchor ~= rightAnchor
        collectionView.bottomAnchor ~= bottomAnchor
    }
    
    private func applyFilter(query: String) {
        guard let vm = viewModel else { return }

        var snapshot = Snapshot()
        snapshot.appendSections([
             .search,
             .learnAboutPlants,
             .myPlants,
             .aiAssistant,
             .history,
             .sounds,
             .diaries
         ])
        
        snapshot.appendItems([.search(vm.search)], toSection: .search)
        
        var myPlants: [CellItem] = []
        myPlants = vm.myPlants.map { CellItem.myPlants($0) }
        
        let filteredMyPlants = myPlants.filter { item in
            let name = itemModelName(item).lowercased()
            return query.isEmpty || name.contains(query.lowercased())
        }
        snapshot.appendItems(filteredMyPlants, toSection: .myPlants)
        
        var history: [CellItem] = []
        history = vm.history.map { CellItem.history($0) }
        
        let filteredHistory = history.filter { item in
            let name = itemModelName(item).lowercased()
            return query.isEmpty || name.contains(query.lowercased())
        }
        snapshot.appendItems(filteredHistory, toSection: .history)
        
        var diaries: [CellItem] = []
        diaries = vm.diaries.map { CellItem.diaries($0) }
        
        let filteredDiaries = diaries.filter { item in
            let name = itemModelName(item).lowercased()
            return query.isEmpty || name.contains(query.lowercased())
        }
        snapshot.appendItems(filteredDiaries, toSection: .diaries)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func itemModelName(_ item: CellItem) -> String {
        
        switch item {

        case .search(_):
            break
        case .learnAboutPlants(_):
            break
        case .myPlants(let viewModel):
            guard viewModel.name != "" else { break }
            return viewModel.name
        case .aiAssistant:
            break
        case .history(let viewModel):
            guard viewModel.firstText != "" else { break }
            return viewModel.firstText
        case .sounds(_):
            break
        case .diaries(let viewModel):
            guard viewModel.name != "" else { break }
            return viewModel.name
        }
        return ""
    }
}

private extension HomeView {
    static func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in

            let section = SectionItem.allCases[sectionIndex]

            switch section {
            case .search:
                return defaultSingleItemSection(
                    estimatedHeight: 210,
                    inset: 0,
                    top: 0,
                    bot: 40
                )
            case .learnAboutPlants:
                return learnAboutPlantsSection(
                       estimatedHeight: 0
                   )
            case .myPlants:
                return myPlantsSection(
                    estimatedHeight: 124
                )
            case .aiAssistant:
                return defaultSingleItemSection(
                    estimatedHeight: 130
                )
            case .history:
                return historySection(
                    estimatedHeight: 112
                )
            case .sounds:
                return soundsSection(
                    estimatedHeight: 90
                )
            case .diaries:
                return diariesSection(
                    estimatedHeight: 130
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
    )
    -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(estimatedHeight)
        )
        let item  = NSCollectionLayoutItem(layoutSize: itemSize)
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
    
    private static func learnAboutPlantsSection(
        estimatedHeight: CGFloat,
        widthFraction: CGFloat = 0.88
    ) -> NSCollectionLayoutSection {
        // item заполняет группу
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        // «страница»-карточка ~88% ширины
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(widthFraction),
                heightDimension: .estimated(estimatedHeight)
            ),
            subitems: [item]
        )
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(10)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: "Header",
            alignment: .top
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets =
            .init(
                top: 0,
                leading: 0,
                bottom: 0,
                trailing: 0
            )
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }

    static func myPlantsSection(
        estimatedHeight: CGFloat,
        top: CGFloat = 10,
        bottom: CGFloat = 35
        
    ) -> NSCollectionLayoutSection {
        
        // Каждая карточка занимает половину ширины группы и всю её высоту
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        // Группа-«страница» с двумя карточками
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.92),
                heightDimension: .estimated(estimatedHeight)
            ),
            repeatingSubitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(16) // расстояние между карточками в группе
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(10)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: "Header",
            alignment: .top
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = .init(
            top: top,
            leading: 16,
            bottom: bottom,
            trailing: 16
        )
        section.interGroupSpacing = 16 // расстояние между карточками (ячейками)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private static func historySection( estimatedHeight: CGFloat ) -> NSCollectionLayoutSection {
        
        let item  = NSCollectionLayoutItem(
            layoutSize:
                .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(estimatedHeight)
                )
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize:
                    .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(estimatedHeight)
                    ),
            subitems: [item]
        )
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(10)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: "Header",
            alignment: .top
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 16,
            bottom: 40,
            trailing: 16
        )
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    static func soundsSection( estimatedHeight: CGFloat ) -> NSCollectionLayoutSection {
        
        // Каждая карточка занимает половину ширины группы и всю её высоту
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .estimated(88),
                heightDimension: .estimated(88)
            )
        )
        // Группа-«страница» с двумя карточками
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize:
                    .init(
                        widthDimension: .fractionalWidth(0.92),
                        heightDimension: .estimated(estimatedHeight)
                    ),
            subitems: [item]
        )
        
        group.interItemSpacing = .fixed(10) // расстояние между карточками в группе
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(10)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: "Header",
            alignment: .top
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.contentInsets = .init(
            top: 10,
            leading: 16,
            bottom: 40,
            trailing: 16
        )
        section.interGroupSpacing = 16 // расстояние между карточками (ячейками)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private static func diariesSection( estimatedHeight: CGFloat ) -> NSCollectionLayoutSection {
        
        let item  = NSCollectionLayoutItem(
            layoutSize:
                .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(estimatedHeight)
                )
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize:
                    .init(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .estimated(estimatedHeight)
                    ),
            subitems: [item]
        )
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(10)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: "Header",
            alignment: .top
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 16,
            bottom: 40,
            trailing: 16
        )
        section.interGroupSpacing = 16
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}

extension HomeView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout { }

// ----------------------------------------------------
// MARK: - SectionHeaderView
// ----------------------------------------------------

final class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"
    
    enum Action {
        case viewAll
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    var textForSection: String? {
        didSet {
            if let textForSection {
                titleLabel.text = textForSection
            }
        }
    }
    
    var needToShowButton: Bool = false {
        didSet {
            btn.isHidden = !needToShowButton
        }
    }

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Medium", size: 18)
        view.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 1)
        view.numberOfLines = 1
        view.textAlignment = .left
        return view
    }()
    
    private lazy var btn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let title = TextForHomeScene.viewAll
        let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 0.8),
                .font: UIFont(name: "Poppins-Medium", size: 14)!,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        let attributed = NSAttributedString(string: title, attributes: attributes)
        view.setAttributedTitle(attributed, for: .normal)
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.viewAll)
                }
            )
            , for: .touchUpInside
        )
        view.widthAnchor ~= 60
        view.heightAnchor ~= 30
        view.isHidden = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(btn)
        
        titleLabel.leftAnchor ~= leftAnchor + 16
        titleLabel.bottomAnchor ~= bottomAnchor
        
        btn.centerYAnchor ~= titleLabel.centerYAnchor
        btn.rightAnchor ~= rightAnchor - 16
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


