//
//  SearchTextField.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 23.06.25.
//

import UIKit
import Combine

final class SearchTextField: View {
    
    private var cancellables = Set<AnyCancellable>()
    var onQueryChange: ((String) -> Void)?

    
    private(set) lazy var textField: CustomTextField = {
        let view = CustomTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .none
        view.backgroundColor = .clear
        
        view.attributedPlaceholder = NSAttributedString(
            string: TextForHomeScene.search,
            attributes: [
                .foregroundColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
                .font: UIFont(name: "Poppins-Medium", size: 16)!
            ]
        )
        let img = UIImageView(image: UIImage(named: "search2"))
        img.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(img)

        img.widthAnchor ~= 32
        img.heightAnchor ~= 32
        img.leftAnchor ~= view.leftAnchor + 16
        img.centerYAnchor ~= view.centerYAnchor

        return view
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .systemUltraThinMaterialDark) // “тонкий” системный блюр
        let v = UIVisualEffectView(effect: effect)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
//        v.isUserInteractionEnabled = false // чтоб не перехватывать тапы
        v.clipsToBounds = true
        return v
    }()
    
    public override func setupContent() {
        backgroundColor = .clear
        addSubview(blurView)
        addSubview(textField)
        textField.enableReturnKeyToDismissKeyboard()
        bindTextChanges()
    }

    public override func setupLayout() {
        
        blurView.topAnchor ~= topAnchor
        blurView.leftAnchor ~= leftAnchor
        blurView.rightAnchor ~= rightAnchor
        blurView.bottomAnchor ~= bottomAnchor
        
        textField.topAnchor ~= blurView.topAnchor
        textField.leftAnchor ~= blurView.leftAnchor
        textField.rightAnchor ~= blurView.rightAnchor
        textField.bottomAnchor ~= blurView.bottomAnchor
        
        heightAnchor ~= 60
        layer.cornerRadius = 30
        clipsToBounds = true
        layer.borderColor = #colorLiteral(red: 0.7306485176, green: 0.9191811681, blue: 0.7335675359, alpha: 1)
        layer.borderWidth = 0.3
    }
    
    func bindTextChanges() {
        // на всякий случай очистим перед ребайндингом
        cancellables.removeAll()

        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
            object: textField
        )
        .compactMap { ($0.object as? UITextField)?.text }
        .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
        .removeDuplicates()
        .sink { [weak self] text in
            self?.onQueryChange?(text)
        }
        .store(in: &cancellables)
    }
}

class CustomTextField: UITextField {
    private let padding = UIEdgeInsets(top: 0, left: 66, bottom: 0, right: 16)
    
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




