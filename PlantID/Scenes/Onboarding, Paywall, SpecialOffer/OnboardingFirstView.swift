//
//  OnboardingFirstView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 7.07.25.
//

import UIKit

final class OnboardingFirstView: View {
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    enum Action {
        case cont
        
        case privacy
        case terms
        case restore
    }
    var actionHandler: (Action) -> Void = { _ in }

    private lazy var bgImage1: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "onb.bg.1")
        view.contentMode = .scaleAspectFill
        view.widthAnchor ~= 227
        view.heightAnchor ~= 289
        return view
    }()
    
    private lazy var bgImage2: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "onb.bg.2")
        view.contentMode = .scaleAspectFill
        view.widthAnchor ~= 194
        view.heightAnchor ~= 212
        return view
    }()
    
    private lazy var bgImage3: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "onb.bg.3")
        view.contentMode = .scaleAspectFill
        view.widthAnchor ~= 121
        view.heightAnchor ~= 254
        return view
    }()
    
    private lazy var bgImage4: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "onb.bg.4")
        view.contentMode = .scaleAspectFill
        view.widthAnchor ~= 142
        view.heightAnchor ~= 298
        return view
    }()
    
    private lazy var bgImagePhone: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "onb.bg.phone1")
        view.contentMode = .scaleAspectFill
        view.heightAnchor ~= 459
        return view
    }()
    
    private lazy var simpleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 450
        return view
    }()
    
    private lazy var firsTitle: UILabel = {
        let view = UILabel()
        view.text = "scan_any_plant".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 28)
        view.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var firsTitleGreen: UILabel = {
        let view = UILabel()
        view.text = "instantly".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 28)
        view.textColor = #colorLiteral(red: 0.07304378599, green: 0.4857453108, blue: 0.007760594599, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var secondTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "get_species_and_tips".localized
        view.font = UIFont(name: "Onest-Regular", size: 16)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 1)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    private lazy var pageControl: CustomPageControl = {
        let view = CustomPageControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfPages = 5
        view.currentPage = 0
        view.widthAnchor ~= 66
        return view
    }()
    
    private lazy var button: UIButton = {
        let view = UIButton.greenButtonContinue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.cont)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var downBut1: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let title = "privacy_policy".localized
        let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 0.114, green: 0.235, blue: 0.169, alpha: 1),
                .font: UIFont(name: "Onest-Medium", size: 12)!,
            ]
        let attributed = NSAttributedString(string: title, attributes: attributes)
        view.setAttributedTitle(attributed, for: .normal)
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.privacy)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var downBut2: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let title = "terms_of_use".localized
        let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 0.114, green: 0.235, blue: 0.169, alpha: 1),
                .font: UIFont(name: "Onest-Medium", size: 12)!,
            ]
        let attributed = NSAttributedString(string: title, attributes: attributes)
        view.setAttributedTitle(attributed, for: .normal)
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.terms)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var downBut3: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let title = "Restore Purchases"
        let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 0.114, green: 0.235, blue: 0.169, alpha: 1),
                .font: UIFont(name: "Onest-Medium", size: 12)!,
            ]
        let attributed = NSAttributedString(string: title, attributes: attributes)
        view.setAttributedTitle(attributed, for: .normal)
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.restore)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
   
    override func setupContent() {
        let color1 = #colorLiteral(red: 0.7454621792, green: 0.9026893377, blue: 0.7833328843, alpha: 1)
        let color2 = #colorLiteral(red: 0.9366899133, green: 0.9615978599, blue: 0.9482398629, alpha: 1)
        backgroundGradient = .init(
            colors: [color1, color2, color2]
        )
        addSubview(bgImage1)
        addSubview(bgImage2)
        addSubview(bgImage3)
        addSubview(bgImage4)
        addSubview(bgImagePhone)
        addSubview(simpleView)
        simpleView.backgroundColor = #colorLiteral(red: 0.9526042342, green: 0.9975269437, blue: 0.9449539781, alpha: 1)
        simpleView.addSubview(firsTitle)
        simpleView.addSubview(firsTitleGreen)
        simpleView.addSubview(secondTitle)
        simpleView.addSubview(pageControl)
        simpleView.addSubview(button)
        simpleView.addSubview(downBut1)
        simpleView.addSubview(downBut2)
        simpleView.addSubview(downBut3)
    }
    
    override func setupLayout() {
        bgImage1.leftAnchor ~= leftAnchor
        bgImage1.topAnchor ~= topAnchor + 15
        
        bgImage2.rightAnchor ~= rightAnchor
        bgImage2.topAnchor ~= topAnchor + 70
        
        bgImage3.leftAnchor ~= leftAnchor
        bgImage3.topAnchor ~= bgImage1.topAnchor + 180
        
        bgImage4.rightAnchor ~= rightAnchor
        bgImage4.topAnchor ~= bgImage2.topAnchor + 290
        
        bgImagePhone.centerYAnchor ~= centerYAnchor - 130
        bgImagePhone.leftAnchor ~= leftAnchor + 10
        bgImagePhone.rightAnchor ~= rightAnchor - 40
        
        simpleView.leftAnchor ~= leftAnchor
        simpleView.rightAnchor ~= rightAnchor
        simpleView.bottomAnchor ~= bottomAnchor
        
//        firsTitle.topAnchor ~= simpleView.topAnchor + 120
        firsTitle.bottomAnchor ~= firsTitleGreen.topAnchor - 1
        firsTitle.centerXAnchor ~= simpleView.centerXAnchor
        
//        firsTitleGreen.topAnchor ~= firsTitle.bottomAnchor + 7
        firsTitleGreen.bottomAnchor ~= secondTitle.topAnchor - 10
        firsTitleGreen.centerXAnchor ~= simpleView.centerXAnchor
        
//        secondTitle.topAnchor ~= firsTitleGreen.bottomAnchor + 10
        secondTitle.bottomAnchor ~= pageControl.topAnchor - 10
        secondTitle.centerXAnchor ~= simpleView.centerXAnchor
        
//        pageControl.topAnchor ~= secondTitle.bottomAnchor + 5
        pageControl.bottomAnchor ~= button.topAnchor - 45
        pageControl.centerXAnchor ~= simpleView.centerXAnchor
        
//        button.topAnchor ~= pageControl.bottomAnchor + 25
        button.bottomAnchor ~= downBut1.topAnchor - 15
        button.centerXAnchor ~= simpleView.centerXAnchor
        
        downBut1.leftAnchor ~= simpleView.leftAnchor + 30
        downBut1.bottomAnchor ~= simpleView.bottomAnchor - 35

        downBut2.centerXAnchor ~= simpleView.centerXAnchor
        downBut2.centerYAnchor ~= downBut1.centerYAnchor
        
        downBut3.rightAnchor ~= simpleView.rightAnchor - 30
        downBut3.centerYAnchor ~= downBut1.centerYAnchor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyFadeMask()
    }

    private func applyFadeMask() {
        simpleView.layer.mask = nil

        let gradient = CAGradientLayer()
        gradient.frame = simpleView.bounds
        // Главный момент — тут нужен fade по альфе (clear → white):
        gradient.colors = [
            UIColor.clear.cgColor,  // полностью прозрачный
            UIColor.white.cgColor,  // полностью видимый
            UIColor.white.cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor
        ]
        gradient.locations = [0.0, 0.1, 1.0] as [NSNumber]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint   = CGPoint(x: 0.5, y: 1.0)

        simpleView.layer.mask = gradient
    }
}
