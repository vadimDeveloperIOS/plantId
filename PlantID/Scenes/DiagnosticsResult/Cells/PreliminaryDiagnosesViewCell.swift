//
//  PreliminaryDiagnosesViewCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 26.06.25.
//

import UIKit

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


// MARK: - CONTENT VIEW

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
        lbl.font = UIFont(name: "Onest-SemiBold", size: 20)
        lbl.textColor = UIColor(red: 0.194, green: 0.274, blue: 0.211, alpha: 1)
        lbl.text = "preliminary_diagnoses".localized
        return lbl
    }()
    
    private lazy var stackV: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        s.spacing = 30
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


/// Одна строка диагноза: иконка, название и процент в бейдже
final class DiagnosesCell: View {
    
    struct Model: Hashable {
      let name: String
      let probability: Float
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
        lbl.font = UIFont(name: "Onest-Regular", size: 14)
        lbl.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.8)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    /// Белый фон под процент
    private lazy var whiteView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.cornerRadius = 13
        v.widthAnchor  ~= 61
        v.heightAnchor ~= 26
        return v
    }()
    
    private lazy var valueLbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Onest-Regular", size: 14)
        return lbl
    }()
    
    // MARK: Init
    
    override func setupContent() {
        backgroundColor = .clear
        addSubview(image)
        addSubview(diagnoseLbl)
        addSubview(whiteView)
        addSubview(valueLbl)
    }
    
    override func setupLayout() {
        // Иконка
        image.centerYAnchor   ~= centerYAnchor
        image.leftAnchor   ~= leftAnchor
        
        // Текст диагноза
        diagnoseLbl.centerYAnchor   ~= centerYAnchor
        diagnoseLbl.leftAnchor   ~= image.rightAnchor + 10
        
        // Белый бейдж справа
        whiteView.centerYAnchor     ~= centerYAnchor
        whiteView.rightAnchor    ~= rightAnchor
        
        // Процент по центру бейджа
        valueLbl.centerXAnchor      ~= whiteView.centerXAnchor
        valueLbl.centerYAnchor      ~= whiteView.centerYAnchor
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
        
        // 0…39   → зелёный
        // 40…79  → жёлтый
        // 80…100 → красный
        switch percent {
        case 0...39:
            valueLbl.textColor = UIColor(hex: "#117C02")
        case 40...79:
            valueLbl.textColor = UIColor(hex: "#F1C30C")
        default:
            valueLbl.textColor = UIColor(hex: "#EB0800")
        }
    }
}
