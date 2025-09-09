//
//  1. AboutPlantHeaderCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 9.09.25.
//

import UIKit


// ----------------------------------------------
// MARK: - CELL
// ----------------------------------------------

final class AboutPlantHeaderCell: UICollectionViewCell {

    var viewModel: AboutPlantHeaderCellContent.Model? {
        didSet { content.viewModel = viewModel }
    }

    var actionHandler: (AboutPlantHeaderCellContent.Action) -> Void {
        get { content.actionHandler }
        set { content.actionHandler = newValue }
    }

    private lazy var content: AboutPlantHeaderCellContent = {
        let v = AboutPlantHeaderCellContent()
        contentView.addSubview(v)
        v.pinToSuperview()
        return v
    }()
}

// ----------------------------------------------
// MARK: - CONTENT
// ----------------------------------------------

final class AboutPlantHeaderCellContent: View {

    // что приходит снаружи
    struct Model: Hashable {
        let photo: UIImage
        let title: String
        let leftIconName: String       // напр. "navbar_back"
        let rightTopIconName: String   // напр. "more"
        let rightBottomIconName: String// напр. "settings"
    }

    enum Action {
        case tapLeft
        case tapRightTop
        case tapRightBottom
    }
    var actionHandler: (Action) -> Void = { _ in }

    var viewModel: Model? {
        didSet {
            guard let vm = viewModel else { return }
            imageView.image = vm.photo
            titleLabel.text = vm.title
            leftButton.setImage(UIImage(named: vm.leftIconName), for: .normal)
            rightTopButton.setImage(UIImage(named: vm.rightTopIconName), for: .normal)
            rightBottomButton.setImage(UIImage(named: vm.rightBottomIconName), for: .normal)
        }
    }

    // MARK: UI

    private lazy var container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 28
        v.clipsToBounds = true
        return v
    }()

    private lazy var imageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        return v
    }()

    private lazy var dimGradient: CAGradientLayer = {
        let g = CAGradientLayer()
        g.colors = [
            UIColor.black.withAlphaComponent(0.55).cgColor,
            UIColor.clear.cgColor
        ]
        g.startPoint = CGPoint(x: 0.5, y: 0.0)
        g.endPoint   = CGPoint(x: 0.5, y: 0.6)
        return g
    }()

    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "Poppins-Medium", size: 22)
        v.textColor = .white
        v.textAlignment = .center
        v.numberOfLines = 1
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.25
        v.layer.shadowRadius = 2
        v.layer.shadowOffset = .init(width: 0, height: 1)
        return v
    }()

    private func circleButton() -> UIButton {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.tintColor = .white
        b.backgroundColor = UIColor.white.withAlphaComponent(0.18)
        b.layer.cornerRadius = 20
        b.widthAnchor ~= 40
        b.heightAnchor ~= 40
        b.imageView?.contentMode = .scaleAspectFit
        b.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        return b
    }

    private lazy var leftButton: UIButton = {
        let b = circleButton()
        b.addAction(UIAction { [weak self] _ in self?.actionHandler(.tapLeft) }, for: .touchUpInside)
        return b
    }()

    private lazy var rightTopButton: UIButton = {
        let b = circleButton()
        b.addAction(UIAction { [weak self] _ in self?.actionHandler(.tapRightTop) }, for: .touchUpInside)
        return b
    }()

    private lazy var rightBottomButton: UIButton = {
        let b = circleButton()
        b.addAction(UIAction { [weak self] _ in self?.actionHandler(.tapRightBottom) }, for: .touchUpInside)
        return b
    }()

    // MARK: Lifecycle

    override func setupContent() {
        addSubview(container)
        container.addSubview(imageView)
        container.layer.addSublayer(dimGradient)
        container.addSubview(titleLabel)
        container.addSubview(leftButton)
        container.addSubview(rightTopButton)
        container.addSubview(rightBottomButton)
    }

    override func setupLayout() {
        // контейнер заполняет ячейку, высота подскроллится по estimation секции
        container.pinToSuperview()
        imageView.pinToSuperview()

        // высота «шапки» — как на макете (можно поменять при интеграции в layout)
        container.heightAnchor >= 360

        // заголовок по центру сверху
        titleLabel.topAnchor ~= container.topAnchor + 60
        titleLabel.centerXAnchor ~= container.centerXAnchor

        // кнопки
        leftButton.topAnchor ~= container.topAnchor + 12
        leftButton.leftAnchor ~= container.leftAnchor + 12

        rightTopButton.topAnchor ~= container.topAnchor + 12
        rightTopButton.rightAnchor ~= container.rightAnchor - 12

        rightBottomButton.topAnchor ~= rightTopButton.bottomAnchor + 12
        rightBottomButton.rightAnchor ~= container.rightAnchor - 12
    }

    // чтобы градиент тянулся за фреймом (см. базовый View) :contentReference[oaicite:1]{index=1}
    override func layoutSubviews() {
        super.layoutSubviews()
        dimGradient.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 160)
    }
}
