//
//  StartGrowthDiaryView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 17.09.25.
//

import UIKit

final class StartGrowthDiaryView: BaseViewWithNavigationBarGreen {
    
    // MARK: - Model
    struct Model {
        let headerTitle: String
        let headerSubtitle: String
        let steps: [Step]
        let bottomText: String
        let buttonTitle: String
        
        struct Step {
            let imageName: String
            let stepTitle: String
            let stepSubtitle: String
        }
    }
    
    // MARK: - Action
    enum ActionChild {
        case addNewPlant
    }
    var actionHandlerChild: (ActionChild) -> Void = { _ in }
    
    var viewModel: Model? {
        didSet {
            guard let vm = viewModel else { return }
            headerTitle.text = vm.headerTitle
            headerSubtitle.text = vm.headerSubtitle
            
            stepsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            vm.steps.forEach { step in
                let view = StepView()
                view.configure(step: step)
                stepsStack.addArrangedSubview(view)
            }
            
            bottomLabel.text = vm.bottomText
            addPlantButton.setTitle(vm.buttonTitle, for: .normal)
        }
    }
    
    // MARK: - UI
    
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
    
    private lazy var headerTitle: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "Poppins-SemiBold", size: 22)
        v.textColor = #colorLiteral(red: 0.5569187999, green: 0.786532104, blue: 0.3126749396, alpha: 1)
        v.textAlignment = .center
        return v
    }()
    
    private lazy var headerSubtitle: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "Poppins-Regular", size: 14)
        v.textColor = UIColor.darkGray
        v.numberOfLines = 0
        v.textAlignment = .center
        return v
    }()
    
    private lazy var stepsStack: UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        v.spacing = 16
        return v
    }()
    
    private lazy var bottomLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "Poppins-Regular", size: 14)
        v.textColor = UIColor.darkGray
        v.numberOfLines = 0
        v.textAlignment = .center
        return v
    }()
    
    private lazy var addPlantButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setBackgroundImage(UIImage(named: "my_plants_btnn"), for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
        b.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.actionHandlerChild(.addNewPlant)
        }, for: .touchUpInside)
        b.widthAnchor ~= 244
        b.heightAnchor ~= 70
        return b
    }()
    
    // MARK: - Lifecycle
    override func setupContent() {
        super.setupContent()
        backgroundColor = .white
        
        addSubview(scrollView)
        scrollView.addSubview(container)
        
        container.addSubview(headerTitle)
        container.addSubview(headerSubtitle)
        container.addSubview(stepsStack)
        container.addSubview(bottomLabel)
        container.addSubview(addPlantButton)
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
        
        headerTitle.topAnchor ~= container.topAnchor
        headerTitle.centerXAnchor ~= container.centerXAnchor
        
        headerSubtitle.topAnchor ~= headerTitle.bottomAnchor + 8
        headerSubtitle.leftAnchor ~= container.leftAnchor + 16
        headerSubtitle.rightAnchor ~= container.rightAnchor - 16
        
        stepsStack.topAnchor ~= headerSubtitle.bottomAnchor + 20
        stepsStack.leftAnchor ~= container.leftAnchor + 16
        stepsStack.rightAnchor ~= container.rightAnchor - 16
        
        bottomLabel.topAnchor ~= stepsStack.bottomAnchor + 20
        bottomLabel.leftAnchor ~= container.leftAnchor + 16
        bottomLabel.rightAnchor ~= container.rightAnchor - 16
        
        addPlantButton.topAnchor ~= bottomLabel.bottomAnchor + 16
        addPlantButton.centerXAnchor ~= container.centerXAnchor
        addPlantButton.bottomAnchor ~= container.bottomAnchor - 30
    }
    
    // MARK: - Step View
    private final class StepView: View {
        
        private lazy var icon: UIImageView = {
            let v = UIImageView()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.contentMode = .scaleAspectFit
            v.widthAnchor ~= 88
            v.heightAnchor ~= 88
            return v
        }()
        
        private lazy var title: UILabel = {
            let v = UILabel()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.font = UIFont(name: "Poppins-SemiBold", size: 16)
            v.textColor = #colorLiteral(red: 0.3176164329, green: 0.6377245784, blue: 0.08069127053, alpha: 1)
            return v
        }()
        
        private lazy var subtitle: UILabel = {
            let v = UILabel()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.font = UIFont(name: "Poppins-Regular", size: 14)
            v.textColor = UIColor.darkGray
            v.numberOfLines = 0
            return v
        }()
        
        override func setupContent() {
            backgroundColor = #colorLiteral(red: 0.8757417798, green: 0.9357268214, blue: 0.8287137151, alpha: 1)
            layer.cornerRadius = 20
            addSubview(icon)
            addSubview(title)
            addSubview(subtitle)
        }
        
        override func setupLayout() {
            icon.centerYAnchor ~= centerYAnchor
            icon.leftAnchor ~= leftAnchor + 16
            
            title.topAnchor ~= topAnchor + 16
            title.leftAnchor ~= icon.rightAnchor + 12
            title.rightAnchor ~= rightAnchor - 10
            
            subtitle.topAnchor ~= title.bottomAnchor + 10
            subtitle.leftAnchor ~= icon.rightAnchor + 12
            subtitle.rightAnchor ~= rightAnchor - 10
            subtitle.bottomAnchor ~= bottomAnchor - 10
        }
        
        func configure(step: Model.Step) {
            icon.image = UIImage(named: step.imageName)
            title.text = step.stepTitle
            subtitle.text = step.stepSubtitle
        }
    }
}

