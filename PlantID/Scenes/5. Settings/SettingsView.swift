//
//  SettingsView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 25.06.25.
//

import UIKit

final class SettingsView: View {
    
    enum Action {
        case showPaywall
        case notification
        case support
        case privacyPolicy
        case termOfUse
        case rateUs
    }

    var actionHandler: (Action) -> Void = { _ in }
    
    var needToGetNotifications: Bool = false {
        didSet {
            notificationsCell.needToGetNotifications = needToGetNotifications
        }
    }
    
    var needToHidePremium: Bool = false {
        didSet {
            premiumButton.isHidden = needToHidePremium
        }
    }
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var headerTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 20)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.text = "profile".localized
        view.contentMode = .center
        return view
    }()
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "settings.image")
        view.contentMode = .scaleAspectFill
        view.heightAnchor ~= 156
        return view
    }()
    
    private lazy var notificationsCell: SettingsCell = {
        let view = SettingsCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 69
        view.iconNane = "not_icons"
        view.titleCell = "notifications".localized
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .notification:
                self.actionHandler(.notification)
            case .go:
                break
            }
        }
        view.needSwitch = true
        return view
    }()
    
    private lazy var supportCell: SettingsCell = {
        let view = SettingsCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 69
        view.iconNane = "sup_icons"
        view.titleCell = "support".localized
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .notification:
                break
            case .go:
                self.actionHandler(.support)
            }
        }
        return view
    }()
    
    private lazy var privacyCell: SettingsCell = {
        let view = SettingsCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 69
        view.iconNane = "pr_icons"
        view.titleCell = "privacy_policy".localized
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .notification:
                break
            case .go:
                self.actionHandler(.privacyPolicy)
            }
        }
        return view
    }()
    
    private lazy var termCell: SettingsCell = {
        let view = SettingsCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 69
        view.iconNane = "tern_icons"
        view.titleCell = "terms_of_use".localized
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .notification:
                break
            case .go:
                self.actionHandler(.termOfUse)
            }
        }
        return view
    }()
    
    private lazy var rateCell: SettingsCell = {
        let view = SettingsCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 69
        view.iconNane = "rate_icons"
        view.titleCell = "rate_us".localized
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .notification:
                break
            case .go:
                self.actionHandler(.rateUs)
            }
        }
        return view
    }()
    
    private lazy var premiumButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Go Premium", for: .normal)
        view.setTitleColor(
            UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1),
            for: .normal
        )
        view.titleLabel?.font = UIFont(name: "Onest-Medium", size: 16)
        view.backgroundColor = .white
        view.widthAnchor ~= 120
        view.heightAnchor ~= 32
        view.layer.cornerRadius = 16
        view.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
                self.actionHandler(.showPaywall)
            }),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 20
//        view.distribution = .center
//        view.backgroundColor = .clear
        view.distribution = .fill
        return view
    }()
    
    override func setupContent() {
        setMainBgGradient()
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerTitle)
        contentView.addSubview(image)
        contentView.addSubview(stack)
        contentView.addSubview(premiumButton)
        stack.addArrangedSubview(notificationsCell)
        stack.addArrangedSubview(supportCell)
        stack.addArrangedSubview(privacyCell)
        stack.addArrangedSubview(termCell)
        stack.addArrangedSubview(rateCell)
    }
    
    override func setupLayout() {
        scrollView.pinToSuperview()
        
        contentView.leftAnchor ~= scrollView.leftAnchor
        contentView.rightAnchor ~= scrollView.rightAnchor
        contentView.topAnchor ~= scrollView.topAnchor
        contentView.bottomAnchor ~= scrollView.bottomAnchor
        contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
        
        headerTitle.centerXAnchor ~= centerXAnchor
        headerTitle.topAnchor ~= contentView.topAnchor + 30
        
        image.leftAnchor ~= leftAnchor + 6
        image.rightAnchor ~= rightAnchor - 6
        image.topAnchor ~= headerTitle.bottomAnchor + 30
        
        premiumButton.rightAnchor ~= image.rightAnchor - 45
        premiumButton.bottomAnchor ~= image.bottomAnchor - 20
        
        stack.leftAnchor ~= contentView.leftAnchor + 26
        stack.rightAnchor ~= contentView.rightAnchor - 26
        stack.topAnchor ~= image.bottomAnchor + 30
        stack.bottomAnchor ~= contentView.bottomAnchor - 30
    }
}

// -------------------------------------
// MARK: - SettingsCell
// -------------------------------------

private final class SettingsCell: View {
    
    enum Action {
        case notification
        case go
    }

    var actionHandler: (Action) -> Void = { _ in }
    
    var needSwitch: Bool = false {
        didSet {
            if needSwitch == true {
                button.isHidden = true
                action.isUserInteractionEnabled = false
                switchView.isHidden = false
            }
        }
    }
    
    var needToGetNotifications: Bool = false {
        didSet {
            switchView.isOn = needToGetNotifications
        }
    }
    
    var iconNane: String? {
        didSet{
            guard let iconNane else { return }
            image.image = UIImage(named: iconNane)
        }
    }
    
    var titleCell: String? {
        didSet {
            guard let titleCell else { return }
            title.text = titleCell
        }
    }
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "settings.image")
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 28
        view.heightAnchor ~= 28
        return view
    }()
    
    
    private lazy var title: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Medium", size: 16)
        view.textColor = UIColor(red: 0.114, green: 0.235, blue: 0.169, alpha: 1)
        view.contentMode = .left
        return view
    }()
    
    private lazy var switchView: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onTintColor = UIColor(hex: "#8FDB85")
        view.widthAnchor ~= 44
        view.heightAnchor ~= 28
        view.isOn = true
        view.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
                self.actionHandler(.notification)
            })
            , for: .valueChanged)
        view.isHidden = true
        return view
    }()
    
    private lazy var button: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor ~= 24
        view.heightAnchor ~= 24
        let image = UIImage(named: "icons_24")
        view.setBackgroundImage(image, for: .normal)
        return view
    }()
    
    private lazy var action: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.go)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    override func setupContent() {
        backgroundColor = .white
        layer.cornerRadius = 26
        addSubview(image)
        addSubview(title)
        addSubview(switchView)
        addSubview(button)
        addSubview(action)
    }

    override func setupLayout() {
        image.centerYAnchor ~= centerYAnchor
        image.leadingAnchor ~= leadingAnchor + 16
        
        title.centerYAnchor ~= centerYAnchor
        title.leadingAnchor ~= image.trailingAnchor + 8
        
        switchView.centerYAnchor ~= centerYAnchor
        switchView.trailingAnchor ~= trailingAnchor - 16
        
        button.centerYAnchor ~= centerYAnchor
        button.trailingAnchor ~= trailingAnchor - 16
        
        action.pinToSuperview()
    }
}
