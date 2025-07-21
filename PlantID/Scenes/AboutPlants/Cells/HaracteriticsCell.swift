//
//  HaracteriticsCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 25.06.25.
//

import UIKit

final class HaracteriticsCell: UICollectionViewCell {
    var viewModel: HaracteriticsContentView.Model {
        get {
            cellContentView.viewModel ?? .init()
        }
        set {
            cellContentView.viewModel = newValue
        }
    }
    
    private lazy var cellContentView: HaracteriticsContentView = {
        let view = HaracteriticsContentView()
        contentView.addSubview(view)
        view.pinToSuperview()
        return view
    }()
}

// MARK: - CONTENT VIEW

final class HaracteriticsContentView: View {
    
    struct Model: Hashable {
        var size: String?
        var humidity: String?
        var spraying: String?
        var fertilize: String?
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            
            sizeCell.haracteristicValue = viewModel.size
            humidityCell.haracteristicValue = viewModel.humidity
            sprayingCell.haracteristicValue = viewModel.spraying
            fertilizeCell.haracteristicValue = viewModel.fertilize
        }
    }

    private lazy var sizeCell: HarateristicItem = {
        let view = HarateristicItem()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 69
        view.icon = "har1"
        view.haracteristicName = "size".localized
        return view
    }()
    
    private lazy var humidityCell: HarateristicItem = {
        let view = HarateristicItem()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 69
        view.icon = "har2"
        view.haracteristicName = "humidity".localized
        return view
    }()
    
    private lazy var sprayingCell: HarateristicItem = {
        let view = HarateristicItem()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 69
        view.icon = "har3"
        view.haracteristicName = "spraying".localized
        return view
    }()
    
    private lazy var fertilizeCell: HarateristicItem = {
        let view = HarateristicItem()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor ~= 69
        view.icon = "har4"
        view.haracteristicName = "fertilize".localized
        return view
    }()
    
    private lazy var stackH1: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 0
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
    private lazy var stackH2: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 0
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
    private lazy var stackV: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 20
        view.alignment = .fill
        view.distribution = .fill
        return view
    }()
    
    private lazy var vSeparator1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#8FDB85")
        view.widthAnchor ~= 1
        view.heightAnchor ~= 45
        return view
    }()
    
    private lazy var vSeparator2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#8FDB85")
        view.widthAnchor ~= 1
        view.heightAnchor ~= 45
        return view
    }()
    
    private lazy var hSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#8FDB85")
        view.widthAnchor ~= 343
        view.heightAnchor ~= 1
        return view
    }()

    
    override func setupContent() {
        backgroundColor = .clear
        
        addSubview(stackV)
        stackV.addArrangedSubview(stackH1)
        stackV.addArrangedSubview(hSeparator)
        stackV.addArrangedSubview(stackH2)
        
        stackH1.addArrangedSubview(sizeCell)
        stackH1.addArrangedSubview(vSeparator1)
        stackH1.addArrangedSubview(humidityCell)
        
        stackH2.addArrangedSubview(sprayingCell)
        stackH2.addArrangedSubview(vSeparator2)
        stackH2.addArrangedSubview(fertilizeCell)
    }
    
    override func setupLayout() {
        stackV.pinToSuperview()
    }
}


// MARK: - HarateristicItem

final class HarateristicItem: View {
    
    var icon: String? {
        didSet{
            guard let icon else { return }
            image.image = UIImage(named: icon)
        }
    }
    
    var haracteristicName: String? {
        didSet {
            harTitle.text = haracteristicName
        }
    }
    
    var haracteristicValue: String? {
        didSet {
            harValue.text = haracteristicValue
        }
    }
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.widthAnchor ~= 20
        view.heightAnchor ~= 20
        return view
    }()
    
    private lazy var harTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Regular", size: 12)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        view.contentMode = .center
        return view
    }()

    private lazy var harValue: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Onest-Medium", size: 16)
        view.textColor = UIColor(red: 0.067, green: 0.486, blue: 0.008, alpha: 1)
        view.contentMode = .center
        return view
    }()
    
    override func setupContent() {
        backgroundColor = .clear
        addSubview(image)
        addSubview(harTitle)
        addSubview(harValue)
    }
    
    override func setupLayout() {
        heightAnchor ~= 45
        widthAnchor ~= 167
        
        image.centerXAnchor ~= centerXAnchor - 23
        image.centerYAnchor ~= centerYAnchor - 10
        
        harTitle.leftAnchor ~= image.rightAnchor + 10
        harTitle.centerYAnchor ~= centerYAnchor - 10
        
        harValue.centerXAnchor ~= centerXAnchor
        harValue.centerYAnchor ~= centerYAnchor + 15
    }
}
