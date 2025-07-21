//
//  CarePlanCells.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 27.06.25.
//

import UIKit

// MARK: - Models
struct HeaderModel: Hashable {
    let title: String
}
struct HealthNoteModel: Hashable {
    let text: String
}
struct WateringModel: Hashable {
    let frequency: String
    let reminderOn: Bool
    let amount: Int
}
struct LightModel: Hashable { let preferredLight: String } // ненужно
struct TemperatureModel: Hashable { let range: String } // ненужно
struct FertilizingModel: Hashable { let schedule: String; let type: String } // ненужно
struct PruningModel: Hashable { let lastPruned: String; let tips: String } // ненужно
struct NotificationModel: Hashable { let reminderOn: Bool; let time: String } // ненужно

struct SaveButtonModel: Hashable {
    let title: String
}

// MARK: - Header Cell
final class HeaderSectionCell: UICollectionViewCell {
    var viewModel: HeaderModel? {
        didSet {
            headerView.title = viewModel?.title.uppercased() ?? "no_value".localized
        }
    }
    private lazy var headerView: HeaderView = {
        let v = HeaderView()
        contentView.addSubview(v)
        v.pinToSuperview()
        return v
    }()
}

final class HeaderView: View {
    let titleLabel = UILabel()
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    override func setupContent() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor(red: 0.068, green: 0.078, blue: 0.067, alpha: 1)
        titleLabel.font = UIFont(name: "Onest-SemiBold", size: 20)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
    }
    override func setupLayout() {
        titleLabel.topAnchor ~= topAnchor + 16
        titleLabel.leftAnchor ~= leftAnchor + 16
        titleLabel.rightAnchor ~= rightAnchor - 16
        titleLabel.bottomAnchor ~= bottomAnchor - 16
    }
}

// MARK: - Health Note Cell
final class HealthNoteCell: UICollectionViewCell {
    var viewModel: HealthNoteModel? {
        didSet {
            content.viewModel = viewModel
        }
    }
    private lazy var content: HealthNoteView = {
        let v = HealthNoteView()
        contentView.addSubview(v)
        v.pinToSuperview()
        return v
    }()
}

final class HealthNoteView: View {
    var viewModel: HealthNoteModel? {
        didSet {
            textLbl.text = viewModel?.text
        }
    }
    private let titleLbl = UILabel()
    private let textLbl = UILabel()
    
    override func setupContent() {
        titleLbl.translatesAutoresizingMaskIntoConstraints = false; textLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.text = "health_note".localized
        titleLbl.textColor = UIColor(red: 0.194, green: 0.274, blue: 0.211, alpha: 1)
        titleLbl.font = UIFont(name: "Onest-SemiBold", size: 20)
        textLbl.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
        textLbl.font = UIFont(name: "Onest-Regular", size: 14)
        textLbl.numberOfLines = 0
        addSubview(titleLbl); addSubview(textLbl)
    }
    override func setupLayout() {
        titleLbl.topAnchor ~= topAnchor + 12
        titleLbl.leftAnchor ~= leftAnchor + 16
        titleLbl.rightAnchor ~= rightAnchor - 16
        textLbl.topAnchor ~= titleLbl.bottomAnchor + 8
        textLbl.leftAnchor ~= leftAnchor + 16
        textLbl.rightAnchor ~= rightAnchor - 16
        textLbl.bottomAnchor ~= bottomAnchor - 12
    }
}

// MARK: - Watering Cell
final class WateringCell: UICollectionViewCell {
    var viewModel: WateringModel? {
        didSet {
            content.viewModel = viewModel
        }
    }
    var actionHandler: (WateringView.Action) -> Void {
        get {
            content.actionHandler
        }
        set {
            content.actionHandler = newValue
        }
    }
    var dropdownVal: OptionsForFrequency? {
        didSet {
            guard let dropdownVal else { return }
            content.dropdownVal = dropdownVal
        }
    }
    private lazy var content: WateringView = {
        let v = WateringView()
        contentView.addSubview(v)
        v.pinToSuperview()
        return v
    }()
}

