//
//  AboutPlantsView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 25.06.25.
//

import UIKit

final class AboutPlantsView: View {
    
    enum Action {
        case back
        case help
        case add
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    struct Model: Hashable {
        let name: String
        let description: String?
        let photos: [UIImage]
        let size: String?
        let humidity: String?
        let spraying: String?
        let fertilize: String?
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel, !viewModel.photos.isEmpty else { return }
            bgImage.image = viewModel.photos[0]
            
            var phts: [PhotosContentView.Model] = []
            for p in viewModel.photos {
                phts.append(.init(photo: p))
            }
            infornationView.viewModel = .init(
                name: viewModel.name,
                haracteristics: .init(
                    size: viewModel.size,
                    humidity: viewModel.humidity,
                    spraying: viewModel.spraying,
                    fertilize: viewModel.fertilize
                ),
                decision: .init(description: viewModel.description),
                photos: phts,
                button: .init()
            )
        }
    }
    
    private lazy var header: HeaderViewWithCustomBack = {
        let view = HeaderViewWithCustomBack()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleForButton = "about_plant_big".localized
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .back:
                print("🟪 КНОПКА БАК 🟪")
                self.actionHandler(.back)
            case .help:
                self.actionHandler(.help)
            }
        }
        return view
    }()
    
    private lazy var bgImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "fake123")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var infornationView: InfornationView = {
        let view = InfornationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .add:
                self.actionHandler(.add)
            }
        }
        return view
    }()
    
    override func setupContent() {
        addSubview(bgImage)
        addSubview(header)
        addSubview(infornationView)
        
        infornationView.layer.cornerRadius = 32
        infornationView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        infornationView.layer.masksToBounds = true
    }
    
    override func setupLayout() {
        bgImage.pinToSuperview()
        
        header.leftAnchor ~= leftAnchor
        header.rightAnchor ~= rightAnchor
        header.topAnchor ~= topAnchor + 80
        header.heightAnchor ~= 100
        
        infornationView.leftAnchor ~= leftAnchor
        infornationView.rightAnchor ~= rightAnchor
        infornationView.bottomAnchor ~= bottomAnchor
        infornationView.heightAnchor ~= 550
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
}


// MARK: - InornationView

final class InfornationView: View {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionItem, CellItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SectionItem, CellItem>
    private typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<CellItem>
    
    private typealias Haracteristic = UICollectionView.CellRegistration<HaracteriticsCell, HaracteriticsContentView.Model>
    private typealias Descr = UICollectionView.CellRegistration<DescriptionCell, DescriptionContentView.Model>
    private typealias Photos = UICollectionView.CellRegistration<PhotosCell, PhotosContentView.Model>
    private typealias But = UICollectionView.CellRegistration<ButtonCell, ButtonContentView.Model>
        
    private enum SectionItem: Hashable, CaseIterable {
        case haracteristics
        case decision
        case photos
        case button
    }
    
    private enum CellItem: Hashable {
        case haracteristics(HaracteriticsContentView.Model)
        case decision(DescriptionContentView.Model)
        case photos(PhotosContentView.Model)
        case button(ButtonContentView.Model)
    }
    
    enum Action {
        case add
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    struct Model {
        let name: String
        let haracteristics: HaracteriticsContentView.Model
        let decision: DescriptionContentView.Model
        let photos: [PhotosContentView.Model]
        let button: ButtonContentView.Model
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            titleLabel.text = viewModel.name.uppercased()
            
            var snapshot = Snapshot()
            snapshot.appendSections([
                .haracteristics,
                .decision,
                .photos,
                .button
            ])
            
//            let haracteristicItem = CellItem.haracteristics(viewModel.haracteristics)
//            snapshot.appendItems([haracteristicItem], toSection: .haracteristics)
            
            let decisionItem = CellItem.decision(viewModel.decision)
            snapshot.appendItems([decisionItem], toSection: .decision)

            let photoItems = viewModel.photos.map { CellItem.photos($0)}
            snapshot.appendItems(photoItems, toSection: .photos)
            
            let buttonItem = CellItem.button(viewModel.button)
            snapshot.appendItems([buttonItem], toSection: .button)

            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 20)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.textAlignment = .center
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: InfornationView.layout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
        return view
    }()
    
    private lazy var dataSource: DataSource = {
        
        let haracteristicsCell = Haracteristic { cell, indexPath, item in
            cell.viewModel = item
        }
        
        let decripsionCell = Descr { cell, indexPath, item in
            cell.viewModel = item
        }
        
        let photoCell = Photos { cell, indexPath, item in
            cell.viewModel = item
        }
        
        let buttonCell = But { cell, indexPath, item in
            cell.actionHandler = { [weak self] action in
                guard let self else { return }
                switch action {
                case .add:
                    self.actionHandler(.add)
                }
            }
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderForAddView>(
            elementKind: "Header"
        ) { [weak self] view, kind, indexPath in
            guard let section = self?.dataSource.snapshot().sectionIdentifiers[indexPath.section] else { return }
            switch section {
            case .haracteristics:
                view.showHeader = false
            case .decision:
                view.showHeader = false
            case .photos:
                view.setTitle("photos".localized)
            case .button:
                view.showHeader = false
            }
        }
        
        let dataSource = DataSource (
            collectionView: collectionView
        ) { collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
            case .haracteristics(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: haracteristicsCell,
                    for: indexPath,
                    item: viewModel
                )
                
            case .decision(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: decripsionCell,
                    for: indexPath,
                    item: viewModel
                )
            case .photos(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: photoCell,
                    for: indexPath,
                    item: viewModel
                )
            case .button(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: buttonCell,
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
        let color2: UIColor = .white
        let color1 = #colorLiteral(red: 0.8757615685, green: 0.9425374866, blue: 0.8915592432, alpha: 1)
        
        backgroundGradient = .init(
            colors: [color1, color2, color2, color2, color2]
        )
        addSubview(titleLabel)
        addSubview(collectionView)
    }
    
    override func setupLayout() {
        titleLabel.topAnchor ~= topAnchor + 10
        titleLabel.centerXAnchor ~= centerXAnchor
        titleLabel.heightAnchor ~= 50
            
        collectionView.topAnchor ~= titleLabel.bottomAnchor
        collectionView.leftAnchor ~= leftAnchor
        collectionView.rightAnchor ~= rightAnchor
        collectionView.bottomAnchor ~= bottomAnchor
    }
}

private extension InfornationView {
    static func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in

            let section = SectionItem.allCases[sectionIndex]

            switch section {
            case .haracteristics:
                return singleItemSection(estimatedHeight: 1, inset: 16, topPlusBottom: 1)
            case .decision:
                return singleItemSection(estimatedHeight: 180, inset: 16)
            case .photos:
                return photosSection()
            case .button:
                return singleItemSection(estimatedHeight: 60, inset: 16, topPlusBottom: 20)
            }
        }
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
    
    static func photosSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .absolute(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(10) // расстояние между ячейками
        
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
        section.orthogonalScrollingBehavior = .groupPagingCentered // для скролинга
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    static func butSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(52)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
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
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}

extension InfornationView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}


// MARK: - SectionHeaderView

final class SectionHeaderForAddView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderForAdd"
    
    var showHeader: Bool = true {
        didSet {
            if showHeader == false {
                titleLabel.isHidden = true
            }
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Onest-Medium", size: 16)
        label.textColor = UIColor(red: 0.067, green: 0.486, blue: 0.008, alpha: 1)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.leftAnchor ~= leftAnchor + 16
        titleLabel.bottomAnchor ~= bottomAnchor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(_ text: String) {
        titleLabel.text = text
    }
}

