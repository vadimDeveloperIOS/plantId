//
//  MyPlantsWhenHavePlants.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 3.07.25.
//

import UIKit

final class MyPlantsWhenHavePlants: View {
    
    var segmetedNumber: Int? {
        didSet {
            guard let segmetedNumber else { return }
            segmented.selectedIndex = segmetedNumber
        }
    }
    
    enum Action {
        case back
        case help
        case changeSection
        case viewMore(index: Int)
        case addToMyPlants(index: Int)
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    // MARK: Section & Item

    private enum Section: Hashable, CaseIterable {
        case plants
    }

    private enum Item: Hashable {
        case my(MyPlantsWhenHavePlantsContent.Model)
        case history(HistoryWhenHavePlantsContent.Model)
    }

    // MARK: ViewModel

    struct Model {
        let my: [MyPlantsWhenHavePlantsContent.Model]
        let history: [HistoryWhenHavePlantsContent.Model]
    }

    var viewModel: Model? {
        didSet {
            guard let m = viewModel else { return }
            segmented.onChange = { [weak self] indx in
                self?.applySnapshot(for: indx, vm: m)
            }
            applySnapshot(for: 0, vm: m)
        }
    }
    
    // MARK: UI Elements
    
    private lazy var headerTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 20)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.text = "my_plants".localized
        view.contentMode = .center
        return view
    }()
    private lazy var segmented: SimpleSegmentedControl = {
        let view = SimpleSegmentedControl(
            items: ["my_plants_little".localized, "history_ little".localized]
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 24
        return view
    }()

    // MARK: CollectionView + DataSource

    private typealias Snapshot   = NSDiffableDataSourceSnapshot<Section, Item>
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

    private lazy var collectionView: UICollectionView = {
        let layout = MyPlantsWhenHavePlants.makeLayout()
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
        let myPlant = UICollectionView.CellRegistration<MyPlantsWhenHavePlantsCell, MyPlantsWhenHavePlantsContent.Model> { cell, indexPath, model in
            cell.viewModel = model
            cell.actionHandler = { [weak self] action in
                guard let self else { return }
                switch action {
                case .viewMore:
                    self.actionHandler(.viewMore(index: indexPath.row))
                }
            }
        }
        
        let history = UICollectionView.CellRegistration<HistoryWhenHavePlantsCell, HistoryWhenHavePlantsContent.Model> { cell, indexPath, model in
            cell.viewModel = model
            cell.actionHandler = { [weak self] action in
                guard let self else { return }
                self.actionHandler(.addToMyPlants(index: indexPath.row))
            }
        }
        let ds = DataSource(collectionView: collectionView) { cv, ip, item in
            switch item {
            case .my(let m):
                return cv.dequeueConfiguredReusableCell(using: myPlant,    for: ip, item: m)
            case .history(let m):
                return cv.dequeueConfiguredReusableCell(using: history,    for: ip, item: m)
            }
        }
        return ds
    }()

    // MARK: Setup

    override func setupContent() {
        setMainBgGradient()
        addSubview(headerTitle)
        addSubview(segmented)
        addSubview(collectionView)
        
        clipsToBounds = true
    }

    override func setupLayout() {
        headerTitle.centerXAnchor ~= centerXAnchor
        headerTitle.topAnchor ~= topAnchor + 80
        
        segmented.leftAnchor ~= leftAnchor + 16
        segmented.rightAnchor ~= rightAnchor - 16
        segmented.topAnchor ~= topAnchor + 150
        
        collectionView.topAnchor ~= segmented.bottomAnchor + 10
        collectionView.leftAnchor ~= leftAnchor
        collectionView.rightAnchor ~= rightAnchor
        collectionView.bottomAnchor ~= bottomAnchor
    }
    
    private func applySnapshot(for segmentIndex: Int, vm: Model) {
        var snap = Snapshot()
        snap.appendSections([.plants])

        if segmentIndex == 0 {
            snap.appendItems(vm.my.map(Item.my), toSection: .plants)
        } else {
            snap.appendItems(vm.history.map(Item.history), toSection: .plants)
        }
        dataSource.apply(snap, animatingDifferences: true)
    }

    // MARK: Layout Factory

    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section = Section.allCases[sectionIndex]
            switch section {
            case .plants:
                return singleItemSection(estimatedHeight: 200, inset: 16)
                
            }
        }
    }

    private static func singleItemSection(estimatedHeight: CGFloat,
                                          inset: CGFloat,
                                          top: CGFloat = 10,
                                          bottom: CGFloat = 10 ) -> NSCollectionLayoutSection {
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
        section.interGroupSpacing = 20
        
        return section
    }
}

extension MyPlantsWhenHavePlants: UICollectionViewDelegate {}

// SegmentedControl

final class SimpleSegmentedControl: View {
    // MARK: – Публичное API
    var items: [String] {
        didSet { configureButtons() }
    }
    var selectedIndex: Int = 0 {
        didSet { updateSelection() }
    }
    var onChange: ((Int) -> Void)?

