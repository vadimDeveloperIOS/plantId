//
//  MyplantsN.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 7.09.25.
//

import UIKit

final class MyplantsN: BaseViewWithNavigationBarGreen {
    
    enum ActionChild {
        case enableCamera
    }
    var actionHandlerChild: (Action) -> Void = { _ in }
    
    private(set) lazy var firstLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = TextForMyplantsScene.hello
        view.textColor = .black
        view.font = UIFont(name: "Poppins-SemiBold", size: 22)
        view.textAlignment = .center
        view.numberOfLines = 1
        return view
    }()

    private(set) lazy var secondLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = TextForMyplantsScene.yourPlants
        view.textColor = #colorLiteral(red: 0.5592492223, green: 0.7865967155, blue: 0.3077450097, alpha: 1)
        view.font = UIFont(name: "Poppins-SemiBold", size: 22)
        view.textAlignment = .center
        view.numberOfLines = 1
        return view
    }()
    
    private(set) lazy var thirdLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.font =  UIFont(name: "Poppins-Regular", size: 14)
        view.textAlignment = .center
        view.numberOfLines = 1
        return view
    }()

    private lazy var bg: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "my_plants_bgg")
        return view
    }()
    
    private lazy var btn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(
            UIImage(named: "my_plants_btnn"),
            for: .normal
        )
        view.setTitle(
            TextForMyplantsScene.enableCamera,
            for: .normal
        )
        view.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
        view.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
            }),
            for: .touchUpInside
        )
        view.widthAnchor ~= 244
        view.heightAnchor ~= 44
        return view
    }()
    
    override func setupContent() {
        super.setupContent()
        addSubview(bg)
        addSubview(firstLbl)
        addSubview(secondLbl)
        addSubview(thirdLbl)
        addSubview(btn)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        bg.centerXAnchor ~= centerXAnchor
        bg.centerYAnchor ~= centerYAnchor
        
        firstLbl.topAnchor ~= greenNabBg.bottomAnchor + 30
        firstLbl.centerXAnchor ~= centerXAnchor
        
        secondLbl.topAnchor ~= firstLbl.bottomAnchor + 5
        secondLbl.centerXAnchor ~= centerXAnchor
        
        thirdLbl.topAnchor ~= secondLbl.bottomAnchor + 10
        thirdLbl.centerXAnchor ~= centerXAnchor
        
        btn.bottomAnchor ~= bottomAnchor - 80
        btn.centerXAnchor ~= centerXAnchor
    }
}
