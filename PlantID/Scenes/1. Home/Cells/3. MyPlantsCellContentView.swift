//
//  MyPlansCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit

/// ----------------------------------------------
// MARK: - CELL
/// ----------------------------------------------

final class MyPlansCell: UICollectionViewCell {
    
    var viewModel: MyPlansCellContent.Model? {
        didSet {
            if let viewModel {
                cellContentView.viewModel = viewModel
            }
        }
    }
    
    private lazy var cellContentView: MyPlansCellContent = {
        let view = MyPlansCellContent()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

/// ----------------------------------------------
// MARK: - CONTENT
/// ----------------------------------------------


final class MyPlansCellContent: BaseCell {
    
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
        }
    }
    
    private lazy var photo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor ~= 90
        view.heightAnchor ~= 90
        view.layer.cornerRadius = 16
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
        addSubview(photo)
        addSubview(firstLbl)
        addSubview(secondLbl)
        addSubview(careView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        photo.centerYAnchor ~= centerYAnchor
        photo.rightAnchor ~= rightAnchor - 10
        
        firstLbl.topAnchor ~= topAnchor + 10
        firstLbl.leftAnchor ~= leftAnchor + 10
        
        secondLbl.topAnchor ~= firstLbl.bottomAnchor + 15
        secondLbl.leftAnchor ~= firstLbl.leftAnchor
        
        careView.topAnchor ~= secondLbl.bottomAnchor + 10
        careView.leftAnchor ~= firstLbl.leftAnchor
    }
}
