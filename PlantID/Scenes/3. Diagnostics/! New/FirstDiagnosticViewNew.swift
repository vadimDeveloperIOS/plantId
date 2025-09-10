//
//  FirstDiagnosticViewNew.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 10.09.25.
//

import UIKit

final class FirstDiagnosticViewNew: BaseViewWithNavigationBarGreen {
    
    enum ActionChild {
        case cont
    }
    var actionHandlerChild: (ActionChild) -> Void = { _ in }
    
    private(set) lazy var firstLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = TextForStartDiagnostic.snapTips
        view.textColor = .black
        view.font = UIFont(name: "Poppins-SemiBold", size: 22)
        view.textAlignment = .center
        view.numberOfLines = 1
        return view
    }()

    private(set) lazy var thirdLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = TextForStartDiagnostic.tipsForCapturing
        view.textColor = .black
        view.font =  UIFont(name: "Poppins-Regular", size: 14)
        view.textAlignment = .center
        view.numberOfLines = 1
        return view
    }()
    
    private lazy var st1: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "st_1")
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 400
        view.heightAnchor ~= 180
        
        let lbl1 = UILabel()
        lbl1.translatesAutoresizingMaskIntoConstraints = false
        lbl1.text = TextForStartDiagnostic.step1
        lbl1.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 1)
        lbl1.textAlignment = .left
        lbl1.font = UIFont(name: "Poppins-Medium", size: 20)
        lbl1.numberOfLines = 1
        view.addSubview(lbl1)
        lbl1.centerXAnchor ~= view.centerXAnchor
        lbl1.centerYAnchor ~= view.centerYAnchor - 20
        
        let lbl2 = UILabel()
        lbl2.translatesAutoresizingMaskIntoConstraints = false
        lbl2.text = TextForStartDiagnostic.capturePhotoOf
        lbl2.textColor = .black
        lbl2.textAlignment = .left
        lbl2.font = UIFont(name: "Poppins-Regular", size: 16)
        view.addSubview(lbl2)
        lbl2.numberOfLines = 0
        lbl2.topAnchor ~= lbl1.bottomAnchor + 5
        lbl2.leftAnchor ~= lbl1.leftAnchor
        lbl2.widthAnchor ~= 180
        
        return view
    }()
    
    private lazy var st2: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "st_2")
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 400
        view.heightAnchor ~= 180
        
        let lbl1 = UILabel()
        lbl1.translatesAutoresizingMaskIntoConstraints = false
        lbl1.text = TextForStartDiagnostic.step2
        lbl1.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 1)
        lbl1.textAlignment = .left
        lbl1.font = UIFont(name: "Poppins-Medium", size: 20)
        lbl1.numberOfLines = 2
        view.addSubview(lbl1)
        lbl1.centerXAnchor ~= view.centerXAnchor
        lbl1.centerYAnchor ~= view.centerYAnchor - 20
        
        let lbl2 = UILabel()
        lbl2.translatesAutoresizingMaskIntoConstraints = false
        lbl2.text = TextForStartDiagnostic.focusCloselyOn
        lbl2.textColor = .black
        lbl2.textAlignment = .left
        lbl2.font = UIFont(name: "Poppins-Regular", size: 16)
        view.addSubview(lbl2)
        lbl2.numberOfLines = 0
        lbl2.topAnchor ~= lbl1.bottomAnchor + 5
        lbl2.leftAnchor ~= lbl1.leftAnchor
        lbl2.widthAnchor ~= 180
        
        return view
    }()
    
    private lazy var st3: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "st_3")
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 400
        view.heightAnchor ~= 180
        
        let lbl1 = UILabel()
        lbl1.translatesAutoresizingMaskIntoConstraints = false
        lbl1.text = TextForStartDiagnostic.step3
        lbl1.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 1)
        lbl1.textAlignment = .left
        lbl1.font = UIFont(name: "Poppins-Medium", size: 20)
        lbl1.numberOfLines = 2
        view.addSubview(lbl1)
        lbl1.centerXAnchor ~= view.centerXAnchor
        lbl1.centerYAnchor ~= view.centerYAnchor - 20
        
        let lbl2 = UILabel()
        lbl2.translatesAutoresizingMaskIntoConstraints = false
        lbl2.text = TextForStartDiagnostic.changeTheAngle
        lbl2.textColor = .black
        lbl2.textAlignment = .left
        lbl2.font = UIFont(name: "Poppins-Regular", size: 16)
        view.addSubview(lbl2)
        lbl2.numberOfLines = 0
        lbl2.topAnchor ~= lbl1.bottomAnchor + 5
        lbl2.leftAnchor ~= lbl1.leftAnchor
        lbl2.widthAnchor ~= 200
        
        return view
    }()
    
    private lazy var btn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(
            UIImage(named: "my_plants_btnn"),
            for: .normal
        )
        view.setTitle(
            TextForMyplantsScene.enableCamera,
            for: .normal
        )
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
        view.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
                self.actionHandlerChild(.cont)
            }),
            for: .touchUpInside
        )
        view.widthAnchor ~= 244
        view.heightAnchor ~= 70
        return view
    }()
    
    override func setupContent() {
        super.setupContent()
        needToHideBack = true
        
        addSubview(firstLbl)
        addSubview(thirdLbl)
        addSubview(st1)
        addSubview(st2)
        addSubview(st3)
        addSubview(btn)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        firstLbl.topAnchor ~= greenNabBg.bottomAnchor + 30
        firstLbl.centerXAnchor ~= centerXAnchor
        
        thirdLbl.topAnchor ~= firstLbl.bottomAnchor + 10
        thirdLbl.centerXAnchor ~= centerXAnchor
        
        st1.topAnchor ~= thirdLbl.bottomAnchor
        st1.centerXAnchor ~= centerXAnchor
        
        st2.topAnchor ~= st1.bottomAnchor - 35
        st2.centerXAnchor ~= st1.centerXAnchor
        
        st3.topAnchor ~= st2.bottomAnchor - 35
        st3.centerXAnchor ~= st1.centerXAnchor
        
        btn.bottomAnchor ~= bottomAnchor - 140
        btn.centerXAnchor ~= centerXAnchor + 10
    }
}