final class WateringView: View {
    
    var dropdownVal: OptionsForFrequency? {
        didSet {
            guard let dropdownVal else { return }
            freqValue.text = dropdownVal.rawValue.localized
        }
    }
    
    var viewModel: WateringModel? {
        didSet {
            guard let viewModel else { return }
            freqValue.text = viewModel.frequency
            reminderSwitch.isOn = viewModel.reminderOn
            viewModel.amount <= 4 ? setupButtons(viewModel.amount - 1) : setupButtons()
        }
    }
    enum Action {
        case waternigVal(Int)
        case switchIsOn(Bool)
        case onShowDropdown
    }
    var actionHandler: (Action) -> Void = { _ in }
    var onShowDropdown: ((CGRect) -> Void)?
    
    private var isOn: Bool = false
    
    private let titleLbl = UILabel()
    private let freqLbl = UILabel()
    private let reminderLbl = UILabel()
    private let reminderSwitch = UISwitch()
    private let amountLbl = UILabel()
    private let icon = UIImageView(image: UIImage(named: "care1"))
    
    private lazy var whiteMenu: UIButton = {
        let view = UIButton()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.widthAnchor ~= 160
        view.heightAnchor ~= 36
        view.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
                self.actionHandler(.onShowDropdown)
            })
            , for: .touchUpInside)
        return view
    }()
    
    private lazy var freqValue: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Onest-Regular", size: 14)
        view.textColor = UIColor(red: 0.232, green: 0.252, blue: 0.232, alpha: 0.74)
