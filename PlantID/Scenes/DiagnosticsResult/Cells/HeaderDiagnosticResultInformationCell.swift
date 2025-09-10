//
//  HeaderDiagnosticResultInformationCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 26.06.25.
//

import UIKit

final class HeaderDiagnosticResultInformationCell: UICollectionViewCell {
    var viewModel: HeaderDiagnosticResultInformationContentView.Model {
        get {
            cellContentView.viewModel ?? .init()
        }
        set {
            cellContentView.viewModel = newValue
        }
    }
    
    private lazy var cellContentView: HeaderDiagnosticResultInformationContentView = {
        let view = HeaderDiagnosticResultInformationContentView()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

// MARK: - CONTENT VIEW

final class HeaderDiagnosticResultInformationContentView: View {

    struct Model: Hashable {
        var namePlant: String?
        var currentDiagnoses: String?
        var currentDiagnosesIconName: String? = nil
        var currentDiagnosesTitle: String? = nil
        var plantType: String?
        var plantTypeIconName: String? = nil
        var currentCondition: String?
        var currentConditionIconName: String? = nil
    }

    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            // Title + plant name
            plantNameLbl.attributedText = attributedPlantName(viewModel.namePlant)

            // Current diagnosis card
            currentDiagnosesValue.text = viewModel.currentDiagnoses
            if let icon = viewModel.currentDiagnosesIconName { currentDiagnosesIcon.image = UIImage(named: icon) }

            // Chips
            plantTypeCell.haracteristicValue = viewModel.plantType
            if let icon = viewModel.plantTypeIconName { plantTypeCell.icon = icon }
            currentConditionCell.haracteristicValue = viewModel.currentCondition
            if let icon = viewModel.currentConditionIconName { currentConditionCell.icon = icon }
        }
    }

