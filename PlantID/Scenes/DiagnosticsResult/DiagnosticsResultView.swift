//
//  DiagnosticsResultView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 26.06.25.
//

import UIKit

final class DiagnosticsResultView: View {
    
    enum Actions {
        case add
        case back
        case help
    }
    var actionHandler: (Actions) -> Void = { _ in }
    
    struct Model {
        let namePlant: String?
        let diseaseDescr: String?
        let currentDiagnoses: String?
        let plantType: String?
        let currentCondition: String?
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
                            currentDiagnoses: viewModel.currentDiagnoses,
                            plantType: viewModel.plantType,
                            currentCondition: viewModel.currentCondition
                        ),
                photos: phts,
                condition:
                        .init(
                            textValue: checkHealthy(viewModel.isHealthy ?? true),
                            conditionValue: viewModel.conditionValue
                        ),
                diagnosis: viewModel.disease,
                button: .init())
        }
    }
    
    private lazy var header: HeaderViewWithCustomBack = {
        let view = HeaderViewWithCustomBack()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleForButton = "diagnostic_result_big".localized
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
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "fake123")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var infornationView: DiagnosticInfornationView = {
        let view = DiagnosticInfornationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            if action == .add {
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
    
    private func checkHealthy(_ isHealthy: Bool) -> String {
        isHealthy ? "the_plant_is_healthy".localized : "the_plant_might_be_unhealthy".localized
    }
}


// MARK: - InornationView

final class DiagnosticInfornationView: View {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionItem, CellItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SectionItem, CellItem>
    private typealias SectionSnapshot = NSDiffableDataSourceSectionSnapshot<CellItem>
    
    private typealias Head = UICollectionView.CellRegistration<HeaderDiagnosticResultInformationCell, HeaderDiagnosticResultInformationContentView.Model>
    private typealias Photos = UICollectionView.CellRegistration<PhotosCell, PhotosContentView.Model>
    private typealias Condition = UICollectionView.CellRegistration<ConditionViewCell, ConditionContentView.Model>
    private typealias Diagnosis = UICollectionView.CellRegistration<PreliminaryDiagnosesViewCell, PreliminaryDiagnosesContentView.Model>
    private typealias But = UICollectionView.CellRegistration<ButtonCell, ButtonContentView.Model>
    
    private enum SectionItem: Hashable, CaseIterable {
        case head
        case photos
        case condition
        case diagnosis
        case button
    }
    
    private enum CellItem: Hashable {
        case head(HeaderDiagnosticResultInformationContentView.Model)
        case photos(PhotosContentView.Model)
        case condition(ConditionContentView.Model)
        case diagnosis(PreliminaryDiagnosesContentView.Model)
        case button(ButtonContentView.Model)
    }
    
    enum Actions {
        case add
    }
    var actionHandler: (Actions) -> Void = { _ in }
    
    struct Model {
        let head: HeaderDiagnosticResultInformationContentView.Model
        let photos: [PhotosContentView.Model]
        let condition: ConditionContentView.Model
        let diagnosis: PreliminaryDiagnosesContentView.Model
        let button: ButtonContentView.Model
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            
            var snapshot = Snapshot()
            snapshot.appendSections([
                .head,
                .photos,
                .condition,
                .diagnosis,
                .button
            ])
            
            let headItem = CellItem.head(viewModel.head)
            snapshot.appendItems([headItem], toSection: .head)
            
            let photoItems = viewModel.photos.map { CellItem.photos($0)}
            snapshot.appendItems(photoItems, toSection: .photos)
            
            let conditionItem = CellItem.condition(viewModel.condition)
            snapshot.appendItems([conditionItem], toSection: .condition)

//            let diagItems = viewModel.diagnosis.map { CellItem.diagnosis($0) }
//            snapshot.appendItems(diagItems, toSection: .diagnosis)
            
            let diagItems = CellItem.diagnosis(viewModel.diagnosis)
            snapshot.appendItems([diagItems], toSection: .diagnosis)
            
            let buttonItem = CellItem.button(viewModel.button)
            snapshot.appendItems([buttonItem], toSection: .button)

            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: DiagnosticInfornationView.layout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.contentInset = .init(top: 20, left: 0, bottom: 10, right: 0)
        return view
    }()
    
    private lazy var dataSource: DataSource = {
        
        let headCell = Head { cell, indexPath, item in
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
            case .head:
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
            case .head(let viewModel):
                return collectionView.dequeueConfiguredReusableCell(
                    using: headCell,
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
}

private extension DiagnosticInfornationView {
    static func layout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in

            let section = SectionItem.allCases[sectionIndex]
            switch section {
            case .head:
                return singleItemSection(estimatedHeight: 50, inset: 16, top: 10)
            case .photos:
                return photosSection()
            case .condition:
                return singleItemSection(estimatedHeight: 80, inset: 16, bottom: 30)
            case .diagnosis:
                return singleItemSection(estimatedHeight: 50, inset: 16)
            case .button:
                return singleItemSection(estimatedHeight: 65, inset: 16, top: 25)
            }
        }
    }
    
    private static func singleItemSection(estimatedHeight: CGFloat, inset: CGFloat, top: CGFloat = 10, bottom: CGFloat = 10 ) -> NSCollectionLayoutSection {
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
            bottom: bottom,
            trailing: inset
        )
        return section
    }
    
    private static func photosSection() -> NSCollectionLayoutSection {
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
}

extension DiagnosticInfornationView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

