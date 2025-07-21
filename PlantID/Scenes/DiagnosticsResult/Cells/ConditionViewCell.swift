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
            textValueLbl.text = viewModel.textValue
            progress.progress = CGFloat(viewModel.conditionValue ?? 0.1)
            updateValueLabel()
        }
    }
    
    private lazy var title: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 20)
        view.textColor = UIColor(red: 0.194, green: 0.274, blue: 0.211, alpha: 1)
        view.text = "condition".localized
        view.contentMode = .left
        return view
    }()
    
    private lazy var textValueLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Regular", size: 14)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 1)
        view.contentMode = .left
        view.numberOfLines = 0
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

//    private lazy var scaleImage: UIImageView = {
//        let view = UIImageView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.image = UIImage(named: "scale")
//        view.contentMode = .scaleAspectFit
//        view.heightAnchor ~= 12
//        return view
//    }()
    
    private lazy var progress: CustomProgressView = {
        let view = CustomProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.progress = 0.4
        view.markerPositions = [0.15, 0.3, 0.5, 0.8]
        return view
    }()
    
    override func setupContent() {
        backgroundColor = .clear
        
        addSubview(title)
        addSubview(textValueLbl)
        addSubview(conditionValueLbl)
        addSubview(progress)
    }
    
    override func setupLayout() {
        
        title.topAnchor ~= topAnchor
        title.leftAnchor ~= leftAnchor
        
        textValueLbl.topAnchor ~= title.bottomAnchor + 20
        textValueLbl.leftAnchor ~= leftAnchor

        conditionValueLbl.centerYAnchor ~= textValueLbl.centerYAnchor
        conditionValueLbl.rightAnchor ~= rightAnchor

        progress.topAnchor ~= textValueLbl.bottomAnchor + 20
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
        let percent = Int(v * 100)
        conditionValueLbl.text = "\(percent)%"
        
        switch percent {
        case 0...30:
            conditionValueLbl.textColor = #colorLiteral(red: 0.07304378599, green: 0.4857453108, blue: 0.007760594599, alpha: 1)
        case 31...79:
            conditionValueLbl.textColor = #colorLiteral(red: 0.9463655353, green: 0.7656276822, blue: 0.04433884472, alpha: 1)
        default:
            conditionValueLbl.textColor = #colorLiteral(red: 0.9234133959, green: 0.02450313605, blue: 0.000815604697, alpha: 1)
        }
    }
}

// ProgressView
final class CustomProgressView: UIView {
    
    // MARK: – Public API
    
    var progress: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
            fillBar.backgroundColor = setupColorForFillBar()
            setupColorForMarkers()
        }
    }
    
    /// Позиции точек (доли от ширины) 0…1
    var markerPositions: [CGFloat] = [] {
        didSet {
            markerDots.forEach { $0.removeFromSuperview() }
            markerDots = markerPositions.map { _ in UIView() }
            markerDots.forEach { addSubview($0) }
            setNeedsLayout()
        }
    }
    
    // MARK: – Private субвью
    
    private let backgroundBar = UIView()
    private let fillBar = UIView()
    private var markerDots: [UIView] = []
    
    // MARK: – Инициализация
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        // фон
        backgroundBar.backgroundColor = .white
        backgroundBar.layer.cornerRadius = 6
        backgroundBar.clipsToBounds = true
        addSubview(backgroundBar)
        
        // заполнение
        fillBar.backgroundColor = UIColor(hex: "#F1C30C")
        fillBar.layer.cornerRadius = 6
        fillBar.clipsToBounds = true
        addSubview(fillBar)
        
        // изначально нет точек
        markerPositions = []
    }
    
    // MARK: – Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // высота полоски
        let barHeight: CGFloat = 12
        let barY = (bounds.height - barHeight) / 2
        
        // фон
        backgroundBar.frame = CGRect(
            x: 0,
            y: barY,
            width: bounds.width,
            height: barHeight
        )
        
        // заполнение
        let w = max(0, min(bounds.width, bounds.width * progress))
        fillBar.frame = CGRect(
            x: 0,
            y: barY,
            width: w,
            height: barHeight
        )
        
        // точки-маркеры
        for (i, dot) in markerDots.enumerated() {
            let pos = markerPositions[i]
            let centerX = backgroundBar.frame.minX + bounds.width * pos
            let size: CGFloat = 6
            dot.frame = CGRect(
                x: centerX - size/2,
                y: barY + (barHeight - size) / 2,
                width: size,
                height: size
            )
            dot.layer.cornerRadius = size / 2
        }
    }
    
    private func setupColorForFillBar() -> UIColor {
        switch progress {
        case 0...0.31:
            return #colorLiteral(red: 0.07304378599, green: 0.4857453108, blue: 0.007760594599, alpha: 1)
        case 0.32...0.81:
            return #colorLiteral(red: 0.9463655353, green: 0.7656276822, blue: 0.04433884472, alpha: 1)
        case 0.82...1:
            return #colorLiteral(red: 0.9234133959, green: 0.02450313605, blue: 0.000815604697, alpha: 1)
        default:
            return #colorLiteral(red: 0.9234133959, green: 0.02450313605, blue: 0.000815604697, alpha: 1)
        }
    }
    
    private func setupColorForMarkers() {
        guard markerDots.count >= 4 else { return }

        // Сначала сделаем все белыми
        markerDots.forEach { $0.backgroundColor = .white }

        let green   = UIColor(red: 0.07,  green: 0.49, blue: 0.01,  alpha: 1)
        let yellow  = UIColor(red: 0.95,  green: 0.77, blue: 0.04,  alpha: 1)
        let red     = UIColor(red: 0.92,  green: 0.03, blue: 0.00,  alpha: 1)

        switch progress {
        case 0...0.15:
            markerDots[0].backgroundColor = green
            markerDots[1].backgroundColor = green
            markerDots[2].backgroundColor = yellow
            markerDots[3].backgroundColor = red

        case 0.16...0.3:
            markerDots[1].backgroundColor = green
            markerDots[2].backgroundColor = yellow
            markerDots[3].backgroundColor = red

        case 0.31...0.5:
            markerDots[2].backgroundColor = yellow
            markerDots[3].backgroundColor = red

        case 0.51...0.8:
            markerDots[3].backgroundColor = red

        default:
            break   // все белые
        }
    }
}
