//
//  ButtonCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 26.06.25.
//

import UIKit

final class ButtonCell: UICollectionViewCell {
    
    var viewModel: ButtonContentView.Model? {
        get {
            cellContentView.viewModel ?? .init()
        }
        set {
            cellContentView.viewModel = newValue
        }
    }
    
    var actionHandler: (ButtonContentView.Action) -> Void {
        get {
            cellContentView.actionHandler
        }
        set {
            cellContentView.actionHandler = newValue
        }
    }
    
    private lazy var cellContentView: ButtonContentView = {
        let view = ButtonContentView()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

// MARK: - CONTENT VIEW

final class ButtonContentView: View {
    
    enum Action {
        case add
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    struct Model: Hashable {
        var buttonName: String?
    }
    
    var viewModel: Model? {
        didSet {
            guard let v = viewModel?.buttonName else { return }
            button.setBackgroundImage(UIImage(named: v), for: .normal)
        }
    }
    
    private lazy var button: UIButton = {
        let view = UIButton.greenButtonAddToMyPlants
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.add)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    override func setupContent() {
        addSubview(button)
    }
    
    override func setupLayout() {
        button.centerXAnchor ~= centerXAnchor
        button.centerYAnchor ~= centerYAnchor
    }
}
