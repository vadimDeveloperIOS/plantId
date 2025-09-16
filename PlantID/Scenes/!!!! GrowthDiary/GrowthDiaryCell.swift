//
//  GrowthDiaryCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 16.09.25.
//

import UIKit

// ----------------------------------------------------
// MARK: - CELL
// ----------------------------------------------------

final class GrowthDiaryCell: UICollectionViewCell {
    
    var viewModel: GrowthDiaryContent.Model? {
        didSet {
            content.viewModel = viewModel
        }
    }
    
    var actionHandler: (GrowthDiaryContent.Action) -> Void {
        get { content.actionHandler }
        set { content.actionHandler = newValue }
    }
    
    private lazy var content: GrowthDiaryContent = {
        let v = GrowthDiaryContent()
        contentView.addSubview(v)
        v.pinToSuperview()
        return v
    }()
}

// ----------------------------------------------------
// MARK: - CONTENT
// ----------------------------------------------------

final class GrowthDiaryContent: View {
    
    // MARK: Action
    enum Action {
        case edit
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    struct Model: Hashable {
        let photo: UIImage
        let name: String
        let notes: [NoteModel]
        
        struct NoteModel: Hashable {
            let noteTitle: String
            let noteText: String
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(notes)
        }

        static func == (lhs: Model, rhs: Model) -> Bool {
            lhs.name == rhs.name && lhs.notes == rhs.notes
        }
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            
            iconnn.image = viewModel.photo
            namePlantLbl.text = viewModel.name
            
            notesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            viewModel.notes.forEach { note in
                createNote(model: note)
            }
        }
    }
    
    private lazy var iconnn: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor ~= 88
        view.heightAnchor ~= 88
        return view
    }()
    
    private lazy var title: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = TextForGrowthDiary.planName
        v.font = UIFont(name: "Poppins-Medium", size: 16)
        v.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 1)
        v.numberOfLines = 1
        return v
    }()
    
    private lazy var namePlantLbl: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "Poppins-Medium", size: 16)
        v.textColor = #colorLiteral(red: 0.2876631618, green: 0.6002591252, blue: 0.1514803171, alpha: 1)
        v.numberOfLines = 2
        return v
    }()
    
    private lazy var editBtn: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setBackgroundImage(
            UIImage(named: "notes_edit"),
            for: .normal
        )
        b.addAction(
            UIAction { [weak self] _ in
                guard let self else { return }
                self.actionHandler(.edit)
            },
            for: .touchUpInside
        )
        b.widthAnchor ~= 40
        b.heightAnchor ~= 40
        return b
    }()
    
    private lazy var notesStack: UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        v.spacing = 8
        return v
    }()
    
    override func setupContent() {
        backgroundColor = #colorLiteral(red: 0.8826828599, green: 0.9425830245, blue: 0.8319913745, alpha: 1)
        layer.cornerRadius = 20
        addSubview(iconnn)
        addSubview(title)
        addSubview(namePlantLbl)
        addSubview(editBtn)
        addSubview(notesStack)
    }
    
    override func setupLayout() {
        iconnn.topAnchor ~= topAnchor + 12
        iconnn.leftAnchor ~= leftAnchor + 12
        
        title.centerYAnchor ~= iconnn.centerYAnchor
        title.leftAnchor ~= iconnn.rightAnchor + 10
        title.rightAnchor ~= editBtn.leftAnchor - 2
        
        namePlantLbl.topAnchor ~= title.bottomAnchor + 5
        namePlantLbl.leftAnchor ~= title.leftAnchor
        namePlantLbl.rightAnchor ~= rightAnchor - 12
        
        editBtn.topAnchor ~= iconnn.topAnchor
        editBtn.rightAnchor ~= rightAnchor - 12
        
        notesStack.topAnchor ~= iconnn.bottomAnchor + 15
        notesStack.leftAnchor ~= iconnn.leftAnchor
        notesStack.rightAnchor ~= editBtn.rightAnchor
        notesStack.bottomAnchor ~= bottomAnchor - 10
        
    }
    
    private func createNote( model: Model.NoteModel) {
        let noteView = NoteView()
        noteView.title.text = model.noteTitle
        noteView.text.text = model.noteText
        notesStack.addArrangedSubview(noteView)
    }
}

// MARK: NOTE VIEW

final class NoteView: View {
    
    lazy var title: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = TextForGrowthDiary.planName
        v.font = UIFont(name: "Poppins-Medium", size: 14)
        v.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 1)
        v.numberOfLines = 1
        v.widthAnchor ~= 70
        return v
    }()
    
    lazy var text: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "Poppins-Regular", size: 14)
        v.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 1)
        v.numberOfLines = 0
        return v
    }()
    
    private lazy var whiteView: View = {
        let view = View()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    override func setupContent() {
        backgroundColor = .clear
        addSubview(title)
        addSubview(whiteView)
        whiteView.addSubview(text)
    }
    
    override func setupLayout() {
        title.topAnchor ~= topAnchor + 5
        title.leftAnchor ~= leftAnchor
        
        whiteView.topAnchor ~= topAnchor
        whiteView.leftAnchor ~= title.rightAnchor + 10
        whiteView.rightAnchor ~= rightAnchor
        whiteView.bottomAnchor ~= bottomAnchor
        
        text.topAnchor ~= whiteView.topAnchor + 5
        text.leftAnchor ~= whiteView.leftAnchor + 5
        text.rightAnchor ~= whiteView.rightAnchor - 5
        text.bottomAnchor ~= whiteView.bottomAnchor - 5
        
        whiteView.layer.cornerRadius = 12
    }
}

