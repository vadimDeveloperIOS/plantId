//
//  CheckYourPlantView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 25.06.25.
//

import UIKit

final class CheckYourPlantView: View {
    
    enum Action {
        case back
        case help
        case scan
    }

    var actionHandler: (Action) -> Void = { _ in }
    
    private lazy var headerView: DefaultHeaderView = {
        let view = DefaultHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .back:
                self.actionHandler(.back)
            case .help:
                self.actionHandler(.help)
            }
        }
        return view
    }()
    
    private lazy var firsTitle: UILabel = {
        let view = UILabel()
        let txt = "check_your_plant".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = txt.uppercased()
        view.font = UIFont(name: "Onest-SemiBold", size: 16)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    private lazy var secondTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "get_instant_insights".localized
        view.font = UIFont(name: "Onest-Regular", size: 14)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "check.your.plant")
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 209
        view.heightAnchor ~= 173
        return view
    }()
    
    private lazy var greenButtom: UIButton = {
        let view: UIButton = .greenButtonEnableCamera
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    self?.actionHandler(.scan)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 30
        view.alignment = .center
        view.distribution = .equalSpacing
        return view
    }()
    
    override func setupContent() {
        setMainBgGradient()
        addSubview(headerView)
        addSubview(stackView)
        stackView.addArrangedSubview(firsTitle)
        stackView.addArrangedSubview(secondTitle)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(greenButtom)
    }
    
    override func setupLayout() {
        headerView.leftAnchor ~= leftAnchor
        headerView.rightAnchor ~= rightAnchor
        headerView.topAnchor ~= topAnchor + 80
        headerView.heightAnchor ~= 44
        
        stackView.centerYAnchor ~= centerYAnchor - 35
        stackView.leftAnchor ~= leftAnchor + 6
        stackView.rightAnchor ~= rightAnchor - 6
    }
}
