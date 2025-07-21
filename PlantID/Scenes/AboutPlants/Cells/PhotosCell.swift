//
//  PhotosCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 26.06.25.
//

import UIKit

final class PhotosCell: UICollectionViewCell {
    
    var viewModel: PhotosContentView.Model {
        get {
            cellContentView.viewModel ?? .init()
        }
        set {
            cellContentView.viewModel = newValue
        }
    }
    
    private lazy var cellContentView: PhotosContentView = {
        let view = PhotosContentView()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

// MARK: - CONTENT VIEW

final class PhotosContentView: View {
    
    struct Model: Hashable {
        var photo: UIImage?
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            photo.image = viewModel.photo
        }
    }
    
    private lazy var photo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()

    override func setupContent() {
        layer.cornerRadius = 8
        clipsToBounds = true
        addSubview(photo)
    }
    
    override func setupLayout() {
        photo.pinToSuperview()
    }
    
}
