//
//  PaywallView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 7.07.25.
//

import UIKit
import Lottie

final class OnboardingFourthView: View {
    
    enum Action {
        case continueAndMakePay
        case selectPlan(Int)
        case scrolledDown
        case startedScroll
        case noPaymentNow
        case showHomeView
        
        case privacyPolicy
        case termsOfUse
        case restorePurchases
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    var needToShowNoPaymentNow: Bool = false {
        didSet {
            if needToShowNoPaymentNow == true {
                noPaymentButton.isHidden = false
                // Удаляем старые констрейнты
                if let superview = button.superview {
                    for constraint in superview.constraints {
                        if constraint.firstItem as? UIView == button || constraint.secondItem as? UIView == button {
                            superview.removeConstraint(constraint)
                        }
                    }
                }
                button.widthAnchor ~= 343
                button.heightAnchor ~= 52
                button.bottomAnchor ~= noPaymentButton.topAnchor - 10
                button.centerXAnchor ~= simpleView.centerXAnchor
            }
        }
    }
    
    var needToHideAnimation: Bool = false {
        didSet {
            content.needToHideAnimation = needToHideAnimation
        }
    }
    
    var needToShowXButton: Bool = false {
        didSet {
            if needToShowXButton == true {
                xButton.isHidden = false
            }
        }
    }
    
    var viewModel: PaywallView.Model? {
        didSet {
            guard let viewModel else { return }
            content.viewModel = viewModel
        }
    }
    
