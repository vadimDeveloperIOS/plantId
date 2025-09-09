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
            if let v = viewModel?.buttonName {
                button.setBackgroundImage(UIImage(named: v), for: .normal)
                title.text = nil
            } else {
                button.setBackgroundImage(UIImage(named: "Empty.Button"), for: .normal)
                title.text = "add_to_my_plants_big".localized
            }
        }
    }

    private lazy var button: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor ~= 343
        view.heightAnchor ~= 52
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

    private lazy var title: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "Onest-SemiBold", size: 14)
        lbl.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        lbl.textAlignment = .center
        return lbl
    }()

    override func setupContent() {
        addSubview(button)
        button.addSubview(title)
        button.setBackgroundImage(UIImage(named: "Empty.Button"), for: .normal)
        title.text = "add_to_my_plants_big".localized
    }

    override func setupLayout() {
        button.centerXAnchor ~= centerXAnchor
        button.centerYAnchor ~= centerYAnchor
        title.centerXAnchor ~= button.centerXAnchor
        title.centerYAnchor ~= button.centerYAnchor
    }
}
