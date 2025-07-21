//
//  PrivacyPolicyAndTermsOfUseService.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 18.07.25.
//

import UIKit
import WebKit

extension UIViewController {
    
    func presentPrivacyPolicy() {
        guard let url = URL(
            string: "https://docs.google.com/document/d/1ObiFjSCKOP1a9R3ORDK6imxR1w93KWmkTUtui6ft218/edit?usp=sharing"
        ) else { return }
        
        let webVC = UIViewController()
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webVC.view.addSubview(webView)
        webView.pinToSuperview()
        webView.load(URLRequest(url: url))
        
        present(webVC, animated: true)
    }
    
    func presentTermsOfUse() {
        guard let url = URL(
            string: "https://docs.google.com/document/d/1gTtuS4R0DBbzywTP5JU78owKz1-5fW6CyKN9Av1uhRM/edit?usp=sharing"
        ) else { return }
        
        let webVC = UIViewController()
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webVC.view.addSubview(webView)
        webView.pinToSuperview()
        webView.load(URLRequest(url: url))
        
        present(webVC, animated: true)
    }
}
