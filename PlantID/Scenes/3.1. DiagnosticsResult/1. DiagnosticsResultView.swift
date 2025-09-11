//
//  DiagnosticsResultView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 26.06.25.
//

import UIKit

// MARK: - InornationView

final class DiagnosticsResultView: View {
    
    //----------------------------------------------------
    /*
     
    enum Actions {
        case add
        case back
        case help
    }
    var actionHandler: (Actions) -> Void = { _ in }
    
    struct Model {
        // Header
        let namePlant: String?
        let diseaseDescr: String?
        let currentDiagnoses: String?
        let plantType: String?
        let currentCondition: String?
        // Images (provide names via ViewModel so user can add assets)
        let currentDiagnosesIconName: String? = nil
        let currentDiagnosesTitle: String? = nil
        let plantTypeIconName: String? = nil
        let currentConditionIconName: String? = nil
        // Content
        let photos: [UIImage]
        let conditionValue: Float?
        let isHealthy: Bool?
        let disease: PreliminaryDiagnosesContentView.Model
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
                head:
                        .init(
                            namePlant: viewModel.namePlant,
                            currentDiagnoses: viewModel.currentDiagnoses,
                            currentDiagnosesIconName: viewModel.currentDiagnosesIconName,
                            currentDiagnosesTitle: viewModel.currentDiagnosesTitle,
                            plantType: viewModel.plantType,
                            plantTypeIconName: viewModel.plantTypeIconName,
                            currentCondition: viewModel.currentCondition,
                            currentConditionIconName: viewModel.currentConditionIconName
                        ),
                photos: phts,
                condition:
                        .init(
                            textValue: checkHealthy(viewModel.isHealthy ?? true),
                            conditionValue: viewModel.conditionValue
                        ),
                diagnosis: viewModel.disease,
                button: .init(buttonName: "create.care.plan"))
        }
    }
    //---------------------------------------------------------------------
     */
    
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionItem, CellItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SectionItem, CellItem>
    private typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<CellItem>
    
    private typealias Header = UICollectionView.CellRegistration<AboutPlantHeaderCell, AboutPlantHeaderCellContent.Model>
    private typealias FirstInformation = UICollectionView.CellRegistration<HeaderDiagnosticResultInformationCell, HeaderDiagnosticResultInformationContentView.Model>
    private typealias Photos = UICollectionView.CellRegistration<PhotosStripCell, PhotosStripContent.Model>
    private typealias Condition = UICollectionView.CellRegistration<ConditionViewCell, ConditionContentView.Model>
    private typealias Diagnosis = UICollectionView.CellRegistration<PreliminaryDiagnosesViewCell, PreliminaryDiagnosesContentView.Model>
    private typealias But = UICollectionView.CellRegistration<PrimaryCTAButtonCell, PrimaryCTAButtonContent.Model>
    
    private enum SectionItem: Hashable, CaseIterable {
        case header
        case firstInformation
        case photos
        case condition
        case diagnosis
        case button
    }
    
    private enum CellItem: Hashable {
        case header(AboutPlantHeaderCellContent.Model)
        case firstInformation(HeaderDiagnosticResultInformationContentView.Model)
        case photos(PhotosStripContent.Model)
        case condition(ConditionContentView.Model)
        case diagnosis(PreliminaryDiagnosesContentView.Model)
        case button(PrimaryCTAButtonContent.Model)
    }
    
    enum Actions {
        case add
        case back
        case settigs
    }
    var actionHandler: (Actions) -> Void = { _ in }
    
    struct Model {
        let header: AboutPlantHeaderCellContent.Model
        let firstInformation: HeaderDiagnosticResultInformationContentView.Model
        let photos: PhotosStripContent.Model
        let condition: ConditionContentView.Model
        let diagnosis: PreliminaryDiagnosesContentView.Model
        let button: PrimaryCTAButtonContent.Model
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            
            var snapshot = Snapshot()
            snapshot.appendSections([
                .header,
                .firstInformation,
                .photos,
                .condition,
                .diagnosis,
                .button
            ])
            
