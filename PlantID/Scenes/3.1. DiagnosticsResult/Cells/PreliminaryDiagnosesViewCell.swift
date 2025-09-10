//
//  PreliminaryDiagnosesViewCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 26.06.25.
//

import UIKit

// --------------------------------------------
// MARK: - Cell
// --------------------------------------------


final class PreliminaryDiagnosesViewCell: UICollectionViewCell {
    var viewModel: PreliminaryDiagnosesContentView.Model {
        get {
            cellContentView.viewModel ?? .init(diagnoses: [])
        }
        set {
            cellContentView.viewModel = newValue
        }
    }
    
    private lazy var cellContentView: PreliminaryDiagnosesContentView = {
        let view = PreliminaryDiagnosesContentView()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

// --------------------------------------------
// MARK: - CONTENT VIEW
// --------------------------------------------

/// Контент-вью для секции «Preliminary diagnoses:»
final class PreliminaryDiagnosesContentView: View {
    
    /// Модель всего списка
    struct Model: Hashable {
        var diagnoses: [DiagnosesCell.Model]
    }
    
    /// Как только модель пришла — пересобираем стек
    var viewModel: Model? {
        didSet {
            guard let vm = viewModel else { return }
            // 1. Очистить старые строки
            stackV.arrangedSubviews.forEach { $0.removeFromSuperview() }
            // 2. На каждый диагноз — новая ячейка
            for diag in vm.diagnoses {
                let cell = DiagnosesCell()
                cell.viewModel = diag
                stackV.addArrangedSubview(cell)
            }
        }
    }
    
    // MARK: - UI
    
    private lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-Medium", size: 18)
        lbl.textColor = UIColor(red: 0.194, green: 0.274, blue: 0.211, alpha: 1)
        lbl.text = "preliminary_diagnoses".localized
        return lbl
    }()
    
    private lazy var stackV: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        s.spacing = 14
        s.alignment = .fill
        s.distribution = .equalSpacing
        return s
    }()
    
    // MARK: - Init
    
    override func setupContent() {
        backgroundColor = .clear
        addSubview(titleLbl)
        addSubview(stackV)
    }
    
    override func setupLayout() {
        // Заголовок
        titleLbl.topAnchor    ~= topAnchor
        titleLbl.leftAnchor ~= leftAnchor
        
        // Стек с диагнозами
        stackV.topAnchor      ~= titleLbl.bottomAnchor + 20
        stackV.leftAnchor  ~= leftAnchor
        stackV.rightAnchor ~= rightAnchor
        stackV.bottomAnchor   ~= bottomAnchor - 10
    }
}

// --------------------------------------------
// MARK: - DIAGNOZ
// --------------------------------------------

/// Одна строка диагноза: иконка, название и процент в бейдже
final class DiagnosesCell: View {
    
    struct Model: Hashable {
        let name: String
        let probability: Float
        // Optional image name for info button/icon; user will supply asset
        var infoIconName: String? = nil
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            diagnoseLbl.text = viewModel.name
            diagnoseValue = viewModel.probability
        }
    }
    
    /// Процент (например 75) — автоматически ставится «%»
    var diagnoseValue: Float? {
        didSet {
            updateValueLabel()
        }
    }
    
    // MARK: UI
    
    private lazy var image: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "icon7878"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor  ~= 20
        iv.heightAnchor ~= 20
        return iv
    }()
    
    private lazy var diagnoseLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-Medium", size: 14)
        lbl.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.8)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var valueLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Poppins-SemiBold", size: 16)
        lbl.textAlignment = .right
        return lbl
    }()

    private lazy var infoIcon: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor ~= 16
        iv.heightAnchor ~= 16
        return iv
    }()

    private lazy var progress: SegmentedProgressBar = {
        let v = SegmentedProgressBar()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.segments = 20
        v.heightAnchor ~= 12
        return v
    }()
    
    // MARK: Init
    
    override func setupContent() {
        backgroundColor = #colorLiteral(red: 0.8830724359, green: 0.9430875778, blue: 0.8293510079, alpha: 1)
        layer.cornerRadius = 16
        addSubview(image)
        addSubview(diagnoseLbl)
        addSubview(infoIcon)
        addSubview(valueLbl)
        addSubview(progress)
    }
    
    override func setupLayout() {
        // Top row: icon, title, info icon
        image.topAnchor ~= topAnchor + 14
        image.leftAnchor ~= leftAnchor + 14

        diagnoseLbl.centerYAnchor ~= image.centerYAnchor
        diagnoseLbl.leftAnchor ~= image.rightAnchor + 10
        diagnoseLbl.rightAnchor <= infoIcon.leftAnchor - 8

        infoIcon.centerYAnchor ~= image.centerYAnchor
        infoIcon.rightAnchor ~= rightAnchor - 12

        // Percentage label
        valueLbl.topAnchor ~= diagnoseLbl.bottomAnchor + 8
        valueLbl.leftAnchor ~= leftAnchor + 14
        valueLbl.rightAnchor ~= rightAnchor - 14

        // Segmented progress
        progress.topAnchor ~= valueLbl.bottomAnchor + 6
        progress.leftAnchor ~= leftAnchor + 14
        progress.rightAnchor ~= rightAnchor - 14
        progress.bottomAnchor ~= bottomAnchor - 12
    }
    
    private func updateValueLabel() {
        guard let v = diagnoseValue else {
            valueLbl.text = "0%"
            valueLbl.textColor = UIColor(hex: "#117C02")
            return
        }
        // переведём в проценты
        let percent = Int(v * 100)
        valueLbl.text = "\(percent)%"
        progress.progress = CGFloat(v)
        
        // 0…39 → green; 40…79 → yellow; 80…100 → red
        switch percent {
        case 0...39:
            valueLbl.textColor = UIColor(hex: "#117C02")
            progress.filledColor = UIColor(hex: "#117C02") ?? .systemGreen
        case 40...79:
            valueLbl.textColor = UIColor(hex: "#F1C30C")
            progress.filledColor = UIColor(hex: "#F1C30C") ?? .systemYellow
        default:
            valueLbl.textColor = UIColor(hex: "#EB0800")
            progress.filledColor = UIColor(hex: "#EB0800") ?? .systemRed
        }

        if let name = viewModel?.infoIconName {
            infoIcon.image = UIImage(named: name)
        }
    }
}

// MARK: - SegmentedProgressBar
/// A discrete segmented bar similar to the screenshot
final class SegmentedProgressBar: UIView {
    var segments: Int = 20 { didSet { setNeedsLayout() } }
    var progress: CGFloat = 0.0 { didSet { setNeedsLayout() } }
    var filledColor: UIColor = UIColor(hex: "#117C02") ?? .systemGreen { didSet { setNeedsLayout() } }
    var emptyColor: UIColor = UIColor(white: 1.0, alpha: 1.0) { didSet { setNeedsLayout() } }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        guard segments > 0 else { return }

        let gap: CGFloat = 3
        let totalGap = gap * CGFloat(segments - 1)
        let segWidth = max(2, (bounds.width - totalGap) / CGFloat(segments))
        let segHeight = bounds.height
        let filledCount = Int(round(progress * CGFloat(segments)))

        for i in 0..<segments {
            let x = CGFloat(i) * (segWidth + gap)
            let layerSeg = CALayer()
            layerSeg.frame = CGRect(x: x, y: 0, width: segWidth, height: segHeight)
            layerSeg.cornerRadius = segHeight / 4
            layerSeg.backgroundColor = (i < filledCount ? filledColor : emptyColor).cgColor
            layer.addSublayer(layerSeg)
        }
    }
}
