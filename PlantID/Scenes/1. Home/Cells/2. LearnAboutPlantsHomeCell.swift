//
//  2. LearnAboutPlantsHomeCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 29.08.25.
//

import UIKit

/// ----------------------------------------------
// MARK: - CELL
/// ----------------------------------------------

final class LearnAboutPlantsHomeCell: UICollectionViewCell {
    
    var viewModel: BaseBigCell.BigCellModel? {
        didSet {
            if let viewModel {
                cellContentView.viewModel = viewModel
            }
        }
    }
    
    var actionHandler: (LearnAboutPlantsHomeCellContent.Action) -> Void {
        get {
            cellContentView.actionHandler
        }
        set {
            cellContentView.actionHandler = newValue
        }
    }
    
    private lazy var cellContentView: LearnAboutPlantsHomeCellContent = {
        let view = LearnAboutPlantsHomeCellContent()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

/// ----------------------------------------------
// MARK: - CONTENT
/// ----------------------------------------------


final class LearnAboutPlantsHomeCellContent: BaseBigCell {
    
    enum Action {
        case readMore
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    var viewModel: BaseBigCell.BigCellModel? {
        didSet {
            guard let viewModel else { return}
            bigCellViewModel = viewModel
        }
    }
    
    private lazy var readMoreBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let title = TextForHomeScene.readMore
        let attributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 1),
                .font: UIFont(name: "Poppins-Medium", size: 13)!,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        let attributed = NSAttributedString(string: title, attributes: attributes)
        view.setAttributedTitle(attributed, for: .normal)
        
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.readMore)
                }
            )
            , for: .touchUpInside
        )
        view.widthAnchor ~= 80
        view.heightAnchor ~= 20
        return view
    }()
    
    override func setupContent() {
        super.setupContent()
        addSubview(readMoreBtn)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        readMoreBtn.topAnchor ~= secondLbl.bottomAnchor + 10
        readMoreBtn.rightAnchor ~= rightAnchor - 16
    }
}


