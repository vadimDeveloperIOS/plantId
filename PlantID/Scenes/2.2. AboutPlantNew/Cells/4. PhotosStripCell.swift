//
//  4. PhotosStripCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 9.09.25.
//


import UIKit

// MARK: - Cell

final class PhotosStripCell: UICollectionViewCell {

    var viewModel: PhotosStripContent.Model? {
        didSet { content.viewModel = viewModel }
    }

    var actionHandler: (Int) -> Void {
        get { content.actionHandler }
        set { content.actionHandler = newValue }
    }

    private lazy var content: PhotosStripContent = {
        let v = PhotosStripContent()
        contentView.addSubview(v)
        v.pinToSuperview(left: 16, top: 0, right: 16, bottom: 0)
        return v
    }()
}

// MARK: - Content

final class PhotosStripContent: View {

    // MARK: Design tokens
    enum Design {
        static let inset: CGFloat = 16
        static let spacing: CGFloat = 12
        static let thumbSide: CGFloat = 82
        static let radius: CGFloat = 14

        enum Font {
            static let title = UIFont(name: "Poppins-SemiBold", size: 18)!
        }
        enum Color {
            static let title  = UIColor.label
            static let border = UIColor(red: 0.22, green: 0.60, blue: 0.32, alpha: 1)
            static let thumbBg = UIColor(white: 0.95, alpha: 1)
        }
    }

    // MARK: ViewModel

    struct PhotoItem: Hashable {
        let image: UIImage?
        let url: URL?
        public init(image: UIImage? = nil, url: URL? = nil) {
            self.image = image; self.url = url
        }
    }

    struct Model: Hashable {
        let title: String
        let photos: [PhotoItem]
        let selectedIndex: Int?
    }

    var viewModel: Model? { didSet { applyModel() } }
    var actionHandler: (Int) -> Void = { _ in }

    // MARK: UI

    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.font = Design.Font.title
        v.textColor = Design.Color.title
        v.numberOfLines = 1
        return v
    }()

    private lazy var flow: UICollectionViewFlowLayout = {
        let l = UICollectionViewFlowLayout()
        l.scrollDirection = .horizontal
        l.minimumInteritemSpacing = Design.spacing
        l.minimumLineSpacing = Design.spacing
        l.itemSize = .init(width: Design.thumbSide, height: Design.thumbSide)
        return l
    }()

    private lazy var collectionView: UICollectionView = {
        let v = UICollectionView(frame: .zero, collectionViewLayout: flow)
        v.backgroundColor = .clear
        v.showsHorizontalScrollIndicator = false
        v.dataSource = self
        v.delegate = self
        v.register(PhotoThumbCell.self, forCellWithReuseIdentifier: PhotoThumbCell.reuseId)
        return v
    }()

    // MARK: Data

    private var items: [PhotoItem] = []
    private var selectedIndex: Int?

    // MARK: Lifecycle

    override func setupContent() {
        addSubview(titleLabel)
        addSubview(collectionView)
    }

    override func setupLayout() {
        titleLabel.topAnchor ~= topAnchor + Design.inset
        titleLabel.leftAnchor ~= leftAnchor + Design.inset
        titleLabel.rightAnchor ~= rightAnchor - Design.inset

        collectionView.topAnchor ~= titleLabel.bottomAnchor + Design.spacing
        collectionView.leftAnchor ~= leftAnchor + Design.inset
        collectionView.rightAnchor ~= rightAnchor - Design.inset
        collectionView.heightAnchor ~= Design.thumbSide
        collectionView.bottomAnchor ~= bottomAnchor - Design.inset
    }

    private func applyModel() {
        guard let vm = viewModel else { return }
        titleLabel.text = vm.title
        items = vm.photos
        selectedIndex = vm.selectedIndex
        collectionView.reloadData()
        // прокрутим к выбранному (если есть)
        if let idx = selectedIndex, idx < items.count {
            DispatchQueue.main.async {
                self.collectionView.scrollToItem(at: IndexPath(item: idx, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
}

// MARK: - UICollectionView

extension PhotosStripContent: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { items.count }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoThumbCell.reuseId, for: indexPath) as! PhotoThumbCell
        let item = items[indexPath.item]
        cell.configure(image: item.image, url: item.url)
        cell.isSelected = (indexPath.item == selectedIndex)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.visibleCells.forEach { ($0 as? PhotoThumbCell)?.isSelected = false }
        (collectionView.cellForItem(at: indexPath) as? PhotoThumbCell)?.isSelected = true
        actionHandler(indexPath.item)
    }
}

// MARK: - Thumb Cell

private final class PhotoThumbCell: UICollectionViewCell {
    static let reuseId = "PhotoThumbCell"

    private let imageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        v.backgroundColor = PhotosStripContent.Design.Color.thumbBg
        return v
    }()

    private let selectionLayer: CALayer = {
        let l = CALayer()
        l.borderWidth = 2
        l.cornerRadius = PhotosStripContent.Design.radius
        l.masksToBounds = true
        l.borderColor = PhotosStripContent.Design.Color.border.cgColor
        l.isHidden = true
        return l
    }()

    override var isSelected: Bool {
        didSet { selectionLayer.isHidden = !isSelected }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.pinToSuperview()
        contentView.layer.cornerRadius = PhotosStripContent.Design.radius
        contentView.layer.masksToBounds = true
        layer.cornerRadius = PhotosStripContent.Design.radius
        layer.masksToBounds = false
        layer.insertSublayer(selectionLayer, above: contentView.layer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        selectionLayer.frame = bounds
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(image: UIImage?, url: URL?) {
        if let image { imageView.image = image; return }
        imageView.image = nil
        guard let url else { return }
        // простая загрузка (без кэша)
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data, let img = UIImage(data: data) else { return }
            DispatchQueue.main.async { self?.imageView.image = img }
        }.resume()
    }
}

