//
//  ConditionViewCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 26.06.25.
//

import UIKit

final class ConditionViewCell: UICollectionViewCell {
    
    var viewModel: ConditionContentView.Model {
        get {
            cellContentView.viewModel ?? .init()
        }
        set {
            cellContentView.viewModel = newValue
        }
    }
    
    private lazy var cellContentView: ConditionContentView = {
        let view = ConditionContentView()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

// MARK: - CONTENT VIEW

final class ConditionContentView: View {
    
    struct Model: Hashable {
        var textValue: String?
        var conditionValue: Float?
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
//            textValueLbl.text = viewModel.textValue
            progress.progress = CGFloat(viewModel.conditionValue ?? 0.1)
            updateValueLabel()
        }
    }
    
    private lazy var title: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Medium", size: 18)
        view.textColor = UIColor(red: 0.194, green: 0.274, blue: 0.211, alpha: 1)
        view.text = "condition".localized
        view.contentMode = .left
        return view
    }()
    
    private lazy var conditionValueLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Medium", size: 20)
        view.textColor = UIColor(red: 0.945, green: 0.765, blue: 0.046, alpha: 1)
        view.contentMode = .left
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var progress: SegmentedProgressBar = {
        let v = SegmentedProgressBar()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.segments = 20
        v.heightAnchor ~= 12
        return v
    }()
    
    override func setupContent() {
        backgroundColor = .clear
        
        addSubview(title)
//        addSubview(textValueLbl)
        addSubview(conditionValueLbl)
        addSubview(progress)
    }
    
    override func setupLayout() {
        
        title.topAnchor ~= topAnchor
        title.leftAnchor ~= leftAnchor
        
//        textValueLbl.topAnchor ~= title.bottomAnchor + 20
//        textValueLbl.leftAnchor ~= leftAnchor

        conditionValueLbl.centerYAnchor ~= title.centerYAnchor
        conditionValueLbl.rightAnchor ~= rightAnchor

        progress.topAnchor ~= title.bottomAnchor + 20
        progress.leftAnchor ~= leftAnchor
        progress.rightAnchor ~= rightAnchor
    }
    
    private func updateValueLabel() {
        guard let v = viewModel?.conditionValue else {
            conditionValueLbl.text = "0%"
            conditionValueLbl.textColor = #colorLiteral(red: 0.07304378599, green: 0.4857453108, blue: 0.007760594599, alpha: 1)
            return
        }
        // переведём в проценты
        let raw = v * 100
        let percent = raw.isFinite ? Int(raw) : 0
        conditionValueLbl.text = "\(percent)%"

        // Цвета и сегментированная полоса как в PreliminaryDiagnosesContentView
        switch percent {
        case 0...39:
            conditionValueLbl.textColor = UIColor(hex: "#117C02")
            progress.filledColor = UIColor(hex: "#117C02") ?? .systemGreen
        case 40...79:
            conditionValueLbl.textColor = UIColor(hex: "#F1C30C")
            progress.filledColor = UIColor(hex: "#F1C30C") ?? .systemYellow
        default:
            conditionValueLbl.textColor = UIColor(hex: "#EB0800")
            progress.filledColor = UIColor(hex: "#EB0800") ?? .systemRed
        }
    }
}