    private lazy var title: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 20)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        // "Diagnostics Result" with green highlight on the second word
        let base = "diagnostics_result".localized
        view.attributedText = highlightedResultTitle(base)
        view.contentMode = .center
        return view
    }()

    private lazy var plantNameLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Medium", size: 16)
        view.textColor = UIColor(red: 0.194, green: 0.274, blue: 0.211, alpha: 1)
        view.numberOfLines = 0
        return view
    }()

    private lazy var currentDiagnosesView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(hex: "#E2F6E9")
        v.layer.cornerRadius = 18
        return v
    }()

    private lazy var currentDiagnosesIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor ~= 18
        iv.heightAnchor ~= 18
        return iv
    }()

    private lazy var currentDiagnosesTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Onest-Regular", size: 12)
        lbl.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        lbl.text = nil
        return lbl
    }()

    private lazy var currentDiagnosesValue: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Medium", size: 16)
        view.textColor = UIColor(red: 0.067, green: 0.486, blue: 0.008, alpha: 1)
        view.numberOfLines = 0
        return view
    }()

    private lazy var plantTypeCell: HarItem = {
        let view = HarItem()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 52
        view.widthAnchor ~= 166
        view.haracteristicName = "plant_type".localized
        return view
    }()

    private lazy var currentConditionCell: HarItem = {
        let view = HarItem()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 52
        view.widthAnchor ~= 166
        view.haracteristicName = "current_condition".localized
        return view
    }()

    private lazy var vSeparator1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#8FDB85")
        view.widthAnchor ~= 1
        view.heightAnchor ~= 45
        return view
    }()

    private lazy var stackH: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 10
        view.alignment = .center
        view.distribution = .fill
        return view
    }()

    private lazy var hSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#8FDB85")
        view.widthAnchor ~= 343
        view.heightAnchor ~= 1
        return view
    }()

    override func setupContent() {
        backgroundColor = .clear

        addSubview(title)
        addSubview(plantNameLbl)
        addSubview(currentDiagnosesView)
        currentDiagnosesView.addSubview(currentDiagnosesIcon)
        currentDiagnosesView.addSubview(currentDiagnosesTitle)
        currentDiagnosesView.addSubview(currentDiagnosesValue)
        addSubview(stackH)
        stackH.addArrangedSubview(plantTypeCell)
        stackH.addArrangedSubview(vSeparator1)
        stackH.addArrangedSubview(currentConditionCell)
        addSubview(hSeparator)
    }

    override func setupLayout() {
        title.topAnchor ~= topAnchor
        title.centerXAnchor ~= centerXAnchor

        plantNameLbl.topAnchor ~= title.bottomAnchor + 15
        plantNameLbl.leftAnchor ~= leftAnchor
        plantNameLbl.rightAnchor ~= rightAnchor

        currentDiagnosesView.topAnchor ~= plantNameLbl.bottomAnchor + 10
        currentDiagnosesView.leftAnchor ~= leftAnchor
        currentDiagnosesView.rightAnchor ~= rightAnchor

        currentDiagnosesIcon.leftAnchor ~= currentDiagnosesView.leftAnchor + 16
        currentDiagnosesIcon.centerYAnchor ~= currentDiagnosesView.centerYAnchor

        currentDiagnosesTitle.topAnchor ~= currentDiagnosesView.topAnchor + 8
        currentDiagnosesTitle.leftAnchor ~= currentDiagnosesIcon.rightAnchor + 10

        currentDiagnosesValue.topAnchor ~= currentDiagnosesTitle.bottomAnchor + 4
        currentDiagnosesValue.bottomAnchor ~= currentDiagnosesView.bottomAnchor - 8
        currentDiagnosesValue.leftAnchor ~= currentDiagnosesIcon.rightAnchor + 10
        currentDiagnosesValue.rightAnchor ~= currentDiagnosesView.rightAnchor - 16

        stackH.topAnchor ~= currentDiagnosesView.bottomAnchor + 25
        stackH.leftAnchor ~= leftAnchor
        stackH.rightAnchor ~= rightAnchor

        hSeparator.topAnchor ~= stackH.bottomAnchor + 25
        hSeparator.centerXAnchor ~= centerXAnchor
        hSeparator.bottomAnchor ~= bottomAnchor
    }

    private func highlightedResultTitle(_ text: String) -> NSAttributedString {
        // Splits by space and colors the last word
        let parts = text.split(separator: " ")
        let attr = NSMutableAttributedString()
        for (idx, part) in parts.enumerated() {
            let s = String(part).uppercased()
            let color: UIColor = (idx == parts.count - 1) ? UIColor(hex: "#117C02") ?? .systemGreen : UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
            let piece = NSAttributedString(string: (idx > 0 ? " " : "") + s, attributes: [
                .font: UIFont(name: "Onest-SemiBold", size: 20) as Any,
                .foregroundColor: color
            ])
            attr.append(piece)
        }
        return attr
    }

    private func attributedPlantName(_ name: String?) -> NSAttributedString {
        let base = ("Plant Name: " + (name ?? "")).trimmingCharacters(in: .whitespaces)
        let attr = NSMutableAttributedString(string: base, attributes: [
            .font: UIFont(name: "Onest-Medium", size: 16) as Any,
            .foregroundColor: UIColor(red: 0.194, green: 0.274, blue: 0.211, alpha: 1)
        ])
        if let name, let range = base.range(of: name) {
            let ns = NSRange(range, in: base)
            attr.addAttributes([
                .foregroundColor: UIColor(hex: "#117C02") ?? UIColor.systemGreen
            ], range: ns)
        }
        return attr
    }
}

// ITEM
final class HarItem: View {
    
    var icon: String? {
        didSet{
            guard let icon else { return }
            image.image = UIImage(named: icon)
        }
    }
    
    var haracteristicName: String? {
        didSet {
            harTitle.text = haracteristicName
        }
    }
    
    var haracteristicValue: String? {
        didSet {
            harValue.text = haracteristicValue
        }
    }
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 20
        view.heightAnchor ~= 20
        return view
    }()
    
    private lazy var harTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Regular", size: 12)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.contentMode = .center
        return view
    }()

    private lazy var harValue: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Medium", size: 16)
        view.textColor = UIColor(red: 0.067, green: 0.486, blue: 0.008, alpha: 1)
        view.contentMode = .center
        return view
    }()
    
    private lazy var stackH: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 3
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
    override func setupContent() {
        backgroundColor = UIColor(hex: "#E2F6E9")
        layer.cornerRadius = 18
        addSubview(stackH)
        stackH.addArrangedSubview(image)
        stackH.addArrangedSubview(harTitle)
        addSubview(harValue)
    }
    
    override func setupLayout() {
//        heightAnchor ~= 45
//        widthAnchor ~= 167
        
        stackH.centerXAnchor ~= centerXAnchor
        stackH.centerYAnchor ~= centerYAnchor - 15

        harValue.centerXAnchor ~= centerXAnchor
        harValue.centerYAnchor ~= centerYAnchor + 15
    }
}
