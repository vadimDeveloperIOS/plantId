//
//  Cell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 10.09.25.
//

import UIKit

/// ----------------------------------------------
// MARK: - CELL
/// ----------------------------------------------

final class CellForMyPlants: UICollectionViewCell {
    
    var viewModel: ContentForMyPlants.BigCellModel? {
        didSet {
            cellContentView.bigCellViewModel = viewModel
        }
    }
    
    var actionHandler: (ContentForMyPlants.Action) -> Void {
        get {
            cellContentView.actionHandler
        }
        set {
            cellContentView.actionHandler = newValue
        }
    }
    
    private lazy var cellContentView: ContentForMyPlants = {
        let view = ContentForMyPlants()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

/// ----------------------------------------------
// MARK: - CONTENT
/// ----------------------------------------------

final class ContentForMyPlants: BaseBigCell {
    
    enum Action {
        case viewAll
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    override var bigCellViewModel: BigCellModel? {
        didSet {
            super.bigCellViewModel = bigCellViewModel
            
            if let careVal = bigCellViewModel?.carePlan {
                careView.careValue = careVal
            }
        }
    }

    private lazy var careView: CareView = {
        let view = CareView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bigView = true
        view.widthAnchor ~= 83
        view.heightAnchor ~= 24
        view.layer.cornerRadius = 12
        return view
    }()
        
    private lazy var viewAllBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let title = TextForHomeScene.viewAll
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Poppins-Medium", size: 14)!,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributed = NSAttributedString(string: title, attributes: attributes)
        view.setAttributedTitle(attributed, for: .normal)
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.viewAll)
                }
            )
            , for: .touchUpInside
        )
        view.widthAnchor ~= 83
        view.heightAnchor ~= 30
        return view
    }()
    
    override func setupContent() {
        super.setupContent()
        backgroundColor = ColorsForHomeScene.colorsForHistory.randomElement()
        layer.cornerRadius = 20
        addSubview(careView)
        addSubview(viewAllBtn)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        careView.topAnchor ~= secondLbl.bottomAnchor + 15
        careView.leftAnchor ~= secondLbl.leftAnchor
    
        viewAllBtn.centerYAnchor ~= careView.centerYAnchor
        viewAllBtn.rightAnchor ~= rightAnchor - 15
    }
}

