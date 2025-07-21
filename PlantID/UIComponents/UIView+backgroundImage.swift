//
//  UIView+backgroundImage.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit
import ObjectiveC.runtime

fileprivate var backgroundImageViewKey: UInt8 = 0

extension UIView {
    
    private var backgroundImageView: UIImageView? {
        get {
            return objc_getAssociatedObject(self, &backgroundImageViewKey) as? UIImageView
        }
        set {
            objc_setAssociatedObject(self, &backgroundImageViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var backgroundImage: UIImage? {
        get {
            return backgroundImageView?.image
        }
        set {
            if let image = newValue {
                // Если UIImageView уже есть — просто обновим
                if let bgView = backgroundImageView {
                    bgView.image = image
                    return
                }
                
                // Создаём и настраиваем новый
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFill
                imageView.translatesAutoresizingMaskIntoConstraints = false
                insertSubview(imageView, at: 0) // ниже всех
                sendSubviewToBack(imageView)
                
                imageView.pinToSuperview()
                
                backgroundImageView = imageView
            } else {
                // Если nil — удалить фон
                backgroundImageView?.removeFromSuperview()
                backgroundImageView = nil
            }
        }
    }
}
