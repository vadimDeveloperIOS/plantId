//
//  SearchTextField.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 23.06.25.
//

import UIKit

final class SearchTextField: View {
    
    private(set) lazy var textField: CustomTextField = {
        let view = CustomTextField()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.attributedPlaceholder = NSAttributedString(
            string: TextForHomeScene.search,
            attributes: [
                .foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
                .font: UIFont(name: "OpenSans-Regular", size: 16)!
            ]
        )
        let img = UIImageView(image: UIImage(named: "search1"))
        img.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(img)

        img.widthAnchor ~= 32
        img.heightAnchor ~= 32
        img.leftAnchor ~= view.leftAnchor + 16
        img.centerYAnchor ~= view.centerYAnchor

        return view
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemThinMaterial) // “тонкий” системный блюр
        let v = UIVisualEffectView(effect: effect)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = false // чтоб не перехватывать тапы
        return v
    }()
    
    public override func setupContent() {
        heightAnchor ~= 60
        addSubview(blurView)
        blurView.addSubview(textField)
        textField.enableReturnKeyToDismissKeyboard()
    }

    public override func setupLayout() {
        blurView.pinToSuperview()
        textField.pinToSuperview()
    }
}

class CustomTextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}




