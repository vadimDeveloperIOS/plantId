//
//  DiagnosticsView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 25.06.25.
//

import UIKit

final class DiagnosticsView: View {
    
    enum Action {
        case cont
    }

    var actionHandler: (Action) -> Void = { _ in }
    
    private lazy var firsTitle: UILabel = {
        let view = UILabel()
        let txt = "snap_tips".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = txt.uppercased()
        view.font = UIFont(name: "Onest-SemiBold", size: 16)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.numberOfLines = 0
        view.contentMode = .center
        return view
    }()
    
    private lazy var secondTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "how_to_take_better_photos".localized
        view.font = UIFont(name: "Onest-Regular", size: 14)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.numberOfLines = 0
        view.contentMode = .center
        return view
    }()
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 45
        view.distribution = .fill
        view.widthAnchor ~= 343
        return view
    }()
    
    private lazy var firstCell: DiagnosticCell = {
        let view = DiagnosticCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor ~= 343
        view.heightAnchor ~= 78
        view.imageName = "snap_1"
        view.name = "step_1".localized
        view.descr = "photograph_entire_plant".localized
        return view
    }()
    
    private lazy var secondCell: DiagnosticCell = {
        let view = DiagnosticCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor ~= 343
        view.heightAnchor ~= 78
        view.imageName = "snap_2"
        view.name = "step_2".localized
        view.descr = "zoom_problem_area".localized
        return view
    }()
    
    private lazy var therdCell: DiagnosticCell = {
        let view = DiagnosticCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor ~= 343
        view.heightAnchor ~= 78
        view.imageName = "snap_3"
        view.name = "step_3".localized
        view.descr = "take_another_shot".localized
        return view
    }()
    
    private lazy var greenButtom: UIButton = {
        let view: UIButton = .greenButtonContinue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.actionHandler(.cont)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var secondStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 30
        view.alignment = .center
        view.backgroundColor = .clear
        view.distribution = .fill
        return view
    }()
    
    override func setupContent() {
        setMainBgGradient()
        addSubview(secondStack)
        secondStack.addArrangedSubview(firsTitle)
        secondStack.addArrangedSubview(secondTitle)
        secondStack.addArrangedSubview(stack)
        stack.addArrangedSubview(firstCell)
        stack.addArrangedSubview(secondCell)
        stack.addArrangedSubview(therdCell)
        addSubview(greenButtom)
//        secondStack.addArrangedSubview(greenButtom)
    }
    
    override func setupLayout() {
        secondStack.centerYAnchor ~= centerYAnchor - 80
        secondStack.leftAnchor ~= leftAnchor + 6
        secondStack.rightAnchor ~= rightAnchor - 6
        
        greenButtom.centerXAnchor ~= centerXAnchor
        greenButtom.topAnchor ~= secondStack.bottomAnchor + 70
    }
}

// ---------------------------------
// MARK: - DiagnosticCell
// ---------------------------------

final private class DiagnosticCell: View {
    
    var imageName: String? {
        didSet {
            guard let imageName else { return }
            image.image = UIImage(named: imageName)
        }
    }
    
    var name: String? {
        didSet {
            guard let name else { return }
            content.name = name
        }
    }
    
    var descr: String? {
        didSet {
            guard let descr else { return }
            content.descr = descr
        }
    }
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        return view
    }()
    
    private let content: CurrectViewForDiagnostics = {
        let view = CurrectViewForDiagnostics()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true // тут обрезаем края
        return view
    }()

    override func setupContent() {
        backgroundColor = .clear // важный момент — не обрезаем тут
        addSubview(content)
        addSubview(image)

    }
    
    override func setupLayout() {
        content.pinToSuperview()
        
        image.widthAnchor ~= 98
        image.heightAnchor ~= 98
        image.centerYAnchor ~= content.centerYAnchor
        image.leftAnchor ~= leftAnchor + 16
    }
}

final private class CurrectViewForDiagnostics: View {
    
    var name: String? {
        didSet {
            guard let name else { return }
            firsTitle.text = name.uppercased()
        }
    }
    
    var descr: String? {
        didSet {
            guard let descr else { return }
            secondTitle.text = descr
        }
    }
    
    private lazy var firsTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 18)
        view.textColor = UIColor(red: 0.067, green: 0.488, blue: 0.009, alpha: 1)
        view.numberOfLines = 0
        view.contentMode = .center
        return view
    }()

    private lazy var secondTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Medium", size: 14)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.numberOfLines = 0
        view.contentMode = .center
        return view
    }()
    
    override func setupContent() {
        let col1: UIColor = .white
        let col2 = UIColor(hex: "#B7E4C2")

        if let col2 {
            backgroundGradient = .init(colors: [ col1, col2])
        }
        
        addSubview(firsTitle)
        addSubview(secondTitle)
    }
    
    override func setupLayout() {
        firsTitle.topAnchor ~= topAnchor + 12
        firsTitle.leftAnchor ~= leftAnchor + 130
        
        secondTitle.topAnchor ~= firsTitle.bottomAnchor + 4
        secondTitle.leftAnchor ~= leftAnchor + 130
        secondTitle.rightAnchor ~= rightAnchor - 10
    }
}
