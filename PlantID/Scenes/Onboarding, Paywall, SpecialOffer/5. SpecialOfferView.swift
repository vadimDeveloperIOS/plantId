//
//  SpecialOfferView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 8.07.25.
//

import UIKit

final class SpecialOfferView: View {
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    var min: Int? {
        didSet {
            guard let min else { return }
            ramka1.timeVal = min
        }
    }
    
    var sec: Int? {
        didSet {
            guard let sec else { return }
            ramka2.timeVal = sec
        }
    }
    
    var mil: Int? {
        didSet {
            guard let mil else { return }
            ramka3.timeVal = mil
        }
    }
    
    enum Action {
        case cont
        case cancel
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    private lazy var bgImage1: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "sale_new")
        view.contentMode = .scaleAspectFill
        view.widthAnchor ~= 450
        view.heightAnchor ~= 900
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
        view.text = "exclusive_deal".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-SemiBold", size: 24)
        view.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var firsTitleGreen: UILabel = {
        let view = UILabel()
        view.text = "seize_the_opportunity".localized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-SemiBold", size: 24)
        view.textColor = #colorLiteral(red: 0.5592492223, green: 0.7865967155, blue: 0.3077450097, alpha: 1)
        view.textAlignment = .center
        return view
    }()
    
    private lazy var ramka1: TimeCell = {
        let view = TimeCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.har = "min"
        view.widthAnchor ~= 50
        view.heightAnchor ~= 50
        return view
    }()
    
    private lazy var tochki1: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "2tochki")
        view.contentMode = .scaleAspectFill
        view.widthAnchor ~= 4
        view.heightAnchor ~= 50
        return view
    }()
    
    private lazy var ramka2: TimeCell = {
        let view = TimeCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.har = "sec"
        view.widthAnchor ~= 50
        view.heightAnchor ~= 50
        return view
    }()
    
    private lazy var tochki2: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "2tochki")
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 4
        view.heightAnchor ~= 50
        return view
    }()

    private lazy var ramka3: TimeCell = {
        let view = TimeCell()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.har = "mil"
        view.widthAnchor ~= 50
        view.heightAnchor ~= 50
        return view
    }()
    
    private lazy var secondTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "start_now_at".localized
        view.font = UIFont(name: "Poppins-Regular", size: 16)
        view.textColor = .black
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
            "grab_it_now".localized,
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
    
    private lazy var button2: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let title = "cancel_anytime".localized
        let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 1),
                .font: UIFont(name: "Onest-Regular", size: 16)!,
            ]
        let attributed = NSAttributedString(string: title, attributes: attributes)
        view.setAttributedTitle(attributed, for: .normal)
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                       self.actionHandler(.cancel)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
   
    override func setupContent() {
        backgroundColor = #colorLiteral(red: 0.7791945934, green: 0.9259548783, blue: 0.7584420443, alpha: 1)
        addSubview(bgImage1)
        addSubview(simpleView)
        simpleView.backgroundColor = #colorLiteral(red: 0.9613817334, green: 1, blue: 0.953127563, alpha: 1)
        simpleView.addSubview(firsTitle)
        simpleView.addSubview(firsTitleGreen)
        simpleView.addSubview(ramka2)
        simpleView.addSubview(tochki1)
        simpleView.addSubview(tochki2)
        simpleView.addSubview(ramka1)
        simpleView.addSubview(ramka3)
        simpleView.addSubview(secondTitle)
        simpleView.addSubview(pageControl)
        simpleView.addSubview(button)
        simpleView.addSubview(button2)
    }
    
    override func setupLayout() {
        bgImage1.centerYAnchor ~= centerYAnchor + 5
        bgImage1.centerXAnchor ~= centerXAnchor
        
        simpleView.leftAnchor ~= leftAnchor
        simpleView.rightAnchor ~= rightAnchor
        simpleView.bottomAnchor ~= bottomAnchor
        
        firsTitle.topAnchor ~= simpleView.topAnchor + 70
        firsTitle.centerXAnchor ~= simpleView.centerXAnchor
        
        firsTitleGreen.topAnchor ~= firsTitle.bottomAnchor + 7
        firsTitleGreen.centerXAnchor ~= simpleView.centerXAnchor
        
        ramka2.centerXAnchor ~= simpleView.centerXAnchor
        ramka2.topAnchor ~= firsTitleGreen.bottomAnchor + 10
        
        tochki1.centerYAnchor ~= ramka2.centerYAnchor
        tochki1.rightAnchor ~= ramka2.leftAnchor - 10
        
        tochki2.centerYAnchor ~= ramka2.centerYAnchor
        tochki2.leftAnchor ~= ramka2.rightAnchor + 10
        
        ramka1.centerYAnchor ~= ramka2.centerYAnchor
        ramka1.rightAnchor ~= tochki1.leftAnchor - 10
        
        ramka3.centerYAnchor ~= ramka2.centerYAnchor
        ramka3.leftAnchor ~= tochki2.rightAnchor + 10
        
        secondTitle.topAnchor ~= ramka2.bottomAnchor + 10
        secondTitle.centerXAnchor ~= simpleView.centerXAnchor
        
        pageControl.topAnchor ~= secondTitle.bottomAnchor + 8
        pageControl.centerXAnchor ~= simpleView.centerXAnchor
        
        button.topAnchor ~= pageControl.bottomAnchor + 12
        button.centerXAnchor ~= simpleView.centerXAnchor
        
        button2.topAnchor ~= button.bottomAnchor + 3
        button2.centerXAnchor ~= simpleView.centerXAnchor
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


final class TimeCell: View {
    var timeVal: Int? {
        didSet {
            guard let timeVal else { return }
            timeLbl.text = String(timeVal)
        }
    }
    
    var har: String? {
        didSet {
            guard let har else { return }
            harLbl.text = har
        }
    }
    
    private lazy var ramka: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "ramka")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var timeLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = #colorLiteral(red: 0.2794816494, green: 0.5914724469, blue: 0.1613161862, alpha: 1)
        view.font = UIFont(name: "Poppins-Bold", size: 28)
        return view
    }()
    
    private lazy var harLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font = UIFont(name: "Poppins-Regular", size: 8)
        return view
    }()
    
    override func setupContent() {
        backgroundColor = .white
        addSubview(ramka)
        ramka.addSubview(timeLbl)
        ramka.addSubview(harLbl)
    }
    
    override func setupLayout() {
        ramka.pinToSuperview()
        
        timeLbl.centerXAnchor ~= ramka.centerXAnchor
        timeLbl.centerYAnchor ~= ramka.centerYAnchor - 5
        
        harLbl.centerXAnchor ~= ramka.centerXAnchor
        harLbl.bottomAnchor ~= ramka.bottomAnchor - 2
    }
}
