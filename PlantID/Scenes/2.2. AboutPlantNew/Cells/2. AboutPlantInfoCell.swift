//
//  2. AboutPlantInfoCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 9.09.25.
//


import UIKit

// MARK: - Cell


final class AboutPlantInfoCell: UICollectionViewCell {

    var viewModel: AboutPlantInfoContent.Model? {
        didSet { content.viewModel = viewModel }
    }

    var actionHandler: (AboutPlantInfoContent.Action) -> Void {
        get { content.actionHandler }
        set { content.actionHandler = newValue }
    }

    private lazy var content: AboutPlantInfoContent = {
        let v = AboutPlantInfoContent()
        contentView.addSubview(v)
        v.pinToSuperview(left: 16, top: 0, right: 16, bottom: 0)
        return v
    }()
}

// MARK: - Content

final class AboutPlantInfoContent: View {

    // MARK: Design tokens (локально; можно вынести в общий Palette/Spacing)
    enum Design {
        static let inset: CGFloat = 16
        static let inter: CGFloat = 12
        static let small: CGFloat = 8
        static let titleSpacing: CGFloat = 6
        static let cardRadius: CGFloat = 16
        static let cardHeight: CGFloat = 92

        enum Color {
            static let accent = UIColor(red: 0.22, green: 0.60, blue: 0.32, alpha: 1.0)     // зелёный из макета
            static let cardBg = UIColor(red: 0.91, green: 0.96, blue: 0.89, alpha: 1.0)     // светло-зелёный карточек
            static let primary = UIColor.label
            static let secondary = UIColor.secondaryLabel
        }
        enum Font {
            static let title = UIFont(name: "Poppins-SemiBold", size: 22)!
            static let row = UIFont(name: "Poppins-Medium", size: 14)!
            static let cardTitle = UIFont(name: "Poppins-Medium", size: 13)!
            static let cardValue = UIFont(name: "Poppins-SemiBold", size: 16)!
        }
    }

    // MARK: Model / Action

    struct Model: Hashable {
        // Заголовок «About Plant» (обе части приходят из VM)
        let titlePrimary: String
        let titleAccent: String

        // «Plant Name: …»
        let plantNamePrefix: String
        let plantNameValue: String

        // 4 карточки 2×2
        let params: [ParamModel]   // ожидаем ровно 4

        struct ParamModel: Hashable {
            let iconAsset: String   // имя ассета
            let title: String
            let value: String
        }
    }

    enum Action {
        case tapPlantName
        case tapParam(index: Int)
    }
    var actionHandler: (Action) -> Void = { _ in }

    var viewModel: Model? {
        didSet { applyModel() }
    }

    // MARK: UI

    private lazy var titlePrimaryLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = Design.Font.title
        v.textColor = Design.Color.primary
        v.textAlignment = .left
        return v
    }()

    private lazy var titleAccentLabel: UILabel = {
        let v = UILabel()
        v.font = Design.Font.title
        v.textColor = Design.Color.accent
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textAlignment = .left
        return v
    }()

//    private lazy var titleStack: UIStackView = {
//        let v = UIStackView(arrangedSubviews: [titlePrimaryLabel, titleAccentLabel])
//        v.axis = .horizontal
//        v.alignment = .firstBaseline
//        v.spacing = Design.titleSpacing
//        v.distribution = .equalSpacing
//        return v
//    }()

    private lazy var plantNamePrefixLabel: UILabel = {
        let v = UILabel()
        v.font = Design.Font.row
        v.textColor = Design.Color.secondary
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textAlignment = .left
        return v
    }()

    private lazy var plantNameButton: UIButton = {
        let v = UIButton(type: .system)
        v.titleLabel?.font = Design.Font.row
        v.setTitleColor(Design.Color.accent, for: .normal)
        v.contentHorizontalAlignment = .leading
        v.addAction(UIAction { [weak self] _ in self?.actionHandler(.tapPlantName) }, for: .touchUpInside)
        return v
    }()

