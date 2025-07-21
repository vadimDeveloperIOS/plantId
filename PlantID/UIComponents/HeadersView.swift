//
//  HeadersView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit


// MARK: - DefaultHeaderView
final class DefaultHeaderView: View {
    
    enum Action {
        case back
        case help
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    private lazy var backButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "back.button")
        view.setBackgroundImage(image, for: .normal)
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.back)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 20)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.contentMode = .center
        return view
    }()
    
    private lazy var helpButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "help.button")
        view.setBackgroundImage(image, for: .normal)
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.help)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    override func setupContent() {
        backgroundColor = .clear
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(helpButton)
    }
    
    override func setupLayout() {
        titleLabel.topAnchor ~= safeAreaLayoutGuide.topAnchor + 6
        titleLabel.centerXAnchor ~= centerXAnchor
        
        helpButton.widthAnchor ~= 24
        helpButton.heightAnchor ~= 24
        helpButton.centerYAnchor ~= titleLabel.centerYAnchor
        helpButton.rightAnchor ~= rightAnchor - 23
        
        backButton.widthAnchor ~= 22
        backButton.heightAnchor ~= 22
        backButton.centerYAnchor ~= titleLabel.centerYAnchor
        backButton.leftAnchor ~= leftAnchor + 23
    }
}

// MARK: - HeaderViewWithCustomBack

final class HeaderViewWithCustomBack: View {
    
    enum Action {
        case back
        case help
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    var titleForButton: String? {
        didSet {
            guard let titleForButton else { return }
            title.text = titleForButton
        }
    }
    
    private lazy var title: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
        view.font = UIFont(name: "Onest-SemiBold", size: 20)
        view.contentMode = .left
        view.numberOfLines = 0
        view.widthAnchor ~= 170
        return view
    }()
    
    private lazy var backImage: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "back.button")?.withRenderingMode(.alwaysTemplate)
        view.setImage(image, for: .normal)
        view.tintColor = .white
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 28
        view.heightAnchor ~= 28
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.back)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var greenView: View = {
        let view = View()
        view.translatesAutoresizingMaskIntoConstraints = false
        let col1 = UIColor(hex: "#8FDB85")
        let col2 = UIColor(hex: "#117C02")
        if let col1, let col2 {
            view.backgroundGradient = .init(colors: [col1, col1, col2, col2])
        }
        return view
    }()
    
    private lazy var helpButton: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "help.button")?.withRenderingMode(.alwaysTemplate)
        view.setImage(image, for: .normal)
        view.tintColor = .white
        view.imageView?.contentMode = .scaleAspectFit
        view.backgroundColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 0.33)
        view.widthAnchor ~= 28
        view.heightAnchor ~= 28
        view.layer.cornerRadius = 14
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.help)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    override func setupContent() {
        backgroundColor = .clear
        addSubview(greenView)
        addSubview(helpButton)
        addSubview(backImage)
        addSubview(title)
        greenView.layer.cornerRadius = 130
        greenView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        greenView.layer.masksToBounds = true
    }
    
    override func setupLayout() {
        helpButton.topAnchor ~= safeAreaLayoutGuide.topAnchor + 6
        helpButton.rightAnchor ~= rightAnchor - 23
        
        greenView.widthAnchor ~= 236
        greenView.heightAnchor ~= 100
        greenView.topAnchor ~= safeAreaLayoutGuide.topAnchor - 250
        greenView.bottomAnchor ~= safeAreaLayoutGuide.topAnchor + 95
        greenView.leftAnchor ~= leftAnchor

        backImage.topAnchor ~= safeAreaLayoutGuide.topAnchor + 6
        backImage.leftAnchor ~= leftAnchor + 10
        
        title.topAnchor ~= safeAreaLayoutGuide.topAnchor + 6
        title.leftAnchor ~= backImage.rightAnchor + 6
    }
}
