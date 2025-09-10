//
//  AboutPlantViewNew.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 9.09.25.
//

import UIKit


final class AboutPlantViewNew: View {

    // MARK: - Typealiases
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionItem, CellItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SectionItem, CellItem>

    // MARK: - Section & Cell items
    private enum SectionItem: Int, Hashable, CaseIterable {
        case header
        case aboutInfo
        case plantInfo
        case photos
        case primaryCTA
    }

    private enum CellItem: Hashable {
        case header(AboutPlantHeaderCellContent.Model)
        case aboutInfo(AboutPlantInfoContent.Model)
        case plantInfo(PlantInfoContent.Model)
        case photos(PhotosStripContent.Model)
        case primaryCTA(PrimaryCTAButtonContent.Model)
    }

    // MARK: - Actions
    enum Action {
        case header(AboutPlantHeaderCellContent.Action)
        case aboutInfo(AboutPlantInfoContent.Action)
        case photos(index: Int)
        case addToMyPlants
    }
    var actionHandler: (Action) -> Void = { _ in }

    // MARK: - Model
    struct Model {
        let header: AboutPlantHeaderCellContent.Model
        let aboutInfo: AboutPlantInfoContent.Model
        let plantInfo: PlantInfoContent.Model
        let photos: PhotosStripContent.Model
        let primaryCTA: PrimaryCTAButtonContent.Model
    }
    var viewModel: Model? { didSet { applySnapshot() } }

    // MARK: - Collection View
    private lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: Self.layout())
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        v.delegate = self
        v.showsVerticalScrollIndicator = false
        v.contentInsetAdjustmentBehavior = .never
        v.bounces = false
        v.contentInset = .init(top: 0, left: 0, bottom: 40, right: 0)
        return v
    }()

    // MARK: - DataSource
    private lazy var dataSource: DataSource = {
        let headerRegistration = UICollectionView.CellRegistration<AboutPlantHeaderCell, AboutPlantHeaderCellContent.Model> { [weak self] cell, indexPath, item in
            cell.viewModel = item
            cell.actionHandler = { action in
                self?.actionHandler(.header(action))
            }
        }

        let aboutInfoRegistration = UICollectionView.CellRegistration<AboutPlantInfoCell, AboutPlantInfoContent.Model> { [weak self] cell, indexPath, item in
            cell.viewModel = item
            cell.actionHandler = { action in
                self?.actionHandler(.aboutInfo(action))
            }
        }

        let plantInfoRegistration = UICollectionView.CellRegistration<PlantInfoCell, PlantInfoContent.Model> { cell, indexPath, item in
            cell.viewModel = item
        }

        let photosRegistration = UICollectionView.CellRegistration<PhotosStripCell, PhotosStripContent.Model> { [weak self] cell, indexPath, item in
            cell.viewModel = item
            cell.actionHandler = { index in
                self?.actionHandler(.photos(index: index))
            }
        }

        let primaryCTARegistration = UICollectionView.CellRegistration<PrimaryCTAButtonCell, PrimaryCTAButtonContent.Model> { [weak self] cell, indexPath, item in
            cell.viewModel = item
            cell.actionHandler = {
                self?.actionHandler(.addToMyPlants)
            }
        }

        return DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .header(let model):
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: indexPath, item: model)
            case .aboutInfo(let model):
                return collectionView.dequeueConfiguredReusableCell(using: aboutInfoRegistration, for: indexPath, item: model)
            case .plantInfo(let model):
                return collectionView.dequeueConfiguredReusableCell(using: plantInfoRegistration, for: indexPath, item: model)
            case .photos(let model):
                return collectionView.dequeueConfiguredReusableCell(using: photosRegistration, for: indexPath, item: model)
            case .primaryCTA(let model):
                return collectionView.dequeueConfiguredReusableCell(using: primaryCTARegistration, for: indexPath, item: model)
            }
        }
    }()

    // MARK: - Lifecycle
    override func setupContent() {
        addSubview(collectionView)
    }

    override func setupLayout() {
        collectionView.pinToSuperview()
    }

    // MARK: - Snapshot
    private func applySnapshot() {
        guard let vm = viewModel else { return }
        var snapshot = Snapshot()
        snapshot.appendSections(SectionItem.allCases)
        snapshot.appendItems([.header(vm.header)], toSection: .header)
        snapshot.appendItems([.aboutInfo(vm.aboutInfo)], toSection: .aboutInfo)
        snapshot.appendItems([.plantInfo(vm.plantInfo)], toSection: .plantInfo)
        snapshot.appendItems([.photos(vm.photos)], toSection: .photos)
        snapshot.appendItems([.primaryCTA(vm.primaryCTA)], toSection: .primaryCTA)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - Layout
    private static func layout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section = SectionItem.allCases[sectionIndex]
            switch section {
            case .header:
                return defaultSingleItemSection(
                    estimatedHeight: 360,
                    inset: 0,
                    top: 0,
                    bot: 0
                )
            case .aboutInfo:
                return defaultSingleItemSection(
                    estimatedHeight: 260,
                    inset: 0,
                    top: 24,
                    bot: 0
                )
            case .plantInfo:
                return defaultSingleItemSection(
                    estimatedHeight: 180,
                    inset: 0,
                    top: 24,
                    bot: 0
                )
            case .photos:
                return defaultSingleItemSection(
                    estimatedHeight: 150,
                    inset: 0,
                    top: 24,
                    bot: 0
                )
            case .primaryCTA:
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

extension AboutPlantViewNew: UICollectionViewDelegate {}