    private lazy var content: PaywallView = {
        let view = PaywallView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .selectPlan(let v):
                self.actionHandler(.selectPlan(v))
            case .scrolledDown:
                self.actionHandler(.scrolledDown)
            case .startedScroll:
                self.actionHandler(.startedScroll)
            }
        }
        return view
    }()
    
    private lazy var xButton: UIButton = {
        let view = UIButton()
        view.setBackgroundImage(
            UIImage(systemName: "xmark")?.withTintColor(
                #colorLiteral(red: 0.08188111335, green: 0.4976429939, blue: 0.03094960749, alpha: 1) ,
                renderingMode: .alwaysOriginal),
            for: .normal
        )
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.showHomeView)
                }
            ),
            for: .touchUpInside
        )
        view.widthAnchor ~= 25
        view.heightAnchor ~= 25
        view.isHidden = true
        return view
    }()
    
    private lazy var simpleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 160
        return view
    }()
    
    private lazy var button: UIButton = {
        let view = UIButton.greenButtonContinue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.continueAndMakePay)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var noPaymentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("no_payment_now".localized, for: .normal)
        button.setTitleColor(UIColor(red: 0.349, green: 0.376, blue: 0.369, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(name: "Onest-Regular", size: 14)
        button.widthAnchor ~= 160
        button.heightAnchor ~= 20
        button.isHidden = true
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "no.pay")
        img.contentMode = .scaleAspectFill
        button.addSubview(img)
        img.widthAnchor ~= 18
        img.heightAnchor ~= 18
        img.leftAnchor ~= button.leftAnchor
        button.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
//                self.actionHandler(.noPaymentNow)
            })
            , for: .touchUpInside
        )
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private lazy var downBut1: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let title = "privacy_policy".localized
        let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 0.114, green: 0.235, blue: 0.169, alpha: 1),
                .font: UIFont(name: "Onest-Medium", size: 12)!,
            ]
        let attributed = NSAttributedString(string: title, attributes: attributes)
        view.setAttributedTitle(attributed, for: .normal)
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.privacyPolicy)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var downBut2: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let title = "terms_of_use".localized
        let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 0.114, green: 0.235, blue: 0.169, alpha: 1),
                .font: UIFont(name: "Onest-Medium", size: 12)!,
            ]
        let attributed = NSAttributedString(string: title, attributes: attributes)
        view.setAttributedTitle(attributed, for: .normal)
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.termsOfUse)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var downBut3: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let title = "restore_purchases".localized
        let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 0.114, green: 0.235, blue: 0.169, alpha: 1),
                .font: UIFont(name: "Onest-Medium", size: 12)!,
            ]
        let attributed = NSAttributedString(string: title, attributes: attributes)
        view.setAttributedTitle(attributed, for: .normal)
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.restorePurchases)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    override func setupContent() {
        addSubview(content)
        addSubview(simpleView)
        simpleView.backgroundColor = .white
        addSubview(button)
        addSubview(downBut1)
        addSubview(downBut2)
        addSubview(downBut3)
        addSubview(noPaymentButton)
        addSubview(xButton)
    }
    
    override func setupLayout() {
         
        content.topAnchor ~= topAnchor - 70
        content.leftAnchor ~= leftAnchor
        content.rightAnchor ~= rightAnchor
        content.bottomAnchor ~= bottomAnchor
         
        simpleView.leftAnchor ~= leftAnchor
        simpleView.rightAnchor ~= rightAnchor
        simpleView.bottomAnchor ~= bottomAnchor
        
        button.bottomAnchor ~= downBut1.topAnchor - 15
        button.centerXAnchor ~= simpleView.centerXAnchor
        
        downBut1.leftAnchor ~= simpleView.leftAnchor + 30
        downBut1.bottomAnchor ~= simpleView.bottomAnchor - 35
        
        downBut2.centerXAnchor ~= simpleView.centerXAnchor
        downBut2.centerYAnchor ~= downBut1.centerYAnchor
        
        downBut3.rightAnchor ~= simpleView.rightAnchor - 30
        downBut3.centerYAnchor ~= downBut1.centerYAnchor
        
        noPaymentButton.bottomAnchor ~= downBut1.topAnchor - 15
        noPaymentButton.centerXAnchor ~= simpleView.centerXAnchor
        
        xButton.topAnchor ~= topAnchor + 60
        xButton.rightAnchor ~= rightAnchor - 30
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyFadeMask()
    }

    private func applyFadeMask() {
        simpleView.layer.mask = nil
        let gradient = CAGradientLayer()
        gradient.frame = simpleView.bounds
        // Главный момент — тут нужен fade по альфе (clear → white):
        gradient.colors = [
            UIColor.clear.cgColor,  // полностью прозрачный
            UIColor.white.cgColor,  // полностью видимый
            UIColor.white.cgColor
        ]
        gradient.locations = [0.0, 0.4, 1.0] as [NSNumber]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint   = CGPoint(x: 0.5, y: 1.0)

        simpleView.layer.mask = gradient
    }
}

final class PaywallView: View {

    enum Action {
        case selectPlan(Int)
        case scrolledDown
        case startedScroll
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    var needToHideAnimation: Bool = false {
        didSet {
            for cell in collectionView.visibleCells {
                if let need = cell as? HeaderPayWallCell  {
                    need.needToHideAnimating = needToHideAnimation
                }
            }
        }
    }
    
    fileprivate var selectedPriceIndex = IndexPath(row: 0, section: 1) {
        didSet {
            actionHandler(.selectPlan(selectedPriceIndex.row))
        }
    }

    // MARK: - Section & Item

    private enum Section: Hashable, CaseIterable {
        case header, price, comments
    }

    private enum Item: Hashable {
        case header(HeaderModelPayWall)
        case price(PriceModelPayWall)
        case comments(CommentsModelPayWall)
    }

    // MARK: - ViewModel

    struct Model {
        let header: HeaderModelPayWall
        let price: [PriceModelPayWall]
        let comments: CommentsModelPayWall
    }

