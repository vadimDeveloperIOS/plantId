//
//  SearchTextField.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 23.06.25.
//

import UIKit

final class SearchTextField: View {
    
    var placeholder = "Search"
    
    private(set) lazy var textField: CustomTextField = {
        let view = CustomTextField()
        view.placeholder = placeholder
        view.backgroundColor = .white
        view.textColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                .foregroundColor: UIColor(red: 0.19, green: 0.291, blue: 0.178, alpha: 1),
                .font: UIFont(name: "Onest-Regular", size: 16)
            ]
        )
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "search1"), for: .normal)
        view.addSubview(button)

        button.widthAnchor ~= 32
        button.heightAnchor ~= 32
        button.rightAnchor ~= view.rightAnchor - 6
        button.centerYAnchor ~= view.centerYAnchor

        return view
    }()
    
    
    public override func setupContent() {
        addSubview(textField)
        textField.enableReturnKeyToDismissKeyboard()
    }

    public override func setupLayout() {
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




