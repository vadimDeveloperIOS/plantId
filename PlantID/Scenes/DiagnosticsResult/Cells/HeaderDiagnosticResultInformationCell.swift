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
        var currentDiagnoses: String?
        var plantType: String?
        var currentCondition: String?
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            currentDiagnosesValue.text = viewModel.currentDiagnoses
//            plantTypeCell.haracteristicValue = viewModel.plantType
//            currentConditionCell.haracteristicValue = viewModel.currentCondition
        }
    }
    
    private lazy var title: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 20)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.text = "diagnostics_result".localized.uppercased()
        view.contentMode = .center
        return view
    }()
    
    private lazy var currentImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "current.diagnoses")
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 128
        view.heightAnchor ~= 20
        return view
    }()
    
    private lazy var currentDiagnosesValue: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Medium", size: 16)
        view.textColor = UIColor(red: 0.067, green: 0.486, blue: 0.008, alpha: 1)
        view.contentMode = .center
        view.numberOfLines = 0
        return view
    }()

//    private lazy var plantTypeCell: HarItem = {
//        let view = HarItem()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.heightAnchor ~= 52
//        view.widthAnchor ~= 166
//        view.icon = "har5"
//        view.haracteristicName = "plant_type".localized
//        return view
//    }()
//    
//    private lazy var currentConditionCell: HarItem = {
//        let view = HarItem()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.heightAnchor ~= 52
//        view.widthAnchor ~= 166
//        view.icon = "har6"
//        view.haracteristicName = "current_condition".localized
//        return view
//    }()
    
//    private lazy var stackH: UIStackView = {
//        let view = UIStackView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.axis = .horizontal
//        view.spacing = 10
//        view.alignment = .center
//        view.distribution = .fill
//        return view
//    }()
    
    private lazy var stackV: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 10
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
//    private lazy var vSeparator1: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor(hex: "#8FDB85")
//        view.widthAnchor ~= 1
//        view.heightAnchor ~= 45
//        return view
//    }()
//    
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
        addSubview(stackV)
        stackV.addArrangedSubview(currentImage)
        stackV.addArrangedSubview(currentDiagnosesValue)
        stackV.addArrangedSubview(hSeparator)
//        stackV.addArrangedSubview(stackH)
//        stackH.addArrangedSubview(plantTypeCell)
//        stackH.addArrangedSubview(vSeparator1)
//        stackH.addArrangedSubview(currentConditionCell)
    }
    
    override func setupLayout() {
        
        title.topAnchor ~= topAnchor
        title.centerXAnchor ~= centerXAnchor
        
        stackV.topAnchor ~= title.bottomAnchor + 20
        stackV.leftAnchor ~= leftAnchor
        stackV.rightAnchor ~= rightAnchor
        stackV.bottomAnchor ~= bottomAnchor
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
        backgroundColor = .clear
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
