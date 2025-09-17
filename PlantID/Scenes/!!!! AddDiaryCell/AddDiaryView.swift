//
//  AddDiaryView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 16.09.25.
//

import UIKit

final class AddDiaryView: BaseViewWithNavigationBarGreen {
    
    // MARK: ACTION
    enum ActionChild {
        case addPhoto
        case save
    }
    var actionHandlerChild: (ActionChild) -> Void = { _ in }
    
    
    // MARK: MODEL
    struct Model {
        let textFirstTitle: String
        let textSecondTitle: String
        let textThirdTitle: String
        let cellModel: AddDiaryContent.Model?
        let textButton: String
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            
            firsTitle.text = viewModel.textFirstTitle
            secondTitle.text = viewModel.textSecondTitle
            thirdTitle.text = viewModel.textThirdTitle
            saveButton.setTitle(viewModel.textButton, for: .normal)
            
            guard let cellModel = viewModel.cellModel else { return }
            
            cell.viewModel = cellModel
        }
    }
    
    // MARK: UI VIEWS
    
    private(set) lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alwaysBounceVertical = true
        sv.keyboardDismissMode = .interactive
        return sv
    }()
    
    private lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var firsTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-SemiBold", size: 24)
        view.textColor = #colorLiteral(red: 0.5569139123, green: 0.786534369, blue: 0.3074461818, alpha: 1)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    private lazy var secondTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 16)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    private lazy var thirdTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-SemiBold", size: 20)
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    private(set) lazy var cell: AddDiaryContent = {
        let view = AddDiaryContent()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.actionHandler = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .addPhoto:
                self.actionHandlerChild(.addPhoto)
            }
        }
        return view
    }()
    
    private lazy var saveButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(
            UIImage(named: "my_plants_btnn"),
            for: .normal
        )
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
        view.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
                self.actionHandlerChild(.save)
            }),
            for: .touchUpInside
        )
        view.widthAnchor ~= 244
        view.heightAnchor ~= 70
        return view
    }()
    
    
    // MARK: SETUP METH
    override func setupContent() {
        super.setupContent()
        
        backgroundColor = .white

        addSubview(scrollView)
        scrollView.addSubview(container)
        
        [ firsTitle, secondTitle, thirdTitle , cell, saveButton ]
            .forEach {
                container.addSubview($0)
            }
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        scrollView.topAnchor ~= greenNabBg.bottomAnchor + 20
        scrollView.leftAnchor ~= leftAnchor
        scrollView.rightAnchor ~= rightAnchor
        scrollView.bottomAnchor ~= bottomAnchor
        
        container.topAnchor ~= scrollView.topAnchor
        container.leftAnchor ~= scrollView.leftAnchor
        container.rightAnchor ~= scrollView.rightAnchor
        container.bottomAnchor ~= scrollView.bottomAnchor
        container.widthAnchor ~= widthAnchor
        
        firsTitle.topAnchor ~= container.topAnchor
        firsTitle.centerXAnchor ~= container.centerXAnchor
        
        secondTitle.topAnchor ~= firsTitle.bottomAnchor + 10
        secondTitle.leftAnchor ~= container.leftAnchor + 16
        secondTitle.rightAnchor ~= container.rightAnchor - 16
        
        thirdTitle.topAnchor ~= secondTitle.bottomAnchor + 16
        thirdTitle.leftAnchor ~= container.leftAnchor + 16
        
        cell.topAnchor ~= thirdTitle.bottomAnchor + 12
        cell.leftAnchor ~= container.leftAnchor + 16
        cell.rightAnchor ~= container.rightAnchor - 16
        
        saveButton.topAnchor ~= cell.bottomAnchor + 12
        saveButton.centerXAnchor ~= container.centerXAnchor
        saveButton.bottomAnchor ~= container.bottomAnchor - 30
    }
}
