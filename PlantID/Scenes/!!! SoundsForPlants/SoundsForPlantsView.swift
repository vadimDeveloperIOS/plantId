//
//  SoundsForPlantsView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 16.09.25.
//


import UIKit

final class SoundsForPlantsView: BaseViewWithNavigationBarGreen {
    
    // MARK: - Actions
    enum ActionChild {
        case sound(SoundsForPlantsContent.Action, index: Int)
    }
    var actionHandlerChild: (ActionChild) -> Void = { _ in }
    
    // MARK: - UI Views
    
    private lazy var firsTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-SemiBold", size: 24)
        view.textColor = #colorLiteral(red: 0.5569139123, green: 0.786534369, blue: 0.3074461818, alpha: 1)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    private lazy var secondTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 16)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    // MARK: - Typealiases
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionItem, CellItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SectionItem, CellItem>
    
    // MARK: - Section & Cell items
    private enum SectionItem: Int, Hashable, CaseIterable {
        case sounds
    }
    
    private enum CellItem: Hashable {
        case sound(SoundsForPlantsContent.Model)
    }
    
    // MARK: - Model
    struct Model {
        let textForFirstLbl: String
        let textForSecondLbl: String
        var sounds: [SoundsForPlantsContent.Model]
    }
    
    var viewModel: Model? {
        didSet {
            guard let vm = viewModel else { return }
            
            var snapshot = Snapshot()
            snapshot.appendSections(SectionItem.allCases)
            let sounds = vm.sounds.map { CellItem.sound($0) }
            snapshot.appendItems(sounds, toSection: .sounds)
            dataSource.apply(snapshot, animatingDifferences: true)
            
            firsTitle.text = viewModel?.textForFirstLbl
            secondTitle.text = viewModel?.textForSecondLbl
        }
    }
    
    // MARK: - Collection View
    private lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: Self.layout())
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        v.delegate = self
        v.showsVerticalScrollIndicator = false
        v.contentInsetAdjustmentBehavior = .never
        return v
    }()
    
    // MARK: - DataSource
    private lazy var dataSource: DataSource = {
        let soundRegistration = UICollectionView.CellRegistration<SoundsForPlantsCell, SoundsForPlantsContent.Model> { [weak self] cell, indexPath, item in
            cell.viewModel = item
            cell.actionHandler = { action in
                self?.actionHandlerChild(.sound(action, index: indexPath.item))
            }
        }
        
        return DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .sound(let model):
                return collectionView.dequeueConfiguredReusableCell(using: soundRegistration, for: indexPath, item: model)
            }
        }
    }()
    
    // MARK: - Lifecycle
    override func setupContent() {
        super.setupContent()
        backgroundColor = .white
        addSubview(firsTitle)
        addSubview(secondTitle)
        addSubview(collectionView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        firsTitle.topAnchor ~= greenNabBg.bottomAnchor + 36
        firsTitle.centerXAnchor ~= centerXAnchor
        
        secondTitle.topAnchor ~= firsTitle.bottomAnchor + 10
        secondTitle.leftAnchor ~= leftAnchor + 16
        secondTitle.rightAnchor ~= rightAnchor - 16
        
        collectionView.topAnchor ~= secondTitle.bottomAnchor + 12
        collectionView.leftAnchor ~= leftAnchor
        collectionView.rightAnchor ~= rightAnchor
        collectionView.bottomAnchor ~= bottomAnchor
    }
    
    // MARK: - Layout
    private static func layout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            // item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .estimated(160)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            // group: две карточки в строке
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(160)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item, item]
            )
            
            // section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 16, leading: 16, bottom: 40, trailing: 16)
            section.interGroupSpacing = 8
            return section
        }
    }
}

extension SoundsForPlantsView: UICollectionViewDelegate {}
