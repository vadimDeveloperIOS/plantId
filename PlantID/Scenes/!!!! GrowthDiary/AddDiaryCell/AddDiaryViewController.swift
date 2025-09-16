//
//  AddDiaryViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 16.09.25.
//

import UIKit

final class AddDiaryViewController: UIViewController {
    
    private let root = AddDiaryView()
    
    var viewModel: AddDiaryView.Model? {
        didSet {
            guard let viewModel else { return }
            root.viewModel = viewModel
        }
    }
    
    override func loadView() {
        view = root
        
        root.actionHandler = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .back:
                break
            case .setting:
                break
            }
        }
        root.actionHandlerChild = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .addPhoto:
                break
            case .save:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        let keyboardHeight = frame.height
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardHeight / 2  // 👈 поднимаем экран
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0  // 👈 возвращаем обратно
        }
    }
}
