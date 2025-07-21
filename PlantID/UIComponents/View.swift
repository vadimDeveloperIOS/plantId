//
//  View.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit

open class View: UIView {
    open func setupContent() {
    }

    open func setupLayout() {
    }

    public init() {
        super.init(frame: .zero)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setupContent()
        subviews.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        setupLayout()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
}