    var viewModel: Model? {
        didSet {
            guard let m = viewModel else { return }

            var snapshot = Snapshot()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems([.header(m.header)], toSection: .header)
            snapshot.appendItems(m.price.map { .price($0) }, toSection: .price)
            snapshot.appendItems([.comments(m.comments)], toSection: .comments)
            dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    // MARK: CollectionView + DataSource

    private typealias Snapshot   = NSDiffableDataSourceSnapshot<Section, Item>
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>

    private lazy var collectionView: UICollectionView = {
        let layout = PaywallView.makeLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        return cv
    }()

    private lazy var dataSource: DataSource = {
        let headerReg = UICollectionView.CellRegistration<HeaderPayWallCell, HeaderModelPayWall> { cell, _, model in
            cell.viewModel = model
            cell.needToHideAnimating = self.needToHideAnimation
        }
        let priceReg = UICollectionView.CellRegistration<PricePayWallCell, PriceModelPayWall> { cell, ind, model in
            cell.viewModel = model
            cell.isFir = ind.row == 0
            cell.isSelect = ind == self.selectedPriceIndex
        }
        let commentsReg = UICollectionView.CellRegistration<CommentsPayWallCell, CommentsModelPayWall> { cell, _, model in
            cell.viewModel = model
        }

        return DataSource(collectionView: collectionView) { cv, ip, item in
            switch item {
            case .header(let m):
                return cv.dequeueConfiguredReusableCell(using: headerReg, for: ip, item: m)
            case .price(let m):
                return cv.dequeueConfiguredReusableCell(using: priceReg, for: ip, item: m)
            case .comments(let m):
                return cv.dequeueConfiguredReusableCell(using: commentsReg, for: ip, item: m)
            }
        }
    }()

    // MARK: - Setup

    override func setupContent() {
        backgroundColor = #colorLiteral(red: 0.9725490212, green: 0.9725490212, blue: 0.9725490212, alpha: 1)
        addSubview(collectionView)
    }

    override func setupLayout() {
        collectionView.pinToSuperview()
    }

    // MARK: - Layout Factory

    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section = Section.allCases[sectionIndex]

            switch section {
            case .header:
                return singleItemSection(estimatedHeight: 550, inset: 0, top: 0, bottom: 0)
            case .price:
                return singleItemSection(estimatedHeight: 67, inset: 16)
            case .comments:
                return singleItemSection(estimatedHeight: 885, inset: 0, top: 5, bottom: 10)
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

extension PaywallView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = Section.allCases[indexPath.section]
        guard section == .price else { return }
        
        if let old = collectionView.cellForItem(at: selectedPriceIndex) as? PricePayWallCell {
            old.isSelect = false
        }
        
        if let new = collectionView.cellForItem(at: indexPath) as? PricePayWallCell {
            new.isSelect = true
        }
        selectedPriceIndex = indexPath
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        if offsetY > -45 {
            actionHandler(.startedScroll)
        }
        
        if contentHeight != 0.0 && offsetY + scrollViewHeight >= contentHeight {
            actionHandler(.scrolledDown)
        }
    }
}

// --------------------------
// MARK: - Models
// --------------------------


struct HeaderModelPayWall: Hashable { let page: Int }

struct PriceModelPayWall: Hashable {
    let price: String
    let priceWeek: String
    let productType: ProductType
}
struct CommentsModelPayWall: Hashable { let i: Bool }


// --------------------------
// MARK: - CELLS
// --------------------------
// --------------------------
// MARK: " 1 " Header Cell
// --------------------------
final class HeaderPayWallCell: UICollectionViewCell {
    var viewModel: HeaderModelPayWall? {
        didSet {
            guard let viewModel else { return }
            headerView.viewModel = viewModel
        }
    }
    
    var needToHideAnimating = false {
        didSet {
            headerView.needToHideAnimating = needToHideAnimating
        }
    }
    
    private lazy var headerView: ConnectionView = {
        let v = ConnectionView()
        contentView.addSubview(v)
        v.pinToSuperview()
        v.clipsToBounds = true
        return v
    }()
}

final class ConnectionView: View {
    var viewModel: HeaderModelPayWall? {
        didSet {
            guard let viewModel else { return }
            headerView.currentPage = viewModel.page
        }
    }
    
    var needToHideAnimating = false {
        didSet {
            if needToHideAnimating == true {
                animview.stop()
                animview.isHidden = true
            }
        }
    }
    
    private lazy var bgImage1: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "payment.bg.1")
        view.contentMode = .scaleAspectFill
        view.widthAnchor ~= 419
        view.heightAnchor ~= 527
        return view
    }()
    
