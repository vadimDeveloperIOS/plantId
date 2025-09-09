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
//                view.isSelected = selectedIndex == index
            }
            centerButton.isSelected = selectedIndex == -1
        }
    }

    private var itemViews: [UIView] = []

    private let stackView: UIStackView = {
        let view  = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .center
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = .init(top: 0, left: 24, bottom: 0, right: 24)
        return view
    }()

    private let centerButton: UIButton = {
        let button = UIButton(type: .custom)
//        button.backgroundColor = UIColor.systemGreen
        button.layer.cornerRadius = 32
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
        layer.cornerRadius = 28
        centerButton.addTarget(self, action: #selector(centerTapped), for: .touchUpInside)
    }

    public override func setupLayout() {
        super.setupLayout()
        stackView.pinToSuperview()
        centerButton.centerXAnchor ~= centerXAnchor
        centerButton.centerYAnchor ~= topAnchor - 20
        centerButton.widthAnchor ~= 70
        centerButton.heightAnchor ~= 70
    }

    @objc private func centerTapped() {
        centerAction()
    }
}

// CustomTabbarItemView
private class CustomTabbarItemView: View {
    var imageView: UIImageView?
    
    var image: UIImage? {
        didSet {
            noSelectedimageView.image = image
            
        }
    }
    
    var selectedImage: UIImage? {
        didSet {
            selectedImageView.image = selectedImage
        }
    }

    var action: (() -> Void)?

    var isSelected: Bool {
        get {
            !noSelectedimageView.isHidden
        }
        
        set {
            selectedImageView.isHidden = !newValue
            noSelectedimageView.isHidden = newValue
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
    
    private lazy var selectedImageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = false
        view.contentMode = .scaleAspectFill
        view.heightAnchor ~= 40
        view.widthAnchor ~= 100
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view  = UIStackView(arrangedSubviews: [selectedImageView, noSelectedimageView])
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
        
        selectedImageView.isHidden = true
        noSelectedimageView.isHidden = false
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
        view.selectedImage = selectedImage
        view.action = action
        return view
    }
}
