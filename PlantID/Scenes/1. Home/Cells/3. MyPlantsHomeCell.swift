//
//  MyPlantsHomeCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit

/// ----------------------------------------------
// MARK: - CELL
/// ----------------------------------------------

final class MyPlantsHomeCell: UICollectionViewCell {
    
    var viewModel: MyPlantsCellContent.Model? {
        didSet {
            if let viewModel {
                cellContentView.viewModel = viewModel
            }
        }
    }
    
    private lazy var cellContentView: MyPlantsCellContent = {
        let view = MyPlantsCellContent()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

/// ----------------------------------------------
// MARK: - CONTENT
/// ----------------------------------------------


final class MyPlantsCellContent: BaseCell {
    
    struct Model: Hashable {
        var image: UIImage
        var name: String
        var carePlan: Int
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            photo.image = viewModel.image
            firstLbl.text = viewModel.name
            careView.careValue = viewModel.carePlan
        }
    }
    
    private lazy var photo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor ~= 70
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 9
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var firstLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 1)
        view.font = UIFont(name: "Poppins-Medium", size: 16)
        view.textAlignment = .left
        view.numberOfLines = 2
        view.widthAnchor ~= 90
        return view
    }()

    private lazy var secondLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = TextForHomeScene.carePlan
        view.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 0.8)
        view.font = UIFont(name: "Poppins-Regular", size: 10)
        view.textAlignment = .left
        return view
    }()
    
    private lazy var careView: CareView = {
        let view = CareView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bigView = false
        return view
    }()
     
    override func setupContent() {
        super.setupContent()
        backgroundColor = ColorsForHomeScene.colorsForMyPlants.randomElement()
        layer.cornerRadius = 20
        
        addSubview(photo)
        addSubview(firstLbl)
        addSubview(secondLbl)
        addSubview(careView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        photo.topAnchor ~= topAnchor + 10
        photo.bottomAnchor ~= bottomAnchor - 10
        photo.rightAnchor ~= rightAnchor - 10
        
        firstLbl.topAnchor ~= topAnchor + 10
        firstLbl.leftAnchor ~= leftAnchor + 12
        firstLbl.rightAnchor ~= photo.leftAnchor - 2
        
        careView.bottomAnchor ~= bottomAnchor - 12
        careView.leftAnchor ~= firstLbl.leftAnchor
        careView.widthAnchor ~= 63
        careView.heightAnchor ~= 18
        careView.layer.cornerRadius = 9
        
        secondLbl.bottomAnchor ~= careView.topAnchor - 10
        secondLbl.leftAnchor ~= firstLbl.leftAnchor
    }
}
