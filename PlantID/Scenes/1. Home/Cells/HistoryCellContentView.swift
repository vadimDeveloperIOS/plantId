//
//  HistoryCellContentView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit

final class HistoryViewCell: UICollectionViewCell {
    
    var viewModel: HistoryCellContentView.Model {
        get {
            cellContentView.viewModel ?? .init()
        }
        set {
            cellContentView.viewModel = newValue
        }
    }
    
    var actionHandler: (HistoryCellContentView.Action) -> Void {
        get {
            cellContentView.actionHandler
        }
        set {
            cellContentView.actionHandler = newValue
        }
    }
    
    private lazy var cellContentView: HistoryCellContentView = {
        let view = HistoryCellContentView()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
    
}

final class HistoryCellContentView: View {
    
    enum Action {
        case addToMyPlants
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    struct Model: Hashable {
        var name: String?
        var description: String?
        var image: String?
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            plantImage.image = UIImage(named: viewModel.image ?? "not.plant.3")
            
            content.viewModel = .init(
                name: viewModel.name,
                description: viewModel.description
            )
        }
    }
    
    private let content: CurrectViewForHistory = {
        let view = CurrectViewForHistory()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true // тут обрезаем края
        return view
    }()
    
    private let plantImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override func setupContent() {
        backgroundColor = .clear // важный момент — не обрезаем тут
        
        addSubview(content)
        addSubview(plantImage)
        
        content.backgroundColor = .white
        content.layer.cornerRadius = 16
        content.clipsToBounds = true
    }
    
    override func setupLayout() {
        content.pinToSuperview()
        
        plantImage.widthAnchor ~= 115
        plantImage.heightAnchor ~= 100
        plantImage.leftAnchor ~= leftAnchor + 2
        plantImage.bottomAnchor ~= bottomAnchor - 40
    }
}

// HistoryCellContentView
final class CurrectViewForHistory: View {
    
    enum Action {
        case addToMyPlants
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    struct Model: Hashable {
        var name: String?
        var description: String?
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            nameLabel.text = viewModel.name
            descriptionLabel.text = viewModel.description
        }
    }

    private let nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 14)
        view.textColor = .labelTextBlackColor
        view.contentMode = .left
        return view
    }()

    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Regular", size: 10)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.contentMode = .left
        view.numberOfLines = 0
        return view
    }()
    
    private let addLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 14)
        view.textColor = UIColor(hex: "#117C02")
        view.text = "add_to_my_plants".localized
        view.contentMode = .left
        return view
    }()
    
    private let addButton: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "green.plus"), for: .normal)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func setupContent() {
        let col1 = UIColor(hex: "#FFFFFF")
        let col2 = UIColor(hex: "#C6F0CC")
        
        if let col1, let col2 {
            backgroundGradient = .init(
                colors: [col1, col1, col2]
            )
        }
        
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        layer.borderWidth = 0.5
        layer.borderColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(addButton)
        addSubview(addLabel)
    }
    
    override func setupLayout() {
        
        nameLabel.topAnchor ~= topAnchor + 15
        nameLabel.leftAnchor ~= leftAnchor + 130
        
        descriptionLabel.topAnchor ~= nameLabel.bottomAnchor + 10
        descriptionLabel.leftAnchor ~= leftAnchor + 130
        descriptionLabel.rightAnchor ~= rightAnchor - 10
        
        addButton.widthAnchor ~= 32
        addButton.heightAnchor ~= 32
        addButton.rightAnchor ~= rightAnchor - 12
        addButton.topAnchor ~= descriptionLabel.bottomAnchor + 10
        
        addLabel.rightAnchor ~= addButton.leftAnchor - 10
        addLabel.centerYAnchor ~= addButton.centerYAnchor
    }
}