    private lazy var bgImage2: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "payment.bg.2")
        view.contentMode = .scaleAspectFill
        view.widthAnchor ~= 390
        view.heightAnchor ~= 340
        return view
    }()
    
    private let animview: LottieAnimationView = {
        let animation = LottieAnimation.named("arrows.down.gold2")
        let view = LottieAnimationView(animation: animation)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .red
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.backgroundBehavior = .pauseAndRestore
        view.widthAnchor ~= 70
        view.heightAnchor ~= 70
        return view
    }()
    
    private lazy var headerView: HeaderPayWallContent = {
        let v = HeaderPayWallContent()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    
    override func setupContent() {
        backgroundColor = #colorLiteral(red: 0.7544613481, green: 0.9064767957, blue: 0.7871820331, alpha: 1)
        addSubview(bgImage1)
        addSubview(bgImage2)
        addSubview(headerView)
        addSubview(animview)
        animview.play()
    }
    
    override func setupLayout() {
        bgImage1.topAnchor ~= topAnchor + 20
        bgImage1.centerXAnchor ~= centerXAnchor
        
        bgImage2.topAnchor ~= topAnchor + 70
        bgImage2.centerXAnchor ~= centerXAnchor
        
        headerView.topAnchor ~= bgImage2.bottomAnchor - 50
        headerView.leftAnchor ~= leftAnchor
        headerView.rightAnchor ~= rightAnchor
        headerView.bottomAnchor ~= bottomAnchor
        
        animview.centerXAnchor ~= centerXAnchor
        animview.bottomAnchor ~= headerView.topAnchor + 20
    }
}

final class HeaderPayWallContent: View {
    
    var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    private lazy var firsTitle: UILabel = {
        let view = UILabel()
        view.text = "get_unlimited_access".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 28)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var firsTitleGreen: UILabel = {
        let view = UILabel()
        view.text = "to_all_features".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 28)
        view.textColor = #colorLiteral(red: 0.07304378599, green: 0.4857453108, blue: 0.007760594599, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var secondTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "enjoy_3_days_free_then_just".localized
        view.font = UIFont(name: "Onest-Regular", size: 16)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 1)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    private lazy var pageControl: CustomPageControl = {
        let view = CustomPageControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfPages = 5
        view.currentPage = 0
        view.widthAnchor ~= 66
        return view
    }()
    
    override func setupContent() {
        let col1 = #colorLiteral(red: 0.9728776813, green: 0.972877562, blue: 0.9728776813, alpha: 0.8019453642)
        let col2 = #colorLiteral(red: 0.9728776813, green: 0.972877562, blue: 0.9728776813, alpha: 1)
        backgroundGradient = .init(colors: [col1, col2, col2, col2])
        addSubview(firsTitle)
        addSubview(firsTitleGreen)
        addSubview(secondTitle)
        addSubview(pageControl)
        
        layer.cornerRadius = 32
        layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        layer.masksToBounds = true
    }
    
    override func setupLayout() {
        firsTitle.topAnchor ~= topAnchor + 15
        firsTitle.centerXAnchor ~= centerXAnchor
        
        firsTitleGreen.topAnchor ~= firsTitle.bottomAnchor + 5
        firsTitleGreen.centerXAnchor ~= centerXAnchor
        
        secondTitle.topAnchor ~= firsTitleGreen.bottomAnchor + 10
        secondTitle.centerXAnchor ~= centerXAnchor
        
        pageControl.topAnchor ~= secondTitle.bottomAnchor + 10
        pageControl.centerXAnchor ~= centerXAnchor
    }
}

