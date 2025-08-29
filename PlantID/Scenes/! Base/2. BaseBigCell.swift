//
//  BaseBigCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 29.08.25.
//

import UIKit

class BaseBigCell: BaseCell {
    
    struct BigCellModel {
        let photo: UIImage
        let firstText: String
        let secondText: String
    }
    
    var bigCellViewModel: BigCellModel? {
        didSet {
            guard let bigCellViewModel else { return }
            photo.image = bigCellViewModel.photo
            firstLbl.text = bigCellViewModel.firstText
            secondLbl.text = bigCellViewModel.secondText
        }
    }
    
    private(set) lazy var photo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor ~= 95
        view.heightAnchor ~= 95
        view.layer.cornerRadius = 16
        return view
    }()
    
    private(set) lazy var firstLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 1)
        view.font = UIFont(name: "Poppins-Medium", size: 14)
        view.textAlignment = .left
        view.numberOfLines = 2
        return view
    }()

    private(set) lazy var secondLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 0.7)
        view.font = UIFont(name: "Poppins-Regular", size: 12)
        view.textAlignment = .left
        view.numberOfLines = 3
        return view
    }()
    
    override func setupContent() {
        super.setupContent()
        
        addSubview(photo)
        addSubview(firstLbl)
        addSubview(secondLbl)
    }
    
    override func setupLayout() {
        super.setupLayout()
        photo.leftAnchor ~= leftAnchor + 16
        photo.topAnchor ~= topAnchor + 10
        photo.centerYAnchor ~= centerYAnchor
        
        firstLbl.topAnchor ~= photo.topAnchor
        firstLbl.leftAnchor ~= photo.rightAnchor + 10
        firstLbl.rightAnchor ~= rightAnchor - 16
        
        secondLbl.topAnchor ~= firstLbl.bottomAnchor + 8
        secondLbl.leftAnchor ~= firstLbl.leftAnchor
        secondLbl.rightAnchor ~= rightAnchor - 10
    }
}