//        view.text = "Every 3 days"
        return view
    }()
    
    // Images

    let notEmptyImg = UIImage(named: "icons_24-2")
    let emptyImg = UIImage(named: "icons_24-3")

    // Buttons
    private lazy var but0 = UIButton()
    private lazy var but1 = UIButton()
    private lazy var but2 = UIButton()
    private lazy var but3 = UIButton()
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillEqually
        view.spacing = 13
        [but0, but1, but2, but3].forEach { b in
            b.translatesAutoresizingMaskIntoConstraints = false
            b.widthAnchor ~= 24
            b.heightAnchor ~= 24
            b.backgroundColor = .white
            b.layer.cornerRadius = 12
            b.clipsToBounds = true
            b.setImage(UIImage(), for: .normal)
            b.imageView?.contentMode = .scaleAspectFit
            if let i = b.imageView {
                i.translatesAutoresizingMaskIntoConstraints = false
                i.widthAnchor ~= 15
                i.heightAnchor ~= 15
            }
            view.addArrangedSubview(b)
        }
        but0.addAction(UIAction(handler: { [weak self] _ in
            self?.setupButtons(0)
            self?.actionHandler(.waternigVal(1))
        }), for: .touchUpInside)
        
        but1.addAction(UIAction(handler: { [weak self] _ in
            self?.setupButtons(1)
            self?.actionHandler(.waternigVal(2))
        }), for: .touchUpInside)
        
        but2.addAction(UIAction(handler: { [weak self] _ in
            self?.setupButtons(2)
            self?.actionHandler(.waternigVal(3))
        }), for: .touchUpInside)
        
        but3.addAction(UIAction(handler: { [weak self] _ in
            self?.setupButtons(3)
            self?.actionHandler(.waternigVal(4))

        }), for: .touchUpInside)
        
        setupButtons()
        return view
    }()

    override func setupContent() {
        setBgGradientAndBorderForCell()
        layer.cornerRadius = 16
//        clipsToBounds = true
        [ whiteMenu, icon, titleLbl, freqLbl, reminderLbl, reminderSwitch, amountLbl, freqValue, stack].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false; addSubview(v)
        }
        icon.contentMode = .scaleAspectFit
        titleLbl.text = "watering".localized
        freqLbl.text = "frequency".localized
        reminderLbl.text = "reminder".localized
        amountLbl.text = "amount".localized
        titleLbl.textColor = UIColor(red: 0.075, green: 0.067, blue: 0.078, alpha: 1)
        titleLbl.font = UIFont(name: "Onest-SemiBold", size: 16)
        [freqLbl, reminderLbl, amountLbl].forEach { v in
            v.font = UIFont(name: "Onest-Medium", size: 14)
            v.textColor = UIColor(red: 0.067, green: 0.488, blue: 0.009, alpha: 1)
        }
        reminderSwitch.addAction(
            UIAction(handler: { [weak self] _ in
                self?.isOn.toggle()
                self?.actionHandler(.switchIsOn(self!.isOn))
            })
            , for: .valueChanged)
    }
    override func setupLayout() {
        icon.widthAnchor ~= 20
        icon.heightAnchor ~= 20
        icon.topAnchor ~= topAnchor + 12
        icon.leftAnchor ~= leftAnchor + 16
        
        titleLbl.centerYAnchor ~= icon.centerYAnchor
        titleLbl.leftAnchor ~= icon.rightAnchor + 4

        freqLbl.topAnchor ~= titleLbl.bottomAnchor + 35
        freqLbl.leftAnchor ~= leftAnchor + 16
        
        whiteMenu.centerYAnchor ~= freqLbl.centerYAnchor
        whiteMenu.rightAnchor ~= rightAnchor - 16
        
        reminderLbl.topAnchor ~= freqLbl.bottomAnchor + 30
        reminderLbl.leftAnchor ~= leftAnchor + 16

        reminderSwitch.widthAnchor ~= 44
        reminderSwitch.heightAnchor ~= 28
        reminderSwitch.centerYAnchor ~= reminderLbl.centerYAnchor
        reminderSwitch.rightAnchor ~= rightAnchor - 20

        amountLbl.topAnchor ~= reminderLbl.bottomAnchor + 30
        amountLbl.leftAnchor ~= leftAnchor + 16
        amountLbl.bottomAnchor ~= bottomAnchor - 12
        
        freqValue.centerXAnchor ~= whiteMenu.centerXAnchor
        freqValue.centerYAnchor ~= whiteMenu.centerYAnchor
        
        stack.centerYAnchor ~= amountLbl.centerYAnchor
        stack.rightAnchor ~= rightAnchor - 16
    }
    
    private func setupButtons(_ index: Int = 0) {
        but0.setImage(index >= 0 ? notEmptyImg : emptyImg, for: .normal)
        but1.setImage(index >= 1 ? notEmptyImg : emptyImg, for: .normal)
        but2.setImage(index >= 2 ? notEmptyImg : emptyImg, for: .normal)
        but3.setImage(index >= 3 ? notEmptyImg : emptyImg, for: .normal)
    }
}




// --------------------------------------------------------------------
// --------------------------------------------------------------------
//
// ДАЛЕЕ НЕ ИСПОЛЬЗУЕМЫЕ ЯЧЕЙКИ (ЗА ИСКЛЮЧЕНИЕМ ПОСЛЕДНЕЙ - КНОПКИ
//
// --------------------------------------------------------------------
// --------------------------------------------------------------------




// MARK: - Light Cell
final class LightCell: UICollectionViewCell {
    var viewModel: LightModel? {
        didSet {
            content.viewModel = viewModel
        }
    }
    private lazy var content: LightView = {
        let v = LightView()
        contentView.addSubview(v)
        v.pinToSuperview()
        return v
    }()
}