//    private lazy var plantNameRow: UIStackView = {
//        let v = UIStackView(arrangedSubviews: [plantNamePrefixLabel, plantNameButton])
//        v.axis = .horizontal
//        v.alignment = .fill
//        v.spacing = Design.titleSpacing
//        v.distribution = .fill
//        return v
//    }()

    private let cardViews = (0..<4).map { _ in ParamCardView() }

    private lazy var row1: UIStackView = {
        let v = UIStackView(arrangedSubviews: [cardViews[0], cardViews[1]])
        v.axis = .horizontal
        v.distribution = .fillEqually
        v.spacing = Design.inter
        return v
    }()

    private lazy var row2: UIStackView = {
        let v = UIStackView(arrangedSubviews: [cardViews[2], cardViews[3]])
        v.axis = .horizontal
        v.distribution = .fillEqually
        v.spacing = Design.inter
        return v
    }()

    private lazy var gridStack: UIStackView = {
        let v = UIStackView(arrangedSubviews: [row1, row2])
        v.axis = .vertical
        v.spacing = Design.inter
        return v
    }()

    // MARK: Lifecycle

    override func setupContent() {
        addSubview(titlePrimaryLabel)
        addSubview(titleAccentLabel)
        
        addSubview(plantNamePrefixLabel)
        addSubview(plantNameButton)
        
        addSubview(gridStack)

        for (i, card) in cardViews.enumerated() {
        }
    }

    override func setupLayout() {
        titlePrimaryLabel.topAnchor ~= topAnchor + 12
        titlePrimaryLabel.leftAnchor ~= leftAnchor + 16
        
        titleAccentLabel.topAnchor ~= titlePrimaryLabel.topAnchor
        titleAccentLabel.leftAnchor ~= titlePrimaryLabel.rightAnchor + 5
        
        plantNamePrefixLabel.topAnchor ~= titlePrimaryLabel.bottomAnchor + 10
        plantNamePrefixLabel.leftAnchor ~= titlePrimaryLabel.leftAnchor
        
        plantNameButton.centerYAnchor ~= plantNamePrefixLabel.centerYAnchor
        plantNameButton.leftAnchor ~= plantNamePrefixLabel.rightAnchor + 7

        gridStack.topAnchor ~= plantNamePrefixLabel.bottomAnchor + Design.inset
        gridStack.leftAnchor ~= leftAnchor + Design.inset
        gridStack.rightAnchor ~= rightAnchor - Design.inset
        gridStack.bottomAnchor ~= bottomAnchor - Design.inset

        cardViews.forEach { $0.heightAnchor ~= Design.cardHeight }
    }

    private func applyModel() {
        guard let vm = viewModel else {
            print("[About plant cell] - view model равен nil")
            return
        }
                
        guard vm.params.count == 4 else {
            print("[About plant cell] - vm.params.count не равен 4")
            return
        }
        
        print("!!!!! titlePrimary - \(vm.titlePrimary)")
        print("!!!!! titleAccent - \(vm.titleAccent)")
        print("!!!!! plantNamePrefix - \(vm.plantNamePrefix)")
        print("!!!!! plantNameValue - \(vm.plantNameValue)")

        titlePrimaryLabel.text = vm.titlePrimary
        titleAccentLabel.text = vm.titleAccent

        plantNamePrefixLabel.text = vm.plantNamePrefix
        plantNameButton.setTitle(vm.plantNameValue, for: .normal)

        for (card, m) in zip(cardViews, vm.params) {
            card.configure(
                icon: UIImage(named: m.iconAsset),
                title: m.title,
                value: m.value,
                tint: Design.Color.accent,
                bg: Design.Color.cardBg
            )
        }
    }
}

// MARK: - Param Card

private final class ParamCardView: View {

    private lazy var container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = AboutPlantInfoContent.Design.cardRadius
        v.backgroundColor = AboutPlantInfoContent.Design.Color.cardBg
        return v
    }()

    private lazy var iconView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFit
        v.widthAnchor ~= 20
        v.heightAnchor ~= 20
        return v
    }()

    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = AboutPlantInfoContent.Design.Font.cardTitle
        v.textColor = .black
        v.textAlignment = .center
        return v
    }()

    private lazy var topRow: UIStackView = {
        let v = UIStackView(arrangedSubviews: [iconView, titleLabel])
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .horizontal
        v.alignment = .center
        v.spacing = AboutPlantInfoContent.Design.small
        return v
    }()

    private lazy var valueLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = AboutPlantInfoContent.Design.Font.cardValue
        v.textColor = .black
        v.textAlignment = .center
        v.numberOfLines = 2
        return v
    }()

    private lazy var hitButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .clear
        return b
    }()

    override func setupContent() {
        addSubview(container)
        container.addSubview(topRow)
        container.addSubview(valueLabel)
    }

    override func setupLayout() {
        container.pinToSuperview()

        topRow.centerXAnchor ~= container.centerXAnchor
        topRow.centerYAnchor ~= container.centerYAnchor - 10

        valueLabel.topAnchor ~= topRow.bottomAnchor + 5
        valueLabel.centerXAnchor ~= container.centerXAnchor
    }

    func configure(icon: UIImage?, title: String, value: String, tint: UIColor, bg: UIColor) {
        container.backgroundColor = bg
        iconView.image = icon
        titleLabel.text = title
        valueLabel.text = value
    }
}
