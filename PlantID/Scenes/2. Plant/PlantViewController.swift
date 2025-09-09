//
//  PlantViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 24.06.25.
//

import UIKit

class PlantViewController: UIViewController {

    private lazy var root = MyplantsN()

    override func loadView() {
        view = root
        
        root.actionHandlerChild = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .enableCamera:
                self.showScan()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabBar(false)
    }
    
    func showScan() {
        let vc = ScanViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