// --------------------------
// MARK: " 2 " Price Cell
// --------------------------

final class PricePayWallCell: UICollectionViewCell {
    var viewModel: PriceModelPayWall? {
        didSet {
            guard let viewModel else { return }
            content.viewModel = viewModel
        }
    }
    var isSelect: Bool = false {
        didSet {
            content.isSelected = isSelect
        }
    }
    
    var isFir = false {
        didSet {
            content.isFirst = isFir
        }
    }
    
    private lazy var content: PricePayWallContentView = {
        let v = PricePayWallContentView()
        contentView.addSubview(v)
        v.pinToSuperview()
        return v
    }()
}

final class PricePayWallContentView: View {
    
    var viewModel: PriceModelPayWall? {
        didSet {
            guard let viewModel else { return }
            content.viewModel = viewModel
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            content.isSelected = isSelected
        }
    }
    
    var isFirst = false {
        didSet {
            if isFirst == false {
                greenViewWithLabel.isHidden = true
            } else {
                greenViewWithLabel.isHidden = false
            }
        }
    }
    
    private lazy var greenViewWithLabel: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.08188111335, green: 0.4976429939, blue: 0.03094960749, alpha: 1)
        view.layer.cornerRadius = 8
        view.widthAnchor ~= 129
        view.heightAnchor ~= 28
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Best Choice"
        lbl.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        lbl.font = UIFont(name: "Onest-Medium", size: 17)
        lbl.textAlignment = .center
        view.addSubview(lbl)
        lbl.centerXAnchor ~= view.centerXAnchor
        lbl.centerYAnchor ~= view.centerYAnchor
        return view
    }()

    private lazy var content: PricePayWallContent = {
        let v = PricePayWallContent()
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func setupContent() {
        addSubview(content)
        addSubview(greenViewWithLabel)
    }
    
    override func setupLayout() {
        content.pinToSuperview()
        greenViewWithLabel.topAnchor ~= content.topAnchor - 10
        greenViewWithLabel.rightAnchor ~= content.rightAnchor - 5
    }
}

final class PricePayWallContent: View {
    
    var isSelected = false {
        didSet {
            if isSelected == true {
                layer.borderWidth = 1
                layer.borderColor = #colorLiteral(red: 0.05764976889, green: 0.4858098626, blue: 0.008107689209, alpha: 1)
                let color1 = #colorLiteral(red: 0.9951933026, green: 1, blue: 0.9957693219, alpha: 1)
                let color2 = #colorLiteral(red: 0.8909534216, green: 0.9711504579, blue: 0.9007031322, alpha: 1)
                backgroundGradient = .init(
                    colors: [color1, color2, color2, color2, color2]
                )
                img.isHidden = false
                emptyCircle.isHidden = true
            }
            else {
                layer.borderWidth = 0.5
                layer.borderColor = #colorLiteral(red: 0.9058822393, green: 0.9058824182, blue: 0.9101879001, alpha: 1)
                let color1 = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
                let color2 = #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
                backgroundGradient = .init(
                    colors: [color1, color2, color2, color2, color2]
                )
                img.isHidden = true
                emptyCircle.isHidden = false
            }
        }
    }
    
    var viewModel: PriceModelPayWall? {
        didSet {
            guard let viewModel else { return }
            price.text = viewModel.price
            weekPrice1.text = viewModel.priceWeek
        }
    }
    
