//
//  4. AIAssistantHomeCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 30.08.25.
//

import UIKit

/// ----------------------------------------------
// MARK: - CELL
/// ----------------------------------------------

final class AIAssistantHomeCell: UICollectionViewCell {
    
    private lazy var cellContentView: AIAssistantCellContent = {
        let view = AIAssistantCellContent()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

/// ----------------------------------------------
// MARK: - CONTENT
/// ----------------------------------------------

final class AIAssistantCellContent: View {
    
    private lazy var bgImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "r_home_backgr_ for_AIask2")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var firstLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = TextForHomeScene.askYourPlantAIAssistant
        view.font = UIFont(name: "Poppins-SemiBold", size: 22)
        view.textColor = #colorLiteral(red: 0.5592492223, green: 0.7865967155, blue: 0.3077450097, alpha: 1)
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }()
    
    private lazy var secondLbl: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = TextForHomeScene.aiAssistantIsReadyToHelp
        view.font = UIFont(name: "Poppins-Regular", size: 10)
        view.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 0.8)
        view.numberOfLines = 0
        view.textAlignment = .left
        return view
    }()
    
    override func setupContent() {
        addSubview(bgImage)
        addSubview(firstLbl)
        addSubview(secondLbl)
    }
    
    override func setupLayout() {
        bgImage.pinToSuperview()
        
        firstLbl.topAnchor ~= topAnchor + 15
        firstLbl.leftAnchor ~= leftAnchor + 15
        firstLbl.widthAnchor ~= 181
        
        secondLbl.topAnchor ~= firstLbl.bottomAnchor + 15
        secondLbl.leftAnchor ~= firstLbl.leftAnchor
        secondLbl.widthAnchor ~= 181
    }
}
