//
//  AllGoodHereViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 6.07.25.
//

import UIKit

final class AllGoodHereViewController: UIViewController {
    
    private lazy var rootView = AllGoodHereView()

    override func loadView() {
        view = rootView
    }
    
    func showScan() {
        let vc = ScanViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
