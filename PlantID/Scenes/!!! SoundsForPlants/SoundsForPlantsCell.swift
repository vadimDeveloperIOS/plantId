//
//  SoundsForPlantsCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 16.09.25.
//


import UIKit

// ----------------------------------------------------
// MARK: - CELL
// ----------------------------------------------------

final class SoundsForPlantsCell: UICollectionViewCell {
    
    var viewModel: SoundsForPlantsContent.Model? {
        didSet {
            content.viewModel = viewModel
        }
    }
    
    var actionHandler: (SoundsForPlantsContent.Action) -> Void {
        get { content.actionHandler }
        set { content.actionHandler = newValue }
    }
    
    private lazy var content: SoundsForPlantsContent = {
        let v = SoundsForPlantsContent()
        contentView.addSubview(v)
        v.pinToSuperview()
        return v
    }()
}

// ----------------------------------------------------
// MARK: - CONTENT
// ----------------------------------------------------

final class SoundsForPlantsContent: View {
    
    // MARK: Model
    struct Model: Hashable {
        let nameIcon: String
        let title: String
        let subtitle: String
        let playIconName: String
        let pauseIconName: String
        var isPlaying: Bool
    }
    
    // MARK: Action
    enum Action {
        case play
        case pause
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    var viewModel: Model? {
        didSet {
            guard let vm = viewModel else { return }
            
            iconnn.image = UIImage(named: vm.nameIcon)
            
            titleLabel.text = vm.title
            subtitleLabel.text = vm.subtitle
            playPauseButton.setImage(
                UIImage(systemName: vm.isPlaying ? vm.pauseIconName : vm.playIconName),
                for: .normal
            )
            isPlaying = vm.isPlaying
        }
    }
    
    private var isPlaying = false
    
    // MARK: UI
    
    private lazy var iconnn: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor ~= 88
        view.heightAnchor ~= 88
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "Poppins-Medium", size: 16)
        v.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 1)
        v.numberOfLines = 1
        return v
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "Poppins-Regular", size: 13)
        v.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        v.numberOfLines = 2
        return v
    }()
    
    private lazy var playPauseButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        b.tintColor = .white

        b.addAction(
            UIAction { [weak self] _ in
                guard let self, let vm = self.viewModel else { return }
                
                self.actionHandler( self.isPlaying ? .pause : .play)
                self.isPlaying.toggle()
            },
            for: .touchUpInside
        )
        b.widthAnchor ~= 40
        b.heightAnchor ~= 40
        b.layer.cornerRadius = 20
        return b
    }()
        
    // MARK: Lifecycle
    override func setupContent() {
        backgroundColor = UIColor(red: 0.93, green: 0.98, blue: 0.93, alpha: 1)
        layer.cornerRadius = 16
        addSubview(iconnn)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(playPauseButton)
    }
    
    override func setupLayout() {
        
        iconnn.topAnchor ~= topAnchor + 12
        iconnn.leftAnchor ~= leftAnchor + 12
        
        titleLabel.topAnchor ~= iconnn.bottomAnchor + 10
        titleLabel.leftAnchor ~= leftAnchor + 12
        titleLabel.rightAnchor ~= rightAnchor - 12
        
        subtitleLabel.topAnchor ~= titleLabel.bottomAnchor + 6
        subtitleLabel.leftAnchor ~= leftAnchor + 12
        subtitleLabel.rightAnchor ~= rightAnchor - 12
        
        playPauseButton.topAnchor ~= subtitleLabel.bottomAnchor + 16
        playPauseButton.bottomAnchor ~= bottomAnchor - 16
        playPauseButton.rightAnchor ~= rightAnchor - 16
    }
}
