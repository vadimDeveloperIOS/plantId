//
//  CouldntIdentifyViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 6.07.25.
//

import UIKit

final class CouldntIdentifyViewController: UIViewController {
    
    private lazy var rootView = CouldntIdentifyView()

    override func loadView() {
        view = rootView
        rootView.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .back:
                self.goToBack()
            case .help:
                print("tap HELP")
            case .tryAgain:
                self.tryAgain()
            }
        }
    }
    
    func tryAgain() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func goToBack() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