            let headerItem = CellItem.header(viewModel.header)
            snapshot.appendItems([headerItem], toSection: .header)
            
            let firstInformationItem = CellItem.firstInformation(viewModel.firstInformation)
            snapshot.appendItems([firstInformationItem], toSection: .firstInformation)
            
            snapshot.appendItems([.photos(viewModel.photos)], toSection: .photos)

            let conditionItem = CellItem.condition(viewModel.condition)
            snapshot.appendItems([conditionItem], toSection: .condition)
            
            let diagItems = CellItem.diagnosis(viewModel.diagnosis)
            snapshot.appendItems([diagItems], toSection: .diagnosis)
            
            let buttonItem = CellItem.button(viewModel.button)
            snapshot.appendItems([buttonItem], toSection: .button)

            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: DiagnosticsResultView.layout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.bounces = false
        view.backgroundColor = .clear
        view.contentInsetAdjustmentBehavior = .never
        view.contentInset = .init(top: 0, left: 0, bottom: 40, right: 0)
        return view
    }()
    
    private lazy var dataSource: DataSource = {
        
        let headerCell = Header {cell,indexPath,itemIdentifier in 
            cell.viewModel = itemIdentifier
            cell.actionHandler = { [weak self] action in
                guard let self else { return }
                switch action {
                case .tapLeft:
                    self.actionHandler(.back)
                case .tapRightTop:
                    self.actionHandler(.settigs)
                }
            }
        }
        
        let firstInformationCell = FirstInformation { cell, indexPath, item in
            cell.viewModel = item
        }
        let photoCell = Photos { cell, indexPath, item in
            cell.viewModel = item
        }
        let conditionCell = Condition { cell, indexPath, item in
            cell.viewModel = item
        }
        let diagnosisReg = Diagnosis { cell, indexPath, item in
            cell.viewModel = item
        }
        let buttonCell = But { cell, indexPath, item in
            cell.viewModel = item
            cell.actionHandler = { [weak self] in
                guard let self else { return }
                self.actionHandler(.add)
            }
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderForAddView>(
            elementKind: "Header"
        ) { [weak self] view, kind, indexPath in
            guard let section = self?.dataSource.snapshot().sectionIdentifiers[indexPath.section] else { return }
            switch section {
            case .header:
                view.showHeader = false
            case .firstInformation:
                view.showHeader = false
            case .photos:
                view.setTitle("photos".localized)
            case .condition:
                view.showHeader = false
            case .diagnosis:
                view.showHeader = false
            case .button:
                view.showHeader = false
            }
        }
        
        let dataSource = DataSource (
            collectionView: collectionView
        ) { collectionView, indexPath, item -> UICollectionViewCell in
            switch item {
                
            case .header(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: headerCell,
                    for: indexPath,
                    item: viewModel
                )
            case .firstInformation(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: firstInformationCell,
                    for: indexPath,
                    item: viewModel
                )
            case .photos(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: photoCell,
                    for: indexPath,
                    item: viewModel
                )
            case .condition(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: conditionCell,
                    for: indexPath,
                    item: viewModel
                )
            case .diagnosis(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: diagnosisReg,
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
        backgroundColor = #colorLiteral(red: 0.9768170714, green: 0.9967311025, blue: 0.9748296142, alpha: 1)
        addSubview(collectionView)
    }
    
    override func setupLayout() {
        collectionView.pinToSuperview()
    }
}

private extension DiagnosticsResultView {
    static func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in

            let section = SectionItem.allCases[sectionIndex]
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
                    estimatedHeight: 230,
                    inset: 16,
                    top: 30,
                    bot: 0
                )
            case .photos:
                return defaultSingleItemSection(
                    estimatedHeight: 70,
                    inset: 16,
                    top: 0,
                    bot: 0
                )
            case .condition:
                return defaultSingleItemSection(
                    estimatedHeight: 100,
                    inset: 16,
                    top: 16,
                    bot: 0
                )
            case .diagnosis:
                return defaultSingleItemSection(
                    estimatedHeight: 200,
                    inset: 16,
                    top: 20,
                    bot: 0
                )
            case .button:
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

extension DiagnosticsResultView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout { }
