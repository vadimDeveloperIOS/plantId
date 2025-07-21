//
//  MyPlansForSectionView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit

final class MyPlantsViewCell: UICollectionViewCell {
    
    var viewModel: MyPlantsCellContentView.Model {
        get {
            cellContentView.viewModel ?? .init()
        }
        set {
            cellContentView.viewModel = newValue
        }
    }
    
    var actionHandler: (MyPlantsCellContentView.Action) -> Void {
        get {
            cellContentView.actionHandler
        }
        set {
            cellContentView.actionHandler = newValue
        }
    }
    
    private lazy var cellContentView: MyPlantsCellContentView = {
        let view = MyPlantsCellContentView()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

// сделать разные классы для отображения двух вариантов (с фото растения и с заглушкой)


// MyPlantsCellContentView
final class MyPlantsCellContentView: View {
    
    enum RateWatering {
        case reraly
        case normal
        case often
    }
    
    enum Action {
        case click
    }
    
    var actionHandler: (Action) -> Void = { _ in }
    
    struct Model: Hashable {
        var plantImage: String?
        var plantName: String?
        var plantDescription: String?
        var rateWatering: RateWatering?
        var hasImage: Bool?
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            plantImage.image = UIImage(named: viewModel.plantImage ?? "not.plant.1")

            currectView.viewModel = .init(
                name: viewModel.plantName,
                description: viewModel.plantDescription
            )
        }
    }
    
    private let currectView: CurrectView = {
        let view = CurrectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true // тут обрезаем края
        return view
    }()
    
    private let plantImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func setupContent() {
        backgroundColor = .clear // важный момент — не обрезаем тут
        
        addSubview(currectView)
        addSubview(plantImage)
        
        currectView.backgroundColor = .white
        currectView.layer.cornerRadius = 16
        currectView.clipsToBounds = true
    }
    
    override func setupLayout() {
        currectView.pinToSuperview()
        
        plantImage.widthAnchor ~= 100
        plantImage.heightAnchor ~= 100
        plantImage.rightAnchor ~= rightAnchor - 6
        plantImage.topAnchor ~= topAnchor - 35
    }
}

//MARK: TopPartContentView
private final class CurrectView: View {
    
    struct Model: Hashable {
        var name: String?
        var description: String?
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            plantNameLabel.text = viewModel.name
            plantDescriptionLabel.text = viewModel.description
        }
    }
    
    private lazy var plantNameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-SemiBold", size: 12)
        view.textColor = UIColor(hex: "#FFFFFF")
        view.contentMode = .right
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var plantDescriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Regular", size: 10)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.numberOfLines = 0
        return view
    }()
   
    private lazy var rateWateringImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "copcop")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var greenView: View = {
        let view = View()
        view.translatesAutoresizingMaskIntoConstraints = false
        let col1 = UIColor(hex: "#8FDB85")
        let col2 = UIColor(hex: "#117C02")
        if let col1, let col2 {
            view.backgroundGradient = .init(colors: [col1, col2])
        }
        return view
    }()
    
    override func setupContent() {
        let col1: UIColor = .white
        let col2 = UIColor(hex: "#B7E4C2")

        if let col2 {
            backgroundGradient = .init(colors: [ col1, col2])
        }
        addSubview(greenView)
        addSubview(plantNameLabel)
        addSubview(plantDescriptionLabel)
        addSubview(rateWateringImage)
        
        greenView.layer.cornerRadius = 43
        greenView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        greenView.layer.masksToBounds = true
    }
    
    override func setupLayout() {
                
        greenView.topAnchor ~= topAnchor
        greenView.leftAnchor ~= leftAnchor
        greenView.rightAnchor ~= rightAnchor
        greenView.heightAnchor ~= 72
        
        plantNameLabel.widthAnchor ~= 106
        plantNameLabel.leftAnchor ~= leftAnchor + 10
        plantNameLabel.bottomAnchor ~= greenView.bottomAnchor - 5
        
        plantDescriptionLabel.topAnchor ~= greenView.bottomAnchor - 19
        plantDescriptionLabel.rightAnchor ~= rightAnchor - 10
        plantDescriptionLabel.leftAnchor ~= leftAnchor + 10
        plantDescriptionLabel.bottomAnchor ~= bottomAnchor - 15
        
        rateWateringImage.widthAnchor ~= 32
        rateWateringImage.heightAnchor ~= 32
        rateWateringImage.leftAnchor ~= leftAnchor + 10
        rateWateringImage.bottomAnchor ~= bottomAnchor - 10
    }
}



