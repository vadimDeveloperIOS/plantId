//
//  DescriptionCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 26.06.25.
//

import UIKit

final class DescriptionCell: UICollectionViewCell {
    
    var viewModel: DescriptionContentView.Model {
        get {
            cellContentView.viewModel ?? .init()
        }
        set {
            cellContentView.viewModel = newValue
        }
    }
    
    private lazy var cellContentView: DescriptionContentView = {
        let view = DescriptionContentView()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

// MARK: - CONTENT VIEW

final class DescriptionContentView: View {
    
    struct Model: Hashable {
        var description: String?
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            harTitle.text = viewModel.description
        }
    }
    
    private lazy var harTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Regular", size: 14)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.contentMode = .scaleToFill
        view.numberOfLines = 0
        return view
    }()

    override func setupContent() {
        addSubview(harTitle)
    }
    
    override func setupLayout() {
        harTitle.pinToSuperview()
    }
}