    private lazy var daysTitle: UILabel = {
        let view = UILabel()
        view.text = "3 days free"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 16)
        view.textColor = UIColor(red: 0.067, green: 0.488, blue: 0.009, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var price: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Medium", size: 14)
        view.textColor = UIColor(red: 0.173, green: 0.173, blue: 0.173, alpha: 0.8)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var vSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.6919196248, green: 0.8597958684, blue: 0.6742337346, alpha: 1)
        view.widthAnchor ~= 1
        view.heightAnchor ~= 43
        return view
    }()
    
    private lazy var weekPrice1: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 16)
        view.textColor = UIColor(red: 0.067, green: 0.488, blue: 0.009, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var weekPrice2: UILabel = {
        let view = UILabel()
        view.text = "/week".localized
        view.font = UIFont(name: "Onest-Medium", size: 13)
        view.textColor = UIColor(red: 0.067, green: 0.488, blue: 0.009, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var img: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "ok.price")
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 24
        view.heightAnchor ~= 24
        return view
    }()
    
    private lazy var emptyCircle: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.widthAnchor ~= 24
        view.heightAnchor ~= 24
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.05764976889, green: 0.4858098626, blue: 0.008107689209, alpha: 1)
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    override func setupContent() {
        let color1 = #colorLiteral(red: 0.9951933026, green: 1, blue: 0.9957693219, alpha: 1)
        let color2 = #colorLiteral(red: 0.8909534216, green: 0.9711504579, blue: 0.9007031322, alpha: 1)
        backgroundGradient = .init(
            colors: [color1, color2, color2, color2, color2]
        )
        layer.cornerRadius = 16
        widthAnchor ~= 67
        addSubview(daysTitle)
        addSubview(price)
        addSubview(vSeparator)
        addSubview(weekPrice1)
        addSubview(weekPrice2)
        addSubview(img)
        addSubview(emptyCircle)
    }
    
    override func setupLayout() {
        daysTitle.topAnchor ~= topAnchor + 10
        daysTitle.leftAnchor ~= leftAnchor + 12
        
        price.leftAnchor ~= leftAnchor + 12
        price.bottomAnchor ~= bottomAnchor - 10
        
        vSeparator.centerXAnchor ~= centerXAnchor
        vSeparator.centerYAnchor ~= centerYAnchor
        
        weekPrice1.leftAnchor ~= vSeparator.rightAnchor + 12
        weekPrice1.centerYAnchor ~= centerYAnchor
        
        weekPrice2.leftAnchor ~= weekPrice1.rightAnchor + 2
        weekPrice2.centerYAnchor ~= centerYAnchor
        
        img.rightAnchor ~= rightAnchor - 12
        img.centerYAnchor ~= centerYAnchor
        
        emptyCircle.rightAnchor ~= rightAnchor - 12
        emptyCircle.centerYAnchor ~= centerYAnchor
    }
}

// -------------------------
// MARK: " 3 " COMMENTS CELL
// -------------------------

final class CommentsPayWallCell: UICollectionViewCell {
    var viewModel: CommentsModelPayWall? {
        didSet {
            guard let viewModel else { return }
            content.viewModel = viewModel
        }
    }
    private lazy var content: CommentsPayWallContent = {
        let v = CommentsPayWallContent()
        contentView.addSubview(v)
        v.pinToSuperview()
        return v
    }()
}

final class CommentsPayWallContent: View {
    
    var viewModel: CommentsModelPayWall? {
        didSet {
            guard let viewModel else { return }
        }
    }
    
