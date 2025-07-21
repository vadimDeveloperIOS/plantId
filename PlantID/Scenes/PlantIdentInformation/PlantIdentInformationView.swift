//
//  PlantIdentInformationView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit

final class PlantIdentInformationView: View {
    
    enum Action {
        case back
        case getInformation
        case enableCamera
    }
    var actionHandler: (Action) -> Void = { _ in }

    // back button
    // information button
    
    private let welcomeLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .labelTextBlackColor
        return view
    }()
    
    private let infLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .descriptionTextColor
        return view
    }()
    
    private let image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let button: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let firstStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let secondStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupContent() {
        // bg
        addSubview(secondStackView)
        secondStackView.addSubview(button)
        secondStackView.addSubview(firstStackView)
        firstStackView.addSubview(welcomeLabel)
        firstStackView.addSubview(infLabel)
        firstStackView.addSubview(image)
    }
    
    override func setupLayout() {
        
    }
}