    // MARK: – Вьюхи
    private lazy var stack: UIStackView = {
        let s = UIStackView(arrangedSubviews: buttons)
        s.axis = .horizontal
        s.distribution = .fillEqually
        s.spacing = 20
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    private var buttons: [UIButton] = []

    // MARK: – Инициализация
    init(items: [String]) {
        self.items = items
        super.init(frame: .zero)
        configureButtons()
        addSubview(stack)
        stack.topAnchor ~= topAnchor + 3
        stack.bottomAnchor ~= bottomAnchor - 3
        stack.leftAnchor ~= leftAnchor + 3
        stack.rightAnchor ~= rightAnchor - 3
        heightAnchor ~= 48
        updateSelection()
    }
    required init?(coder: NSCoder) { fatalError() }

    // MARK: – Настройка кнопок
    private func configureButtons() {
        // удаляем старые
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        // создаём новые
        for (i, title) in items.enumerated() {
            let btn = UIButton(type: .system)
            btn.tag = i
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = UIFont(name: "Onest-Medium", size: 16)
            btn.layer.cornerRadius = 21
            btn.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
            buttons.append(btn)
            stack.addArrangedSubview(btn)
        }
    }

    // MARK: – Обработка тапов
    @objc private func tapped(_ btn: UIButton) {
        selectedIndex = btn.tag
        onChange?(selectedIndex)
    }

    // MARK: – Обновляем внешний вид
    private func updateSelection() {
        for (i, btn) in buttons.enumerated() {
            if i == selectedIndex {
                // закрашены
                btn.backgroundColor = UIColor(hex: "#8FDB85")
                btn.setTitleColor(.white, for: .normal)
            } else {
                // не закрашены
                btn.backgroundColor = .white
                btn.setTitleColor(UIColor(hex: "#117C02"), for: .normal)
            }
        }
    }
}



// -------------------------------------------------
// MARK: - CELL "MY PLANTS"
// -------------------------------------------------

final class MyPlantsWhenHavePlantsCell: UICollectionViewCell {
    
    var viewModel: MyPlantsWhenHavePlantsContent.Model {
        get {
            content.viewModel ?? .init()
        }
        set {
            content.viewModel = newValue
        }
    }
    
    var actionHandler: (MyPlantsWhenHavePlantsContent.Action) -> Void {
        get {
            content.actionHandler
        }
        set {
            content.actionHandler = newValue
        }
    }
    
    private lazy var content: MyPlantsWhenHavePlantsContent = {
        let view = MyPlantsWhenHavePlantsContent()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

// -------------------------------------------------
// MARK: - CONTENT VIEW "MY PLANTS
// -------------------------------------------------

final class MyPlantsWhenHavePlantsContent: View {
    
    enum Action {
        case viewMore
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    struct Model: Hashable {
        var photo: UIImage?
        var name: String?
        var descr: String?
        var amountVal: Int?
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            photo.image = viewModel.photo
            nameLbl.text = viewModel.name
            decrLbl.text = viewModel.descr
            setupStackWithRateWatering(viewModel.amountVal ?? 1)
        }
    }
    
    private lazy var photo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        view.widthAnchor ~= 96
        view.heightAnchor ~= 121
        return view
    }()
    
    private lazy var nameLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.font = UIFont(name: "Onest-SemiBold", size: 12)
        view.textAlignment = .left
        return view
    }()
    
    private lazy var decrLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.font = UIFont(name: "Onest-Regular", size: 10)
        view.textAlignment = .left
        view.numberOfLines = 3
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
    
    private lazy var viewMoreBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let title = "view_more".localized
        let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 0.067, green: 0.486, blue: 0.008, alpha: 1),
                .font: UIFont(name: "Onest-SemiBold", size: 14)!,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        let attributed = NSAttributedString(string: title, attributes: attributes)
        view.setAttributedTitle(attributed, for: .normal)
        
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.viewMore)
                }
            )
            , for: .touchUpInside
        )
        view.widthAnchor ~= 90
        view.heightAnchor ~= 18
        return view
    }()
    
    override func setupContent() {
        let col1 = #colorLiteral(red: 0.9213452339, green: 0.9863826632, blue: 0.9378272891, alpha: 1)
        let col2 = #colorLiteral(red: 0.8142027259, green: 0.9249679446, blue: 0.8149197698, alpha: 1)
        backgroundGradient = .init(colors: [col1, col2])
        layer.cornerRadius = 16
        clipsToBounds = true
        
        addSubview(photo)
        addSubview(nameLbl)
        addSubview(decrLbl)
        addSubview(stack)
        addSubview(viewMoreBtn)
    }
    
    override func setupLayout() {
        photo.leftAnchor ~= leftAnchor + 16
        photo.topAnchor ~= topAnchor + 10
        photo.bottomAnchor ~= bottomAnchor - 10
        
        nameLbl.leftAnchor ~= photo.rightAnchor + 10
        nameLbl.topAnchor ~= topAnchor + 10
        
        decrLbl.leftAnchor ~= photo.rightAnchor + 10
        decrLbl.rightAnchor ~= rightAnchor - 8
        decrLbl.topAnchor ~= nameLbl.bottomAnchor + 8
        
        stack.leftAnchor ~= photo.rightAnchor + 10
        stack.topAnchor ~= decrLbl.bottomAnchor + 10
        
        viewMoreBtn.rightAnchor ~= rightAnchor - 16
        viewMoreBtn.bottomAnchor ~= bottomAnchor - 10
    }
    
    private func setupStackWithRateWatering(_ amountVal: Int) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for _ in 0..<amountVal {
            let iv = UIImageView()
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.image = UIImage(named: "copcop")
            iv.contentMode = .scaleAspectFit
            iv.widthAnchor ~= 24
            iv.heightAnchor ~= 24
            stack.addArrangedSubview(iv)
        }
    }
}



