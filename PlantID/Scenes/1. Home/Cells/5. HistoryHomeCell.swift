//
//  5. HistoryHomeCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit

/// ----------------------------------------------
// MARK: - CELL
/// ----------------------------------------------

final class HistoryHomeCell: UICollectionViewCell {
    
    var viewModel: HistoryCellContent.BigCellModel? {
        didSet {
            cellContentView.bigCellViewModel = viewModel
        }
    }
    
    var actionHandler: (HistoryCellContent.Action) -> Void {
        get {
            cellContentView.actionHandler
        }
        set {
            cellContentView.actionHandler = newValue
        }
    }
    
    private lazy var cellContentView: HistoryCellContent = {
        let view = HistoryCellContent()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
    
}

/// ----------------------------------------------
// MARK: - CONTENT
/// ----------------------------------------------

final class HistoryCellContent: BaseBigCell {
    
    enum Action {
        case add
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    private lazy var greenLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = TextForHomeScene.addToMyPlants
        view.font = UIFont(name: "Poppins-Medium", size: 12)
        view.textColor = #colorLiteral(red: 0.3096545041, green: 0.6309925914, blue: 0.09553129226, alpha: 1)
        view.textAlignment = .left
        return view
    }()
    
    private lazy var addBtn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "r_home_small_btn"), for: .normal)
        view.setTitle(TextForHomeScene.add, for: .normal)
        view.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 14)
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.add)
            })
            , for: .touchUpInside
        )
        view.widthAnchor ~= 64
        view.heightAnchor ~= 32
        return view
    }()
    
    override func setupContent() {
        super.setupContent()
        backgroundColor = ColorsForHomeScene.colorsForHistory.randomElement()
        layer.cornerRadius = 20
        addSubview(greenLbl)
        addSubview(addBtn)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        greenLbl.bottomAnchor ~= bottomAnchor - 20
        greenLbl.leftAnchor ~= secondLbl.leftAnchor
        
        addBtn.centerYAnchor ~= greenLbl.centerYAnchor
        addBtn.rightAnchor ~= rightAnchor - 15
    }
}


