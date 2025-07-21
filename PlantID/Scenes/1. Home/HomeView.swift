//
//  HomeView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit
import Combine

final class HomeView: View {
    
    private var subscriptions = Set<AnyCancellable>()
    
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionItem, CellItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SectionItem, CellItem>
    
//    private typealias MyPlants = UICollectionView.CellRegistration<MyPlantsViewCell, MyPlantsCellContentView.Model>
    private typealias MyPlantsWithPhoto = UICollectionView.CellRegistration<MyPlantsWithPhotoCell, MyPlantsWithPhotoContent.Model>
//    private typealias History = UICollectionView.CellRegistration<HistoryViewCell, HistoryCellContentView.Model>
    private typealias HistoryWithPhoto = UICollectionView.CellRegistration<HistoryWhenHavePlantsCell, HistoryWhenHavePlantsContent.Model>
    
    private typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<CellItem>
    
    private enum SectionItem: Hashable, CaseIterable {
        case myPlants
        case history
    }
    
    private enum CellItem: Hashable {
//        case myPlants(MyPlantsCellContentView.Model)
        case myPlantsWithPhoto(MyPlantsWithPhotoContent.Model)
//        case history(HistoryCellContentView.Model)
        case historyWithPhoto(HistoryWhenHavePlantsContent.Model)
    }
    
    enum Action {
        case addMyPlants(indexPath: Int)
    }
    var actionHandler: (Action) -> Void = { _ in }

    
    struct Model {
//        let myPlants: [MyPlantsCellContentView.Model]
        let myPlantsWithPhoto: [MyPlantsWithPhotoContent.Model]
//        let history: [HistoryCellContentView.Model]
        let historyWithPhoto: [HistoryWhenHavePlantsContent.Model]
        let haveOnCoreDataPlant: Bool
        let haveOnCoreDataHistory: Bool
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            
            var snapshot = Snapshot()
            snapshot.appendSections([.myPlants, .history])
            
            let myPlantsItems = viewModel.myPlantsWithPhoto.map { CellItem.myPlantsWithPhoto($0) }
            snapshot.appendItems(myPlantsItems, toSection: .myPlants)
            let historyItems = viewModel.historyWithPhoto.map { CellItem.historyWithPhoto($0) }
            snapshot.appendItems(historyItems, toSection: .history)
     
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "plants_app".localized
        view.font = UIFont(name: "Onest-SemiBold", size: 20)
        view.textColor = UIColor(red: 0.063, green: 0.082, blue: 0.067, alpha: 1)
        view.textAlignment = .center
        return view
    }()

    private lazy var searchTextField: SearchTextField = {
        let view = SearchTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: HomeView.layout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.contentInset = .init(top: 50, left: 0, bottom: 40, right: 0)
        return view
    }()
    
    private lazy var dataSource: DataSource = {
        
        let myWithPhoto = MyPlantsWithPhoto { cell, indexPath, item in
            cell.viewModel = item
        }
        
        let hisWithPhoto = HistoryWithPhoto { cell, indexPath, item in
            cell.viewModel = item
            cell.actionHandler = { [weak self] action in
                guard let self else { return }
                self.actionHandler(.addMyPlants(indexPath: indexPath.row))
            }
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>(
            elementKind: "Header"
        ) { [weak self] view, kind, indexPath in
            guard let section = self?.dataSource.snapshot().sectionIdentifiers[indexPath.section] else { return }
            switch section {
            case .myPlants:
                view.isMyPlant = true
                view.setTitle("my_plants_little".localized)
            case .history:
                view.isMyPlant = false
                view.setTitle("history_ little".localized)
            }
        }
        
        let dataSource = DataSource (
            collectionView: collectionView
        ) { collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .myPlantsWithPhoto(let v):
                return collectionView.dequeueConfiguredReusableCell(using: myWithPhoto, for: indexPath, item: v)
            case .historyWithPhoto(let v):
                return collectionView.dequeueConfiguredReusableCell(using: hisWithPhoto, for: indexPath, item: v)
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
        setMainBgGradient()
        addSubview(titleLabel)
        addSubview(searchTextField)
        addSubview(collectionView)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: searchTextField.textField)
            .map { notification in
                (notification.object as? UITextField)?.text ?? ""
            }
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.applyFilter(query: query)
            }
            .store(in: &subscriptions)
    }
    
    override func setupLayout() {
        titleLabel.topAnchor ~= topAnchor + 60
        titleLabel.centerXAnchor ~= centerXAnchor
            
        searchTextField.topAnchor ~= titleLabel.bottomAnchor + 16
        searchTextField.heightAnchor ~= 48
        searchTextField.leftAnchor ~= leftAnchor + 16
        searchTextField.rightAnchor ~= rightAnchor - 16
            
        collectionView.topAnchor ~= searchTextField.bottomAnchor
        collectionView.leftAnchor ~= leftAnchor
        collectionView.rightAnchor ~= rightAnchor
        collectionView.bottomAnchor ~= bottomAnchor
    }
    
