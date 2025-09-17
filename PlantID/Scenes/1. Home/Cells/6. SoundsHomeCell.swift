//
//  SoundsHomeCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 17.09.25.
//

import UIKit

/// ----------------------------------------------
// MARK: - CELL
/// ----------------------------------------------

final class SoundsHomeCell: UICollectionViewCell {
    
    var viewModel: SoundsHomeContent.Model? {
        didSet {
            cellContentView.viewModel = viewModel
        }
    }
    
    var actionHandler: (SoundsHomeContent.Action) -> Void {
        get {
            cellContentView.actionHandler
        }
        set {
            cellContentView.actionHandler = newValue
        }
    }
    
    private lazy var cellContentView: SoundsHomeContent = {
        let view = SoundsHomeContent()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
    
}

/// ----------------------------------------------
// MARK: - CONTENT
/// ----------------------------------------------


final class SoundsHomeContent: View {
    
    struct Model: Hashable {
        let nameBg: String
        var isPlaying: Bool
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            btn.setBackgroundImage(UIImage(named: viewModel.nameBg), for: .normal)
            stopImg.isHidden = !viewModel.isPlaying
        }
    }
    
    enum Action {
        case playOrStop
    }
    
    var actionHandler:(Action) -> Void = { _ in  }
    
    private lazy var btn: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
                self.actionHandler(.playOrStop)
            }),
            for: .touchUpInside
        )
        return view
    }()
    
    private lazy var stopImg: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(systemName: "pause.fill")
        view.tintColor = .white
        view.isHidden = true
        view.widthAnchor ~= 35
        view.heightAnchor ~= 35
        return view
    }()
    
    override func setupContent() {
        addSubview(btn)
        addSubview(stopImg)
    }
    
    override func setupLayout() {
        
        widthAnchor ~= 88
        heightAnchor ~= 88
        layer.cornerRadius = 44
        
        btn.pinToSuperview()
        
        stopImg.centerXAnchor ~= btn.centerXAnchor
        stopImg.centerYAnchor ~=  btn.centerYAnchor
    }
}
