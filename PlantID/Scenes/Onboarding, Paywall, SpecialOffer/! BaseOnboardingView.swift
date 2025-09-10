//
//  BaseOnboardingView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 7.07.25.
//

import UIKit

class BaseOnboardingView: View {
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    var textFor1Lbl: String? {
        didSet {
            if let textFor1Lbl {
                firsTitle.text = textFor1Lbl
            }
        }
    }
    
    var textFor1GrennLbl: String? {
        didSet {
            if let textFor1GrennLbl {
                firsTitleGreen.text = textFor1GrennLbl
            }
        }
    }
    
    var textForSecondTitle: String? {
        didSet {
            if let textForSecondTitle {
                secondTitle.text = textForSecondTitle
            }
        }
    }
    
    var nameImgForBg: String? {
        didSet {
            if let nameImgForBg {
                bgImage1.image = UIImage(named: nameImgForBg)
            }
        }
    }
    
    enum Onb {
        case first
        case second
        case fird
    }
    
    var onb: Onb?
    
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
        view.image = UIImage(named: "new_onb_1")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var simpleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 400
        return view
    }()
    
    private lazy var firsTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-SemiBold", size: 24)
        view.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var firsTitleGreen: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font =  UIFont(name: "Poppins-SemiBold", size: 24)
        view.textColor = #colorLiteral(red: 0.5592492223, green: 0.7865967155, blue: 0.3077450097, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var secondTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "get_species_and_tips".localized
        view.font = UIFont(name: "Poppins-Regular", size: 16)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.8)
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
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(
            UIImage(named: "my_plants_btnn"),
            for: .normal
        )
        view.setTitle(
            "continue".localized,
            for: .normal
        )
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
        view.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
                self.actionHandler(.cont)
            }),
            for: .touchUpInside
        )
        view.widthAnchor ~= 244
        view.heightAnchor ~= 70
        return view
    }()
    
    private lazy var downBut1: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let title = "privacy_policy".localized
        let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 0.114, green: 0.235, blue: 0.169, alpha: 1),
                .font: UIFont(name: "Poppins-SemiBold", size: 12)!,
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
                .font: UIFont(name: "Poppins-SemiBold", size: 12)!,
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
                .font: UIFont(name: "Poppins-SemiBold", size: 12)!,
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
        backgroundColor = #colorLiteral(red: 0.7842256427, green: 0.9258164763, blue: 0.7627684474, alpha: 1)
        addSubview(bgImage1)
        addSubview(simpleView)
        simpleView.backgroundColor = #colorLiteral(red: 0.8673231006, green: 0.9678226113, blue: 0.8579294682, alpha: 1)
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
        bgImage1.centerXAnchor ~= centerXAnchor
        
        switch onb {
        case .first:
            bgImage1.widthAnchor ~= 500
            bgImage1.heightAnchor ~= 650
            bgImage1.centerYAnchor ~= centerYAnchor - 150
        case .second:
            bgImage1.widthAnchor ~= 500
            bgImage1.heightAnchor ~= 650
            bgImage1.centerYAnchor ~= centerYAnchor - 30
        case .fird:
            bgImage1.widthAnchor ~= 490
            bgImage1.heightAnchor ~= 930
            bgImage1.centerYAnchor ~= centerYAnchor - 30
        case .none:
            break
        }
        
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
//        secondTitle.centerXAnchor ~= simpleView.centerXAnchor
        secondTitle.leftAnchor ~= leftAnchor + 20
        secondTitle.rightAnchor ~= rightAnchor - 20
        
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
