//
//  BaseBigCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 29.08.25.
//

import UIKit

class BaseBigCell: BaseCell {
    
    enum CellStyle {
        case homeLearnAboutPlants
        case homeHistory
    }
    
    struct BigCellModel: Hashable {
        let photo: UIImage
        let firstText: String
        let secondText: String
        let cellStyle: CellStyle
    }
    
    var bigCellViewModel: BigCellModel? {
        didSet {
            guard let bigCellViewModel else { return }
            photo.image = bigCellViewModel.photo
            firstLbl.text = bigCellViewModel.firstText
            secondLbl.text = bigCellViewModel.secondText
            cellStyle = bigCellViewModel.cellStyle
        }
    }
    
    var cellStyle: CellStyle? {
        didSet {
            guard let cellStyle else { return }
            switch cellStyle {
            case .homeLearnAboutPlants:
                secondLbl.numberOfLines = 3
            case .homeHistory:
                secondLbl.numberOfLines = 2
            }
        }
    }
    
    private(set) lazy var photo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.widthAnchor ~= 95
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private(set) lazy var firstLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 1)
        view.font = UIFont(name: "Poppins-Medium", size: 14)
        view.textAlignment = .left
        view.numberOfLines = 1
        return view
    }()

    private(set) lazy var secondLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 0.7)
        view.font = UIFont(name: "Poppins-Regular", size: 12)
        view.textAlignment = .left
        view.numberOfLines = 2
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
        photo.leftAnchor ~= leftAnchor + 18
        photo.topAnchor ~= topAnchor + 10
        photo.bottomAnchor ~= bottomAnchor - 10
        
        firstLbl.topAnchor ~= photo.topAnchor
        firstLbl.leftAnchor ~= photo.rightAnchor + 18
        firstLbl.rightAnchor ~= rightAnchor - 16
        
        secondLbl.topAnchor ~= firstLbl.bottomAnchor + 6
        secondLbl.leftAnchor ~= firstLbl.leftAnchor
        secondLbl.rightAnchor ~= rightAnchor - 10
    }
}
