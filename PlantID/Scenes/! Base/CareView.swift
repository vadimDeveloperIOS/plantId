//
//  CareView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 29.08.25.
//

import UIKit

final class CareView: View {
    
    private let filledColor   = #colorLiteral(red: 0.136728853, green: 0.3129242063, blue: 0.06877711415, alpha: 1)
    private let unfilledColor = #colorLiteral(red: 0.5067764521, green: 0.602879405, blue: 0.4750113487, alpha: 1)
    
    var bigView: Bool = false
    
    var careValue: Int? {
        didSet {
            applyTint()
        }
    }
    
    private lazy var images: [UIImageView] = (0..<4).map { _ in
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "r_home_kapla")?.withRenderingMode(.alwaysTemplate)
        iv.contentMode = .scaleAspectFill
        iv.tintColor = unfilledColor
        
        if bigView == true {
            iv.widthAnchor ~= 16
            iv.heightAnchor ~= 16
        }
        else if bigView == false {
            iv.widthAnchor ~= 11
            iv.heightAnchor ~= 11
        }
        return iv
    }
    
    private lazy var hStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillEqually
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = .init(top: 0, leading: 6, bottom: 0, trailing: 6)
        return view
    }()
    
    override func setupContent() {
        backgroundColor = #colorLiteral(red: 0.830952704, green: 0.9365895391, blue: 0.7739595771, alpha: 1)
        
//        if bigView == true {
//            widthAnchor ~= 63
//            heightAnchor ~= 18
//            layer.cornerRadius = 6
//        }
//        else if bigView == false {
//
//        }
        
        addSubview(hStack)
        images.forEach { hStack.addArrangedSubview($0) }
        applyTint()
    }
    
    override func setupLayout() {
        hStack.pinToSuperview()
    }
    
    private func applyTint() {
        let value = max(0, min(careValue ?? 0, images.count))
        for (idx, img) in images.enumerated() {
            img.tintColor = idx < value ? filledColor : unfilledColor
        }
    }
}