// ***************************************************************************************************************************
// -------------------------------------------------
// MARK: - HISTORY
// -------------------------------------------------
// -------------------------------------------------
// CELL "HISTORY"
// -------------------------------------------------

final class HistoryWhenHavePlantsCell: UICollectionViewCell {
    
    var viewModel: HistoryWhenHavePlantsContent.Model {
        get {
            content.viewModel ?? .init()
        }
        set {
            content.viewModel = newValue
        }
    }
    
    var actionHandler: (HistoryWhenHavePlantsContent) -> Void {
        get {
            content.actionHandler
        }
        set {
            content.actionHandler = newValue
        }
    }
    
    private lazy var content: HistoryWhenHavePlantsContent = {
        let view = HistoryWhenHavePlantsContent()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

// -------------------------------------------------
// MARK: - CONTENT VIEW "History"
// -------------------------------------------------

final class HistoryWhenHavePlantsContent: View {
    
    var actionHandler: (HistoryWhenHavePlantsContent) -> Void = { _ in }
    
    struct Model: Hashable {
        var photo: UIImage?
        var name: String?
        var descr: String?
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            photo.image = viewModel.photo
            nameLbl.text = viewModel.name?.uppercased()
            decrLbl.text = viewModel.descr
        }
    }
    
    private lazy var photo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        view.layer.masksToBounds = true
        view.widthAnchor ~= 97
        view.heightAnchor ~= 105
        return view
    }()
    
    private lazy var nameLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.075, green: 0.067, blue: 0.078, alpha: 1)
        view.font = UIFont(name: "Onest-SemiBold", size: 14)
        view.textAlignment = .left
        return view
    }()
    
    private lazy var decrLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.font = UIFont(name: "Onest-Regular", size: 10)
        view.textAlignment = .natural
        view.numberOfLines = 3
        return view
    }()
    
    private lazy var addToMyPlantsLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "add_to_my_plants".localized
        view.textColor = UIColor(red: 0.067, green: 0.486, blue: 0.008, alpha: 1)
        view.font = UIFont(name: "Onest-SemiBold", size: 14)
        view.textAlignment = .left
        return view
    }()
    
    private lazy var addButton: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "green.plus"), for: .normal)
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 32
        view.heightAnchor ~= 32
        view.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
                self.actionHandler(self)
            })
            , for: .touchUpInside
        )
        return view
    }()
    
    override func setupContent() {
        let col1 = #colorLiteral(red: 0.981641233, green: 0.9965693355, blue: 0.9790676236, alpha: 1)
        let col2 = #colorLiteral(red: 0.8909534216, green: 0.9711504579, blue: 0.9007031322, alpha: 1)
        backgroundGradient = .init(colors: [col1, col2])
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        clipsToBounds = true
        
        layer.borderWidth = 0.5
        layer.borderColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        
        addSubview(photo)
        addSubview(nameLbl)
        addSubview(decrLbl)
        addSubview(addToMyPlantsLbl)
        addSubview(addButton)
    }
    
    override func setupLayout() {
        photo.leftAnchor ~= leftAnchor + 16
        photo.topAnchor ~= topAnchor + 10
        photo.bottomAnchor ~= bottomAnchor - 10
        
        nameLbl.leftAnchor ~= photo.rightAnchor + 10
        nameLbl.topAnchor ~= topAnchor + 10
        
        decrLbl.leftAnchor ~= photo.rightAnchor + 10
        decrLbl.rightAnchor ~= rightAnchor - 8
        decrLbl.topAnchor ~= nameLbl.bottomAnchor + 8
        
        addButton.rightAnchor ~= rightAnchor - 16
        addButton.bottomAnchor ~= bottomAnchor - 10
        
        addToMyPlantsLbl.rightAnchor ~= addButton.leftAnchor - 10
        addToMyPlantsLbl.centerYAnchor ~= addButton.centerYAnchor
    }
}