    private lazy var joinImg: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "join16")
        view.contentMode = .scaleAspectFill
        view.widthAnchor ~= 219
        view.heightAnchor ~= 82
        return view
    }()
    
    private lazy var davidImg: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "david")
        view.contentMode = .scaleAspectFill
        view.heightAnchor ~= 314
        return view
    }()
    
    private lazy var title: UILabel = {
        let view = UILabel()
        view.text = "what’s_covered_in_your_plan".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 16)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    // 1
    private lazy var img1: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "on.img1")
        view.contentMode = .scaleAspectFill
        view.widthAnchor ~= 50
        view.heightAnchor ~= 50
        return view
    }()
    
    private lazy var title1: UILabel = {
        let view = UILabel()
        view.text = "unlock_expert_tips".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 14)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var text1: UILabel = {
        let view = UILabel()
        view.text = "identify_any_plant".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Regular", size: 14)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.textAlignment = .justified
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    // 2
    private lazy var img2: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "on.img2")
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 50
        view.heightAnchor ~= 50
        return view
    }()
    
    private lazy var title2: UILabel = {
        let view = UILabel()
        view.text = "track_growth".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 14)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var text2: UILabel = {
        let view = UILabel()
        view.text = "log_milestones".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Regular", size: 14)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.textAlignment = .justified
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    // 3
    private lazy var img3: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "on.img3")
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 50
        view.heightAnchor ~= 50
        return view
    }()
    
    private lazy var title3: UILabel = {
        let view = UILabel()
        view.text = "ad_free_experience".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 14)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var text3: UILabel = {
        let view = UILabel()
        view.text = "enjoy_clean_interface".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Regular", size: 14)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.textAlignment = .justified
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    // 4
    private lazy var img4: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "on.img4")
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 50
        view.heightAnchor ~= 50
        return view
    }()
    
    private lazy var title4: UILabel = {
        let view = UILabel()
        view.text = "largest_database".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 14)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var text4: UILabel = {
        let view = UILabel()
        view.text = "access_detailed_info".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Regular", size: 14)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.textAlignment = .justified
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    override func setupContent() {
        backgroundColor = .clear
        addSubview(joinImg)
        addSubview(davidImg)
        
        addSubview(title)
        addSubview(img1)
        addSubview(title1)
        addSubview(text1)
        addSubview(img2)
        addSubview(title2)
        addSubview(text2)
        addSubview(img3)
        addSubview(title3)
        addSubview(text3)
        addSubview(img4)
        addSubview(title4)
        addSubview(text4)
    }
    override func setupLayout() {
        joinImg.centerXAnchor ~= centerXAnchor
        joinImg.topAnchor ~= topAnchor + 5
        
        davidImg.topAnchor ~= joinImg.bottomAnchor + 50
        davidImg.leftAnchor ~= leftAnchor - 30
        davidImg.rightAnchor ~= rightAnchor
        
        title.topAnchor ~= davidImg.bottomAnchor - 60
        title.leftAnchor ~= leftAnchor + 8
        
        img1.topAnchor ~= title.bottomAnchor + 10
        img1.leftAnchor ~= leftAnchor + 8
        
        title1.centerYAnchor ~= img1.centerYAnchor
        title1.leftAnchor ~= img1.rightAnchor
        
        text1.topAnchor ~= title1.bottomAnchor + 2
        text1.leftAnchor ~= title1.leftAnchor
        text1.rightAnchor ~= rightAnchor - 8
        
        img2.topAnchor ~= text1.bottomAnchor + 10
        img2.leftAnchor ~= leftAnchor + 8
        
        title2.centerYAnchor ~= img2.centerYAnchor
        title2.leftAnchor ~= img2.rightAnchor
        
        text2.topAnchor ~= title2.bottomAnchor + 2
        text2.leftAnchor ~= title2.leftAnchor
        text2.rightAnchor ~= rightAnchor - 8
        
        img3.topAnchor ~= text2.bottomAnchor + 10
        img3.leftAnchor ~= leftAnchor + 8
        
        title3.centerYAnchor ~= img3.centerYAnchor
        title3.leftAnchor ~= img3.rightAnchor
        
        text3.topAnchor ~= title3.bottomAnchor + 2
        text3.leftAnchor ~= title3.leftAnchor
        text3.rightAnchor ~= rightAnchor - 8
        
        img4.topAnchor ~= text3.bottomAnchor + 10
        img4.leftAnchor ~= leftAnchor + 8
        
        title4.centerYAnchor ~= img4.centerYAnchor
        title4.leftAnchor ~= img4.rightAnchor
        
        text4.topAnchor ~= title4.bottomAnchor + 2
        text4.leftAnchor ~= title4.leftAnchor
        text4.rightAnchor ~= rightAnchor - 8
    }
}