final class LightView: View {
    var viewModel: LightModel? {
        didSet {
//            lightLbl.text = viewModel?.preferredLight
        }
    }
    private let titleLbl = UILabel()
    private let lightLbl = UILabel()
    private let icon = UIImageView(image: UIImage(named: "care2"))

    
    override func setupContent() {
        setBgGradientAndBorderForCell()
        layer.cornerRadius = 16
        clipsToBounds = true
        icon.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        lightLbl.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        titleLbl.text = "LIGHT REQUIREMENTS"
        titleLbl.textColor = UIColor(red: 0.075, green: 0.067, blue: 0.078, alpha: 1)
        titleLbl.font = UIFont(name: "Onest-SemiBold", size: 16)
        lightLbl.text = "Preferred Light:"
        lightLbl.textColor = UIColor(red: 0.067, green: 0.488, blue: 0.009, alpha: 1)
        lightLbl.font = UIFont(name: "Onest-Medium", size: 14)
        addSubview(icon)
        addSubview(titleLbl)
        addSubview(lightLbl)
    }
    override func setupLayout() {
        icon.widthAnchor ~= 20
        icon.heightAnchor ~= 20
        icon.topAnchor ~= topAnchor + 12
        icon.leftAnchor ~= leftAnchor + 16
        
        titleLbl.centerYAnchor ~= icon.centerYAnchor
        titleLbl.leftAnchor ~= icon.rightAnchor + 4
        lightLbl.topAnchor ~= titleLbl.bottomAnchor + 18
        lightLbl.leftAnchor ~= leftAnchor + 16
        lightLbl.bottomAnchor ~= bottomAnchor - 12
    }
}

// MARK: - Temperature Cell
final class TemperatureCell: UICollectionViewCell {
    var viewModel: TemperatureModel? {
        didSet {
            content.viewModel = viewModel
        }
    }
    private lazy var content: TemperatureView = {
        let v = TemperatureView()
        contentView.addSubview(v)
        v.pinToSuperview()
        return v
    }()
}

final class TemperatureView: View {
    var viewModel: TemperatureModel? {
        didSet {
//            rangeLbl.text = viewModel?.range
        }
    }
    private let titleLbl = UILabel()
    private let rangeLbl = UILabel()
    private let icon = UIImageView(image: UIImage(named: "care3"))
    override func setupContent() {
        setBgGradientAndBorderForCell()
        layer.cornerRadius = 16
        clipsToBounds = true
        icon.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        rangeLbl.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        titleLbl.text = "TEMPERATURE RANGE"
        titleLbl.textColor = UIColor(red: 0.075, green: 0.067, blue: 0.078, alpha: 1)
        titleLbl.font = UIFont(name: "Onest-SemiBold", size: 16)
        rangeLbl.text = "Ideal:"
        rangeLbl.font = UIFont(name: "Onest-Medium", size: 14)
        rangeLbl.textColor = UIColor(red: 0.067, green: 0.488, blue: 0.009, alpha: 1)
        addSubview(icon); addSubview(titleLbl); addSubview(rangeLbl)
    }
    override func setupLayout() {
        icon.widthAnchor ~= 20
        icon.heightAnchor ~= 20
        icon.topAnchor ~= topAnchor + 12
        icon.leftAnchor ~= leftAnchor + 16
        
        titleLbl.centerYAnchor ~= icon.centerYAnchor
        titleLbl.leftAnchor ~= icon.rightAnchor + 4
        rangeLbl.topAnchor ~= titleLbl.bottomAnchor + 18
        rangeLbl.leftAnchor ~= leftAnchor + 16
        rangeLbl.bottomAnchor ~= bottomAnchor - 12
    }
}

// MARK: - Fertilizing Cell
final class FertilizingCell: UICollectionViewCell {
    var viewModel: FertilizingModel? {
        didSet {
            content.viewModel = viewModel
        }
    }
    private lazy var content: FertilizingView = {
        let v = FertilizingView()
        contentView.addSubview(v)
        v.pinToSuperview()
        return v
    }()
}

