//
//  CustomTabBarView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit

class CustomTabBarView: View {

    var items: [TabBarItem] = [] {
        didSet {
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            itemViews.removeAll()

            items.enumerated().forEach { index, item in
                if index == 2 {
                    stackView.addArrangedSubview(UIView())
                }
                let view = item.createView(selected: selectedIndex == index) { [weak self] in
                    self?.actionTap(index)
                }
                itemViews.append(view)
                stackView.addArrangedSubview(view)
            }

            selectedIndex = 0
        }
    }

    var actionTap: (Int) -> Void = { _ in }
    var centerAction: () -> Void = {}

    var centerImage: UIImage? {
        didSet {
            centerButton.setBackgroundImage(centerImage, for: .normal)
        }
    }
    var centerSelectedImage: UIImage? {
        didSet {
            centerButton.setImage(centerSelectedImage, for: .selected)
        }
    }

    var selectedIndex: Int = -1 {
        didSet {
            itemViews.enumerated().forEach { index, view in
                (view as? CustomTabbarItemView)?.isSelected = (selectedIndex == index)
            }
            centerButton.isSelected = selectedIndex == -1
        }
    }
    private var itemViews: [UIView] = []

    private let stackView: UIStackView = {
        let view  = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalCentering
        view.alignment = .center
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .init(top: 0, left: 70, bottom: 10, right: 70)
        return view
    }()

    private let centerButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.backgroundColor = UIColor.systemGreen
//        button.layer.cornerRadius = 32
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOpacity = 0.15
//        button.layer.shadowOffset = CGSize(width: 0, height: 4)
//        button.layer.shadowRadius = 6
        return button
    }()

    public override func setupContent() {
        super.setupContent()
        addSubview(stackView)
        addSubview(centerButton)
        backgroundColor = .white
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.masksToBounds = false
        layer.cornerRadius = 28
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 10
        centerButton.addTarget(self, action: #selector(centerTapped), for: .touchUpInside)
    }

    public override func setupLayout() {
        super.setupLayout()
        stackView.pinToSuperview()
            
        centerButton.centerXAnchor ~= centerXAnchor
        centerButton.centerYAnchor ~= topAnchor
        centerButton.widthAnchor ~= 90
        centerButton.heightAnchor ~= 90
    }

    @objc private func centerTapped() {
        centerAction()
    }
}

// MARK: - CustomTabbarItemView

private class CustomTabbarItemView: View {
    var imageView: UIImageView?
    
    var image: UIImage? {
        didSet {
            noSelectedimageView.image = image?.withRenderingMode(.alwaysTemplate)
            
        }
    }

    var action: (() -> Void)?

    var isSelected: Bool {
        get {
            noSelectedimageView.tintColor == .systemGreen
        }
        set {
            noSelectedimageView.tintColor = newValue ?
            #colorLiteral(red: 0.2902783453, green: 0.6072986722, blue: 0.1340575516, alpha: 1)
            : .black
        }
    }
    private lazy var noSelectedimageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 20
        view.heightAnchor ~= 40
        return view
    }()
        
    private lazy var stackView: UIStackView = {
        let view  = UIStackView(arrangedSubviews: [ noSelectedimageView])
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fillEqually
        view.spacing = 0
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didButtonPress))
        view.addGestureRecognizer(recognizer)
        view.isUserInteractionEnabled = true
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .init(top: 1, left: 0, bottom: 6, right: 0)
        return view
    }()

    override func setupContent() {
        super.setupContent()
        addSubview(stackView)
    }

    override func setupLayout() {
        super.setupLayout()
        stackView.pinToSuperview()
    }

    @objc private func didButtonPress() {
        action?()
    }
}

extension TabBarItem {
    func createView(selected: Bool, _ action: (() -> Void)?) -> UIView {
        let view = CustomTabbarItemView()
        view.image = image
        view.action = action
        view.isSelected = selected
        return view
    }
}
