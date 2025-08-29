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
    
    var viewModel: String {
        get {
            cellContentView.textForWeather ?? .init()
        }
        set {
            cellContentView.textForWeather = newValue
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


fileprivate final class SearchHomeCellContent: View {
    
    var textForWeather: String? {
        didSet {
            
        }
        
    }
    
    private lazy var bgImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "r_home_backgr_for_search")
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var weatherText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Sun Cloudy 220"
        
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "r_home_cloud")
        view.addSubview(image)
        image.widthAnchor ~= 20
        image.heightAnchor ~= 20
        image.centerYAnchor ~= view.centerYAnchor
        image.leftAnchor ~= view.leftAnchor
        return view
    }()
    
    private lazy var searchTextField: SearchTextField = {
        let view = SearchTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
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
        weatherText.leftAnchor ~= leftAnchor + 16
    }
}