final class FertilizingView: View {
    var viewModel: FertilizingModel? {
        didSet {
//            scheduleLbl.text = viewModel?.schedule
//            typeLbl.text = viewModel?.type
        }
    }
    private let titleLbl = UILabel(), scheduleLbl = UILabel(), typeLbl = UILabel()
    private let icon = UIImageView(image: UIImage(named: "care4"))
    override func setupContent() {
        setBgGradientAndBorderForCell()
        layer.cornerRadius = 16
        clipsToBounds = true
        [icon, titleLbl, scheduleLbl, typeLbl].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false; addSubview(v)
        }
        icon.contentMode = .scaleAspectFit
        titleLbl.text = "FERTILIZING"
        titleLbl.font = UIFont(name: "Onest-SemiBold", size: 16)
        titleLbl.textColor = UIColor(red: 0.075, green: 0.067, blue: 0.078, alpha: 1)
        scheduleLbl.text = "Schedule:"
        typeLbl.text = "Type:"
        [scheduleLbl, typeLbl].forEach { v in
            v.textColor = UIColor(red: 0.067, green: 0.488, blue: 0.009, alpha: 1)
            v.font = UIFont(name: "Onest-Medium", size: 14)
        }
    }
    override func setupLayout() {
        icon.widthAnchor ~= 20
        icon.heightAnchor ~= 20
        icon.topAnchor ~= topAnchor + 12
        icon.leftAnchor ~= leftAnchor + 16
        
        titleLbl.centerYAnchor ~= icon.centerYAnchor
        titleLbl.leftAnchor ~= icon.rightAnchor + 4
        scheduleLbl.topAnchor ~= titleLbl.bottomAnchor + 18
        scheduleLbl.leftAnchor ~= leftAnchor + 16
        typeLbl.topAnchor ~= scheduleLbl.bottomAnchor + 18
        typeLbl.leftAnchor ~= leftAnchor + 16
        typeLbl.bottomAnchor ~= bottomAnchor - 12
    }
}

// MARK: - Pruning Cell
final class PruningCell: UICollectionViewCell {
    var viewModel: PruningModel? {
        didSet {
            content.viewModel = viewModel
        }
    }
    private lazy var content: PruningView = {
        let v = PruningView()
        contentView.addSubview(v)
        v.pinToSuperview()
        return v
    }()
}

final class PruningView: View {
    var viewModel: PruningModel? {
        didSet {
//            prunedLbl.text = "Last pruned: \(viewModel?.lastPruned ?? "")"
//            tipsLbl.text = viewModel?.tips
        }
    }
    private let titleLbl = UILabel(), prunedLbl = UILabel(), tipsLbl = UILabel()
    private let icon = UIImageView(image: UIImage(named: "care5"))
    override func setupContent() {
        setBgGradientAndBorderForCell()
        layer.cornerRadius = 16
        clipsToBounds = true
        icon.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        prunedLbl.translatesAutoresizingMaskIntoConstraints = false; tipsLbl.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        titleLbl.textColor = UIColor(red: 0.075, green: 0.067, blue: 0.078, alpha: 1)
        titleLbl.font = UIFont(name: "Onest-SemiBold", size: 16)
        titleLbl.text = "Pruning & Maintenance".uppercased()
        prunedLbl.text = "Last pruned:"
        tipsLbl.text = "Maintenance Tips:"
        [prunedLbl, tipsLbl].forEach { v in
            v.font = UIFont(name: "Onest-Medium", size: 14)
            v.textColor = UIColor(red: 0.067, green: 0.488, blue: 0.009, alpha: 1)
        }
        tipsLbl.numberOfLines = 0
        addSubview(icon)
        addSubview(titleLbl); addSubview(prunedLbl); addSubview(tipsLbl)
    }
    override func setupLayout() {
        icon.widthAnchor ~= 20
        icon.heightAnchor ~= 20
        icon.topAnchor ~= topAnchor + 12
        icon.leftAnchor ~= leftAnchor + 16
        
        titleLbl.centerYAnchor ~= icon.centerYAnchor
        titleLbl.leftAnchor ~= icon.rightAnchor + 4
        prunedLbl.topAnchor ~= titleLbl.bottomAnchor + 18
        prunedLbl.leftAnchor ~= leftAnchor + 16
        tipsLbl.topAnchor ~= prunedLbl.bottomAnchor + 18
        tipsLbl.leftAnchor ~= leftAnchor + 16
        tipsLbl.rightAnchor ~= rightAnchor - 16
        tipsLbl.bottomAnchor ~= bottomAnchor - 12
    }
}

