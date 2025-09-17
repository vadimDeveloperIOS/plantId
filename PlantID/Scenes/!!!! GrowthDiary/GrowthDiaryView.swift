//
//  GrowthDiaryView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 16.09.25.
//

import UIKit

final class GrowthDiaryView: BaseViewWithNavigationBarGreen {
    
    // MARK: - Actions
    enum ActionChild {
        case edit(index: Int)
        case addNew
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
    
    private lazy var thirdTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-SemiBold", size: 20)
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    // MARK: - Typealiases
    private typealias DataSource = UICollectionViewDiffableDataSource<SectionItem, CellItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<SectionItem, CellItem>
    
    // MARK: - Section & Cell items
    private enum SectionItem: Int, Hashable, CaseIterable {
        case stories
        case btn
    }
    
    enum CellItem: Hashable {
        case stories(GrowthDiaryContent.Model)
        case btn(PrimaryCTAButtonContent.Model)
    }
    
    // MARK: - Model
    struct Model {
        let textForFirstLbl: String
        let textForSecondLbl: String
        let textForThirdLbl: String
        var stories: [GrowthDiaryContent.Model]
        var btn: PrimaryCTAButtonContent.Model
    }
    
    var viewModel: Model? {
        didSet {
            guard let vm = viewModel else { return }
            // TODO: ИСПРАВИТЬ
            var snapshot = Snapshot()
            snapshot.appendSections(SectionItem.allCases)
            let stories = vm.stories.map {
                CellItem.stories($0)
            }
            snapshot.appendItems(stories, toSection: .stories)
            
            let btn = CellItem.btn(vm.btn)
            snapshot.appendItems( [btn], toSection: .btn)
            dataSource.apply(snapshot, animatingDifferences: true)
            
            firsTitle.text = vm.textForFirstLbl
            secondTitle.text = vm.textForSecondLbl
            thirdTitle.text = vm.textForThirdLbl
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
        v.contentInset = .init(top: 0, left: 0, bottom: 60, right: 0)
        return v
    }()
    
    // MARK: - DataSource
    private lazy var dataSource: DataSource = {
        let storyRegistration = UICollectionView.CellRegistration<GrowthDiaryCell, GrowthDiaryContent.Model> { [weak self] cell, indexPath, item in
            cell.viewModel = item
            cell.actionHandler = { action in
                self?.actionHandlerChild(.edit(index: indexPath.item))
            }
        }
        let primaryCTARegistration = UICollectionView.CellRegistration<PrimaryCTAButtonCell, PrimaryCTAButtonContent.Model> { [weak self] cell, indexPath, item in
            cell.viewModel = item
            cell.actionHandler = {
                self?.actionHandlerChild(.addNew)
            }
        }
        
        return DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .stories(let model):
                return collectionView.dequeueConfiguredReusableCell(
                    using: storyRegistration,
                    for: indexPath,
                    item: model
                )
            case .btn(let model):
                return collectionView.dequeueConfiguredReusableCell(
                    using: primaryCTARegistration,
                    for: indexPath,
                    item: model
                )
            }
        }
    }()
    
    // MARK: - Lifecycle
    override func setupContent() {
        super.setupContent()
        backgroundColor = .white
        addSubview(firsTitle)
        addSubview(secondTitle)
        addSubview(thirdTitle)
        addSubview(collectionView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        firsTitle.topAnchor ~= greenNabBg.bottomAnchor + 36
        firsTitle.centerXAnchor ~= centerXAnchor
        
        secondTitle.topAnchor ~= firsTitle.bottomAnchor + 10
        secondTitle.leftAnchor ~= leftAnchor + 16
        secondTitle.rightAnchor ~= rightAnchor - 16
        
        thirdTitle.topAnchor ~= secondTitle.bottomAnchor + 16
        thirdTitle.leftAnchor ~= leftAnchor + 16
        
        collectionView.topAnchor ~= thirdTitle.bottomAnchor + 12
        collectionView.leftAnchor ~= leftAnchor
        collectionView.rightAnchor ~= rightAnchor
        collectionView.bottomAnchor ~= bottomAnchor
    }
    
    // MARK: - Layout
    private static func layout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            // item
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(80)
            )
            let item  = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 16,
                bottom: 30,
                trailing: 16
            )
            section.interGroupSpacing = 20
            return section
        }
    }
}

extension GrowthDiaryView: UICollectionViewDelegate {}
