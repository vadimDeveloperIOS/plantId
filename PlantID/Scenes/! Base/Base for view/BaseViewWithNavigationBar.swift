//
//  BaseViewWithNavigationBar.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 7.09.25.
//

import UIKit

class BaseViewWithNavigationBar: BaseView {
    
    enum Action {
        case back
        case setting
    }
    var actionHandler: (Action) -> Void = { _ in }
    
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
    }
    
    override func setupLayout() {
        super.setupLayout()
    }
    
    func addNavbarButtons(_ sView: UIView) {
        
        sView.addSubview(backBtn)
        sView.addSubview(settingsBtn)
        
        backBtn.topAnchor ~= topAnchor + 70
        backBtn.leftAnchor ~= leftAnchor + 16
        
        settingsBtn.centerYAnchor ~= backBtn.centerYAnchor
        settingsBtn.rightAnchor ~= rightAnchor - 16
    }
}
