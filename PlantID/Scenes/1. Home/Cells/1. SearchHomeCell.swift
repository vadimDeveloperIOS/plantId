//
//  1. SearchHomeCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 29.08.25.
//

import UIKit

/// ----------------------------------------------
// MARK: - CELL
/// ----------------------------------------------

final class SearchHomeCell: UICollectionViewCell {
    
    var viewModel: SearchHomeCellContent.Model? {
        didSet {
            guard let viewModel else { return }
            cellContentView.viewModel = viewModel
        }
    }
    
    var onQueryChange: (String) -> Void {
        get {
            cellContentView.onQueryChange
        }
        set {
            cellContentView.onQueryChange = newValue
        }
    }
    
    private lazy var cellContentView: SearchHomeCellContent = {
        let view = SearchHomeCellContent()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

/// ----------------------------------------------
// MARK: - CONTENT
/// ----------------------------------------------


final class SearchHomeCellContent: View {
    
    struct Model: Hashable {
        let textForWeather: String
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            weatherText.text = viewModel.textForWeather
        }
    }
    
    var onQueryChange: ((String) -> Void) = { _ in }
    
    private lazy var bgImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "r_home_backgr_ for_search")
        view.isUserInteractionEnabled = false
        view.heightAnchor ~= 210
        return view
    }()
    
    private lazy var weatherText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Sun Cloudy 220"
        view.textColor = .white
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: " ")
        view.addSubview(image)
        image.widthAnchor ~= 20
        image.heightAnchor ~= 20
        image.centerYAnchor ~= view.centerYAnchor
        image.leftAnchor ~= view.leftAnchor - 30
        return view
    }()
    
    private lazy var searchTextField: SearchTextField = {
        let view = SearchTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onQueryChange = { [weak self] query in
            guard let self else { return }
            self.onQueryChange(query)
        }
        return view
    }()
    
    override func setupContent() {
        addSubview(bgImage)
        addSubview(searchTextField)
        addSubview(weatherText)
    }
    
    override func setupLayout() {
        bgImage.pinToSuperview()
        
        searchTextField.bottomAnchor ~= bottomAnchor - 20
        searchTextField.leftAnchor ~= leftAnchor + 16
        searchTextField.rightAnchor ~= rightAnchor - 16
        
        weatherText.bottomAnchor ~= searchTextField.topAnchor - 20
        weatherText.leftAnchor ~= leftAnchor + 46
    }
}
