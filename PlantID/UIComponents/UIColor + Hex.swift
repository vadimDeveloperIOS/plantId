//
//  UIColor + Hex.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit

extension UIColor {
    
    /// Создание UIColor из HEX-строки (например, "#FF00FF" или "FF00FF")
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }
        
        guard hexSanitized.count == 6,
              let rgbValue = UInt64(hexSanitized, radix: 16) else {
            return nil
        }
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255
        let blue = CGFloat(rgbValue & 0x0000FF) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /// Преобразование UIColor в UIImage заданного размера (по умолчанию 1x1)
    func toImage(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
