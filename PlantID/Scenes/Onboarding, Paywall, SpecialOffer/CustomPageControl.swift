//
//  CustomPageControl.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 7.07.25.
//

import UIKit

class CustomPageControl: View {
    
    private var widthConstraints: [NSLayoutConstraint] = []
    private var heightConstraints: [NSLayoutConstraint] = []

    
    private var dots: [UIImageView] = []
    
    var numberOfPages = 0 {
        didSet { setupDots() }
    }
    var currentPage = 1 {
        didSet { updateDots() }
    }
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .center
        return view
    }()
    
    override func setupContent() {
        addSubview(stack)
    }
    
    override func setupLayout() {
        stack.pinToSuperview()
    }
    
    private func setupDots() {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        dots = []
        widthConstraints = []
        heightConstraints = []

        for i in 0..<numberOfPages {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.image = (i == currentPage) ? UIImage(named: "green1") : UIImage(named: "green2")
            
            stack.addArrangedSubview(imageView)
            dots.append(imageView)

            // Добавляем constraints
            let width = imageView.widthAnchor.constraint(equalToConstant: i == currentPage ? 10 : 6)
            let height = imageView.heightAnchor.constraint(equalToConstant: i == currentPage ? 10 : 6)
            width.isActive = true
            height.isActive = true

            widthConstraints.append(width)
            heightConstraints.append(height)
        }
    }
    
    private func updateDots() {
        for (i, imageView) in dots.enumerated() {
            if i == currentPage {
                imageView.image = UIImage(named: "green1")
                widthConstraints[i].constant = 10
                heightConstraints[i].constant = 10
            } else {
                imageView.image = UIImage(named: "green2")
                widthConstraints[i].constant = 6
                heightConstraints[i].constant = 6
            }
        }
    }
}

