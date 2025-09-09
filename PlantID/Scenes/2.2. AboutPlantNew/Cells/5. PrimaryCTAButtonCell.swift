//
//  5. PrimaryCTAButtonCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 9.09.25.
//


import UIKit

// MARK: - Cell

final class PrimaryCTAButtonCell: UICollectionViewCell {

    var viewModel: PrimaryCTAButtonContent.Model? {
        didSet { content.viewModel = viewModel }
    }

    var actionHandler: () -> Void {
        get { content.actionHandler }
        set { content.actionHandler = newValue }
    }

    private lazy var content: PrimaryCTAButtonContent = {
        let v = PrimaryCTAButtonContent()
        contentView.addSubview(v)
        v.pinToSuperview()
        return v
    }()
}

// MARK: - Content

final class PrimaryCTAButtonContent: View {

    struct Model: Hashable {
        let title: String
        let backgroundImageName: String
    }

    enum Action { case tap }
    var actionHandler: () -> Void = {}

    var viewModel: Model? { didSet { applyModel() } }

    // MARK: UI

    private lazy var button: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 16)
        b.setTitleColor(.white, for: .normal)
        b.contentHorizontalAlignment = .center
        b.addAction(UIAction { [weak self] _ in self?.actionHandler() }, for: .touchUpInside)
        return b
    }()

    // MARK: Lifecycle

    override func setupContent() {
        addSubview(button)
    }

    override func setupLayout() {
        button.leftAnchor ~= leftAnchor + 16
        button.rightAnchor ~= rightAnchor - 16
        button.topAnchor ~= topAnchor
        button.bottomAnchor ~= bottomAnchor
        button.heightAnchor ~= 60
    }

    private func applyModel() {
        guard let vm = viewModel else { return }
        button.setTitle(vm.title, for: .normal)
        if let bg = UIImage(named: vm.backgroundImageName) {
            button.setBackgroundImage(bg, for: .normal)
        }
    }
}
