//
//  3. PlantInfoCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 9.09.25.
//


import UIKit

// MARK: - Cell

final class PlantInfoCell: UICollectionViewCell {

    var viewModel: PlantInfoContent.Model? {
        didSet { content.viewModel = viewModel }
    }

    private lazy var content: PlantInfoContent = {
        let v = PlantInfoContent()
        contentView.addSubview(v)
        v.pinToSuperview(left: 16, top: 0, right: 16, bottom: 0)
        return v
    }()
}

// MARK: - Content

final class PlantInfoContent: View {

    // MARK: Design tokens
    private enum Design {
        static let inset: CGFloat = 16
        static let spacing: CGFloat = 12
        static let small: CGFloat = 8

        enum Color {
            static let title = UIColor.label
            static let text  = UIColor.secondaryLabel
        }
        enum Font {
            static let title = UIFont(name: "Poppins-SemiBold", size: 18)!
            static let body  = UIFont(name: "Poppins-Regular",  size: 14)!
        }
        static let lineHeight: CGFloat = 20
        static let paragraphSpacing: CGFloat = 8
    }

    // MARK: Model

    struct Model: Hashable {
        let title: String
        let paragraphs: [String]
    }

    var viewModel: Model? { didSet { applyModel() } }

    // MARK: UI

    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.font = Design.Font.title
        v.textColor = Design.Color.title
        v.numberOfLines = 1
        return v
    }()

    private lazy var paragraphsStack: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.alignment = .fill
        v.spacing = Design.small
        return v
    }()

    // MARK: Lifecycle

    override func setupContent() {
        addSubview(titleLabel)
        addSubview(paragraphsStack)
    }

    override func setupLayout() {
        titleLabel.topAnchor ~= topAnchor + Design.inset
        titleLabel.leftAnchor ~= leftAnchor + Design.inset
        titleLabel.rightAnchor ~= rightAnchor - Design.inset

        paragraphsStack.topAnchor ~= titleLabel.bottomAnchor + Design.spacing
        paragraphsStack.leftAnchor ~= leftAnchor + Design.inset
        paragraphsStack.rightAnchor ~= rightAnchor - Design.inset
        paragraphsStack.bottomAnchor ~= bottomAnchor - Design.inset
    }

    // MARK: Bind

    private func applyModel() {
        guard let vm = viewModel else { return }
        titleLabel.text = vm.title
        setParagraphs(vm.paragraphs)
    }

    private func setParagraphs(_ items: [String]) {
        // очистка
        paragraphsStack.arrangedSubviews.forEach {
            paragraphsStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        // наполнение
        for text in items {
            let lbl = UILabel()
            lbl.numberOfLines = 0
            lbl.textColor = Design.Color.text
            lbl.attributedText = Self.makeBody(text)
            paragraphsStack.addArrangedSubview(lbl)
        }
    }

    private static func makeBody(_ text: String) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = Design.lineHeight
        style.maximumLineHeight = Design.lineHeight
        style.paragraphSpacing = Design.paragraphSpacing
        return NSAttributedString(
            string: text,
            attributes: [
                .font: Design.Font.body,
                .foregroundColor: Design.Color.text,
                .paragraphStyle: style
            ]
        )
    }
}
