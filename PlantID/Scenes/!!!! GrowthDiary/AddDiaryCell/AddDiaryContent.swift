//
//  AddDiaryContent.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 16.09.25.
//

import UIKit

final class AddDiaryContent: View {
    
    enum Action {
        case addPhoto
    }
    var actionHandler: (Action) -> Void = { _ in }
    
    struct Model {
        var photo: UIImage? = nil
        var name: String? = nil
        var notes: [Note] = []
        
        struct Note {
            let title: String
            let text: String
        }
    }
    
    var viewModel: Model? {
        didSet {
            guard let viewModel else { return }
            
            if let photo = viewModel.photo {
                addPhoto.setBackgroundImage(photo, for: .normal)
            }
            
            if let name = viewModel.name {
                fieldName.text = name
            }
            
            notesStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            viewModel.notes.forEach { note in
                createNote(model: note)
            }
        }
    }
    
    private lazy var addPhoto: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(
            UIImage(named: "empty_photo_add_diary"),
            for: .normal
        )
        view.addAction(
            UIAction(
                handler: { [weak self] _ in
                guard let self else { return }
                self.actionHandler(.addPhoto)
            }),
            for: .touchUpInside
        )
        view.widthAnchor ~= 88
        view.heightAnchor ~= 88
        view.layer.cornerRadius = 44
        view.clipsToBounds = true
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
    
    private lazy var fieldName: CustomTF = {
        let view = CustomTF()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = TextForAddDiary.addName
        view.backgroundColor = .white
        view.heightAnchor ~= 30
        view.layer.cornerRadius = 12
        view.font = UIFont(name: "Poppins-Medium", size: 14)
        return view
    }()
    
    private lazy var notesStack: UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        v.spacing = 8
        return v
    }()

    lazy var weekLbl: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = TextForAddDiary.week
        v.font = UIFont(name: "Poppins-Medium", size: 14)
        v.textColor = UIColor(red: 0.008, green: 0.106, blue: 0.004, alpha: 1)
        v.numberOfLines = 1
        v.widthAnchor ~= 70
        return v
    }()
    
    private lazy var fieldWeekNumber: CustomTF = {
        let view = CustomTF()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = TextForAddDiary.addWeekNumber
        view.backgroundColor = .white
        view.keyboardType = .numberPad
        view.heightAnchor ~= 30
        view.layer.cornerRadius = 12
        view.font = UIFont(name: "Poppins-Medium", size: 14)
        return view
    }()
    
    private lazy var note: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.isEditable = true
        view.isSelectable = true
        view.heightAnchor ~= 130
        view.layer.cornerRadius = 15
        view.font = UIFont(name: "Poppins-Medium", size: 14)
        return view
    }()
    
    override func setupContent() {
        backgroundColor = #colorLiteral(red: 0.8826828599, green: 0.9425830245, blue: 0.8319913745, alpha: 1)
        layer.cornerRadius = 20
        addSubview(addPhoto)
        addSubview(title)
        addSubview(fieldName)
        addSubview(notesStack)
        addSubview(weekLbl)
        addSubview(fieldWeekNumber)
        addSubview(note)
    }
    
    override func setupLayout() {
        addPhoto.topAnchor ~= topAnchor + 12
        addPhoto.leftAnchor ~= leftAnchor + 12
        
        title.centerYAnchor ~= addPhoto.centerYAnchor
        title.leftAnchor ~= addPhoto.rightAnchor + 14
        title.rightAnchor ~= rightAnchor - 10
        
        fieldName.topAnchor ~= title.bottomAnchor + 5
        fieldName.leftAnchor ~= title.leftAnchor
        fieldName.rightAnchor ~= rightAnchor - 12
        
        notesStack.topAnchor ~= addPhoto.bottomAnchor + 25
        notesStack.leftAnchor ~= addPhoto.leftAnchor
        notesStack.rightAnchor ~= fieldName.rightAnchor
//        notesStack.bottomAnchor ~= bottomAnchor - 10
        
        weekLbl.topAnchor ~= notesStack.bottomAnchor + 16
        weekLbl.leftAnchor ~= addPhoto.leftAnchor
        
        fieldWeekNumber.centerYAnchor ~= weekLbl.centerYAnchor
        fieldWeekNumber.leftAnchor ~= weekLbl.rightAnchor + 10
        fieldWeekNumber.rightAnchor ~= rightAnchor - 12
        
        note.topAnchor ~= fieldWeekNumber.bottomAnchor + 12
        note.leftAnchor ~= leftAnchor + 12
        note.rightAnchor ~= rightAnchor - 12
        note.bottomAnchor ~= bottomAnchor - 12
    }
    
    private func createNote( model: Model.Note) {
        let noteView = NoteView()
        noteView.title.text = model.title
        noteView.text.text = model.text
        notesStack.addArrangedSubview(noteView)
    }
}


fileprivate class CustomTF: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
    }
}
