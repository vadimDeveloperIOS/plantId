//
//  UIView+BackgroundGradient.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit
import ObjectiveC

private var gradientLayerKey: UInt8 = 0

public extension UIView {

    /// Градиентная настройка
    struct GradientConfig {
        public var colors: [UIColor]
        public var startPoint: CGPoint
        public var endPoint: CGPoint

        public init(colors: [UIColor],
                    startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
                    endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) {
            self.colors = colors
            self.startPoint = startPoint
            self.endPoint = endPoint
        }
    }

    /// Настройка градиента
    var backgroundGradient: GradientConfig? {
        get {
            guard let gradient = objc_getAssociatedObject(self, &gradientLayerKey) as? CAGradientLayer else {
                return nil
            }
            let colors = (gradient.colors as? [CGColor])?.compactMap { UIColor(cgColor: $0) } ?? []
            return GradientConfig(colors: colors, startPoint: gradient.startPoint, endPoint: gradient.endPoint)
        }
        set {
            gradientLayer?.removeFromSuperlayer()
            gradientLayer = nil

            guard let config = newValue else { return }

            let gradient = CAGradientLayer()
            gradient.colors = config.colors.map { $0.cgColor }
            gradient.startPoint = config.startPoint
            gradient.endPoint = config.endPoint
            layer.insertSublayer(gradient, at: 0)
            gradientLayer = gradient

            // сразу обновляем размер
            setNeedsLayout()
        }
    }

    /// Обновление фрейма градиента при layout
    func updateGradientFrame() {
        gradientLayer?.frame = bounds
    }

    private var gradientLayer: CAGradientLayer? {
        get { objc_getAssociatedObject(self, &gradientLayerKey) as? CAGradientLayer }
        set { objc_setAssociatedObject(self, &gradientLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

