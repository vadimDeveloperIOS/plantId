//
//  UIVC + UITF + UILabel + UIColor + UIFont.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit


extension UIImage {
    static var mainBackgroundImage = UIImage(named: "mainBackground")
}

extension UIColor {
    static var tabBarBackgroundColor = UIColor(hex: "#FFFFFF")
    static var descriptionTextColor = UIColor(hex: "#3B403BBD")
    static var labelTextColor = UIColor(hex: "#111411")
    static var labelTextBlackColor = UIColor(hex: "##131114")

}

extension UIFont {
    static var onest12SemiBold = UIFont(name: "Onest-SemiBold", size: 12)
    static var onest14SemiBold = UIFont(name: "Onest-SemiBold", size: 14)
    static var onest16SemiBold = UIFont(name: "Onest-SemiBold", size: 16)
    static var onest10Regular = UIFont(name: "Onest-Regular", size: 10)
}

extension UIView {
    
    func setMainBgGradient() {
        let color1 = UIColor(hex: "#B7E4C2")
        let color2 = UIColor(hex: "#F8F8F8")
        
        if let color1, let color2 {
            backgroundGradient = .init(
                colors: [color1, color2, color2, color2, color2]
            )
        }
    }
    
    func setBgGradientAndBorderForCell() {
        let color1 = UIColor.white
        let color2 = #colorLiteral(red: 0.8928951621, green: 0.9733288884, blue: 0.9007312655, alpha: 1)
        
        backgroundGradient =
            .init( colors: [color1, color2] )
        
        layer.borderWidth = 0.5
        layer.borderColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    }
}

extension UIViewController {
    
    
    // скрыть клавиатуру
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {
    func enableReturnKeyToDismissKeyboard() {
        returnKeyType = .search
        addTarget(self, action: #selector(dismissKeyboard), for: .editingDidEndOnExit)
    }

    @objc private func dismissKeyboard() {
        resignFirstResponder()
    }
}

