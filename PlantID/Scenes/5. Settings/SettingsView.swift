//
//  SettingsView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 25.06.25.
//

import UIKit

final class SettingsView: BaseViewWithNavigationBarGreen {
    
    enum ActionChild {
        case showPaywall
        case notification
        case support
        case privacyPolicy
        case termOfUse
        case rateUs
    }

    var actionHandlerChild: (ActionChild) -> Void = { _ in }
    
    var needToGetNotifications: Bool = false {
        didSet {
            notificationsCell.needToGetNotifications = needToGetNotifications
        }
    }
    
//    var needToHidePremium: Bool = false {
//        didSet {
//            upgradeView.isHidden = needToHidePremium
//        }
//    }
    
    private(set) lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        sv.keyboardDismissMode = .interactive
        return sv
    }()
    
    private lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var headerTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 20)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.text = "profile".localized
        view.textAlignment = .center
        return view
    }()
    
    private lazy var publishButon: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(
            UIImage(named: "new_setting_not_publish"),
            for: .normal
        )
        view.contentMode = .scaleAspectFit
        
        let fTitle = UILabel()
        fTitle.translatesAutoresizingMaskIntoConstraints = false
        fTitle.text = TextForSettings.upgradePRO
        fTitle.font = UIFont(name: "Poppins-SemiBold", size: 24)
        fTitle.textColor = .black
        view.addSubview(fTitle)
        
        fTitle.widthAnchor ~= 181
        fTitle.leftAnchor ~= view.leftAnchor + 26
        fTitle.topAnchor ~= view.topAnchor + 10
        
        let sTitle = UILabel()
        sTitle.translatesAutoresizingMaskIntoConstraints = false
        sTitle.text = TextForSettings.keepYourPlants
        sTitle.font = UIFont(name: "Poppins-SemiBold", size: 20)
        sTitle.textColor = .white
        sTitle.numberOfLines = 0
        view.addSubview(sTitle)
        
        sTitle.widthAnchor ~= 181
        sTitle.leftAnchor ~= fTitle.leftAnchor
        sTitle.topAnchor ~= fTitle.bottomAnchor + 10
        
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandlerChild(.showPaywall)
            })
            , for: .touchUpInside
        )
        return view
    }()
    
    private lazy var notificationsCell: SettingsCell = {
        let view = SettingsCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 69
        view.iconNane = "new_setting_not"
        view.titleCell = "notifications".localized
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .notification:
                self.actionHandlerChild(.notification)
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
        view.iconNane = "new_setting_support"
        view.titleCell = "support".localized
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .notification:
                break
            case .go:
                self.actionHandlerChild(.support)
            }
        }
        return view
    }()
    
    private lazy var privacyCell: SettingsCell = {
        let view = SettingsCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 69
        view.iconNane = "new_setting_privacy"
        view.titleCell = "privacy_policy".localized
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .notification:
                break
            case .go:
                self.actionHandlerChild(.privacyPolicy)
            }
        }
        return view
    }()
    
    private lazy var termCell: SettingsCell = {
        let view = SettingsCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 69
        view.iconNane = "new_setting_tern"
        view.titleCell = "terms_of_use".localized
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .notification:
                break
            case .go:
                self.actionHandlerChild(.termOfUse)
            }
        }
        return view
    }()
    
    private lazy var rateCell: SettingsCell = {
        let view = SettingsCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 69
        view.iconNane = "new_setting_rate"
        view.titleCell = "rate_us".localized
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .notification:
                break
            case .go:
                self.actionHandlerChild(.rateUs)
            }
        }
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
        super.setupContent()
        
        addSubview(scrollView)

        scrollView.addSubview(container)
        
        container.addSubview(headerTitle)
        container.addSubview(publishButon)
        container.addSubview(stack)
        
        stack.addArrangedSubview(notificationsCell)
        stack.addArrangedSubview(supportCell)
        stack.addArrangedSubview(privacyCell)
        stack.addArrangedSubview(termCell)
        stack.addArrangedSubview(rateCell)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        scrollView.topAnchor ~= greenNabBg.bottomAnchor + 20
        scrollView.leftAnchor ~= leftAnchor
        scrollView.rightAnchor ~= rightAnchor
        scrollView.bottomAnchor ~= bottomAnchor
        
        container.topAnchor ~= scrollView.topAnchor
        container.leftAnchor ~= scrollView.leftAnchor
        container.rightAnchor ~= scrollView.rightAnchor
        container.bottomAnchor ~= scrollView.bottomAnchor
        container.widthAnchor ~= widthAnchor
        
        headerTitle.centerXAnchor ~= container.centerXAnchor
        headerTitle.topAnchor ~= container.topAnchor

        publishButon.leftAnchor ~= container.leftAnchor + 26
        publishButon.rightAnchor ~= container.rightAnchor - 26
        publishButon.topAnchor ~= headerTitle.bottomAnchor + 30
        publishButon.heightAnchor ~= 130

        stack.leftAnchor ~= container.leftAnchor + 26
        stack.rightAnchor ~= container.rightAnchor - 26
        stack.topAnchor ~= publishButon.bottomAnchor + 20
        stack.bottomAnchor ~= container.bottomAnchor - 30
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
    
    private lazy var button: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "new_setting_str2")
        view.contentMode = .scaleAspectFill
        view.widthAnchor ~= 30
        view.heightAnchor ~= 30
        view.backgroundColor = #colorLiteral(red: 0.926081419, green: 0.9659956098, blue: 0.8961455226, alpha: 1)
        view.layer.cornerRadius = 15
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
        backgroundColor = #colorLiteral(red: 0.8781852722, green: 0.9432410598, blue: 0.8338077068, alpha: 1)
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
        switchView.rightAnchor ~= rightAnchor - 26
        
        button.centerYAnchor ~= centerYAnchor
        button.rightAnchor ~= rightAnchor - 26
        
        action.pinToSuperview()
    }
}

// -------------------------------------
// MARK: - UpgradeView
// -------------------------------------

private final class UpgradeView: View {

    var actionHandler: () -> Void = {}

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 20)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.text = "Upgrade PRO"
        return view
    }()

    private lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Regular", size: 13)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.text = "Keep Your Plants Healthy"
        return view
    }()

    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "picture.on.plant")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var action: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.actionHandler()
        }), for: .touchUpInside)
        return view
    }()

    override func setupContent() {
        let col1 = UIColor(hex: "#DFF2D8")
        let col2 = UIColor(hex: "#C5E5B2")
        if let col1, let col2 {
            backgroundGradient = .init(colors: [col1, col2])
        }
        layer.cornerRadius = 26
        clipsToBounds = true

        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(image)
        addSubview(action)
    }

    override func setupLayout() {
        titleLabel.topAnchor ~= topAnchor + 20
        titleLabel.leftAnchor ~= leftAnchor + 20

        subtitleLabel.topAnchor ~= titleLabel.bottomAnchor + 4
        subtitleLabel.leftAnchor ~= leftAnchor + 20
        subtitleLabel.bottomAnchor <= bottomAnchor - 20

        image.centerYAnchor ~= centerYAnchor
        image.rightAnchor ~= rightAnchor - 12
        image.widthAnchor ~= 96
        image.heightAnchor ~= 96
        image.bottomAnchor ~= bottomAnchor - 8

        action.pinToSuperview()
    }
}