// MARK: - Notifications Cell
final class NotificationsCell: UICollectionViewCell {
    var viewModel: NotificationModel? {
        didSet {
            content.viewModel = viewModel
        }
    }
    private lazy var content: NotificationsView = {
        let v = NotificationsView()
        contentView.addSubview(v)
        v.pinToSuperview()
        return v
    }()
}

final class NotificationsView: View {
    var viewModel: NotificationModel? {
        didSet {
//            reminderSwitch.isOn = viewModel?.reminderOn ?? false
//            timeLbl.text = viewModel?.time
        }
    }
    private let titleLbl = UILabel(), reminderLlb = UILabel(), reminderSwitch = UISwitch(), timeLbl = UILabel()
    private let icon = UIImageView(image: UIImage(named: "care6"))
    override func setupContent() {
        setBgGradientAndBorderForCell()
        layer.cornerRadius = 16
        clipsToBounds = true
        [icon, titleLbl, reminderLlb, reminderSwitch, timeLbl].forEach { v in
            v.translatesAutoresizingMaskIntoConstraints = false; addSubview(v)
        }
        icon.contentMode = .scaleAspectFit
        reminderLlb.text = "Get reminders"
        timeLbl.text = "Preferred time:"
        titleLbl.text = "NOTIFICATIONS SETUP"
        titleLbl.font = UIFont(name: "Onest-SemiBold", size: 16)
        titleLbl.textColor = UIColor(red: 0.075, green: 0.067, blue: 0.078, alpha: 1)
        [ reminderLlb, timeLbl].forEach { v in
            v.font = UIFont(name: "Onest-Medium", size: 14)
            v.textColor = UIColor(red: 0.067, green: 0.488, blue: 0.009, alpha: 1)
        }
    }
    override func setupLayout() {
        icon.widthAnchor ~= 20
        icon.heightAnchor ~= 20
        icon.topAnchor ~= topAnchor + 12
        icon.leftAnchor ~= leftAnchor + 16
        
        titleLbl.centerYAnchor ~= icon.centerYAnchor
        titleLbl.leftAnchor ~= icon.rightAnchor + 4
        reminderLlb.topAnchor ~= titleLbl.bottomAnchor + 18
        reminderLlb.leftAnchor ~= leftAnchor + 16
        reminderSwitch.centerYAnchor ~= reminderLlb.centerYAnchor
        reminderSwitch.rightAnchor ~= rightAnchor - 16
        timeLbl.leftAnchor ~= reminderLlb.leftAnchor
        timeLbl.topAnchor ~= reminderLlb.bottomAnchor + 18
    }
}

// MARK: - Save Button Cell
final class SaveButtonCell: UICollectionViewCell {
    var viewModel: SaveButtonModel? {
        didSet {
            guard let viewModel else { return }
            content.nameImgForButton = viewModel.title
        }
    }
    
    var actionHandler: (SaveButtonView.Action) -> Void {
        get {
            content.actionHandler
        }
        set {
            content.actionHandler = newValue
        }
    }
    
    private lazy var content: SaveButtonView = {
        let v = SaveButtonView()
        contentView.addSubview(v)
        v.pinToSuperview()
        return v
    }()
}

final class SaveButtonView: View {
    
    var nameImgForButton: String? {
        didSet {
            guard let nameImgForButton else { return }
//            button.setBackgroundImage(UIImage(named: nameImgForButton), for: .normal)
        }
    }
    enum Action {
        case save
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    private lazy var button: UIButton = {
        let view = UIButton.greenButtonSaveCarePlan
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    self.actionHandler(.save)
                }
            ),
            for: .touchUpInside
        )
        return view
    }()
    
    override func setupContent() {
        addSubview(button)
    }
    
    override func setupLayout() {
        button.pinToSuperview()
    }
}