    private func applyFilter(query: String) {
        guard let vm = viewModel else { return }

        var snapshot = Snapshot()
        snapshot.appendSections([.myPlants, .history])
        
        var allMyPlants: [CellItem] = []
        if vm.haveOnCoreDataPlant == true {
            allMyPlants = vm.myPlantsWithPhoto.map(CellItem.myPlantsWithPhoto)
        }
        let filteredMyPlants = allMyPlants.filter { item in
            let name = itemModelName(item).lowercased()
            return query.isEmpty || name.contains(query.lowercased())
        }
        snapshot.appendItems(filteredMyPlants, toSection: .myPlants)
        
        var allHistory: [CellItem] = []
        if vm.haveOnCoreDataHistory == true {
            allHistory = vm.historyWithPhoto.map(CellItem.historyWithPhoto)
        }
        let filteredHistory = allHistory.filter { item in
            let name = itemModelName(item).lowercased()
            return query.isEmpty || name.contains(query.lowercased())
        }
        snapshot.appendItems(filteredHistory, toSection: .history)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func itemModelName(_ item: CellItem) -> String {
        switch item {
        case .myPlantsWithPhoto(let m):
            guard let name = m.plantName else { break }
            return name
        case .historyWithPhoto(let m):
            guard let name = m.name else { break }
            return name
        }
        return ""
    }
}

private extension HomeView {
    static func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in

            let section = SectionItem.allCases[sectionIndex]

            switch section {
            case .myPlants:
                return myPlantsSection()
            case .history:
                return historySection()
            }
        }
    }

    static func myPlantsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .absolute(220)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(16) // расстояние между ячейками
        
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
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }

    static func historySection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(140)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(140)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: "Header",
            alignment: .top
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 22 // расстояние между ячейками
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }
}

extension HomeView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


// SectionHeaderView
final class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Onest-SemiBold", size: 20)
        label.textColor = UIColor(red: 0.063, green: 0.082, blue: 0.067, alpha: 1)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isMyPlant: Bool = false {
        didSet {
            if isMyPlant == true {
                titleLabel.centerXAnchor ~= centerXAnchor
                titleLabel.bottomAnchor ~= bottomAnchor
            }
            else {
                titleLabel.leftAnchor ~= leftAnchor + 16
                titleLabel.bottomAnchor ~= bottomAnchor
            }
        }
    }

    func setTitle(_ text: String) {
        titleLabel.text = text
    }
}


// ----------------------------------
//
// MARK: - MY Plant CELL
// ----------------------------------


final class MyPlantsWithPhotoCell: UICollectionViewCell {
    
    var viewModel: MyPlantsWithPhotoContent.Model {
        get {
            cellContentView.viewModel ?? .init()
        }
        set {
            cellContentView.viewModel = newValue
        }
    }
    
    private lazy var cellContentView: MyPlantsWithPhotoContent = {
        let view = MyPlantsWithPhotoContent()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

    // MARK: ContentView

final class MyPlantsWithPhotoContent: View {
    
    struct Model: Hashable {
        var photo: UIImage?
        var plantName: String?
        var plantDescription: String?
        var rateWatering: Int?
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            photo.image = viewModel.photo
            plantNameLabel.text = viewModel.plantName
            plantDescriptionLabel.text = viewModel.plantDescription
            setupStackWithRateWatering(viewModel.rateWatering ?? 2)
        }
    }
    
    private lazy var photo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.heightAnchor ~= 86
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var plantNameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 12)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.contentMode = .right
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var plantDescriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Regular", size: 10)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.numberOfLines = 4
        return view
    }()
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 8
        view.distribution = .equalSpacing
        return view
    }()
    
    private lazy var rateWateringImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "copcop")
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 32
        view.heightAnchor ~= 32
        return view
    }()
    
    override func setupContent() {
        let col1: UIColor = #colorLiteral(red: 0.8565542102, green: 0.9519869685, blue: 0.8682914376, alpha: 1)
        let col2: UIColor = #colorLiteral(red: 0.8092304468, green: 0.9251116514, blue: 0.8062599301, alpha: 1)
        backgroundGradient = .init(colors: [ col1, col2])
        layer.cornerRadius = 16
        clipsToBounds = true
        
        addSubview(photo)
        addSubview(plantNameLabel)
        addSubview(plantDescriptionLabel)
        addSubview(stack)
    }
    
    override func setupLayout() {
        photo.topAnchor ~= topAnchor
        photo.leftAnchor ~= leftAnchor
        photo.rightAnchor ~= rightAnchor
                
        plantNameLabel.leftAnchor ~= leftAnchor + 10
        plantNameLabel.topAnchor ~= photo.bottomAnchor + 10
        
        plantDescriptionLabel.topAnchor ~= plantNameLabel.bottomAnchor + 10
        plantDescriptionLabel.rightAnchor ~= rightAnchor - 10
        plantDescriptionLabel.leftAnchor ~= leftAnchor + 10
        
        stack.topAnchor ~= plantDescriptionLabel.bottomAnchor + 10
        stack.leftAnchor ~= leftAnchor + 10
    }
    
    private func setupStackWithRateWatering(_ amountVal: Int) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for _ in 0..<amountVal {
            let iv = UIImageView()
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.image = UIImage(named: "copcop")
            iv.contentMode = .scaleAspectFit
            iv.widthAnchor ~= 32
            iv.heightAnchor ~= 32
            stack.addArrangedSubview(iv)
        }
    }
}


