//
//  BaseViewWithNavigationBarGreen.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 7.09.25.
//

import UIKit

class BaseViewWithNavigationBarGreen: BaseView {
    
    enum Action {
        case back
        case setting
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    private(set) lazy var greenNabBg: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "navbar_green_bg")
        view.contentMode = .scaleAspectFill
        view.heightAnchor ~= 137
        return view
    }()
    
    private(set) lazy var backBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(
            UIImage(named: "navbar_str"),
            for: .normal
        )
        view.imageView?.contentMode = .scaleAspectFit
        view.heightAnchor ~= 40
        view.widthAnchor ~= 40
        view.layer.cornerRadius = 20
        view.backgroundColor = .clear.withAlphaComponent(0.5)
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.back)
                })
            , for: .touchUpInside
        )
        view.contentEdgeInsets =
            .init(
                top: 7,
                left: 7,
                bottom: 7,
                right: 7
            )
        return view
    }()
    
    private(set) lazy var settingsBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(
            UIImage(named: "navbar_set"),
            for: .normal
        )
        view.imageView?.contentMode = .scaleAspectFit
        view.heightAnchor ~= 40
        view.widthAnchor ~= 40
        view.layer.cornerRadius = 20
        view.backgroundColor = .clear.withAlphaComponent(0.5)
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.setting)
                })
            , for: .touchUpInside
        )
        view.contentEdgeInsets =
            .init(
                top: 7,
                left: 7,
                bottom: 7,
                right: 7
            )
        return view
    }()
    
    
    override func setupContent() {
        super.setupContent()
        addSubview(greenNabBg)
        addSubview(backBtn)
        addSubview(settingsBtn)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        greenNabBg.topAnchor ~= topAnchor
        greenNabBg.leftAnchor ~= leftAnchor
        greenNabBg.rightAnchor ~= rightAnchor
        
        backBtn.centerYAnchor ~= greenNabBg.centerYAnchor + 20
        backBtn.leftAnchor ~= leftAnchor + 16
        
        settingsBtn.centerYAnchor ~= backBtn.centerYAnchor
        settingsBtn.rightAnchor ~= rightAnchor - 16
    }
}
