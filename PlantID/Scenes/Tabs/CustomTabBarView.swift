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
            stackView.arrangedSubviews.forEach { view in view.removeFromSuperview() }
            items.enumerated().forEach { index, item in
                stackView.addArrangedSubview(
                    item.createView(selected: selectedIndex == index) { [weak self] in
                        self?.actionTap(index)
                    }
                )
            }
            selectedIndex = 0
        }
    }
    var actionTap: (Int) -> Void = { _ in }
    
    var selectedIndex: Int = 0 {
        didSet {
            stackView.arrangedSubviews.enumerated().forEach { index, view in
                view.isSelected = selectedIndex == index
            }
        }
    }

    private let stackView: UIStackView = {
        let view  = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()

    public override func setupContent() {
        super.setupContent()
        addSubview(stackView)
        backgroundColor = .white
    }

    public override func setupLayout() {
        super.setupLayout()
        stackView.pinToSuperview()
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

    override var isSelected: Bool {
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

@objc private extension UIView {
    var isSelected: Bool {
        get { false }
        set {}
    }

    var hasUpdates: Bool {
        get { false }
        set {}
    }
}
