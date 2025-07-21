//
//  SupportService.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 18.07.25.
//

import Foundation
import MessageUI


final class SupportService {
    
    static let shared = SupportService()
    private init() {}
    
    func presentSupport(from host: UIViewController & MFMailComposeViewControllerDelegate) {
        
        guard MFMailComposeViewController.canSendMail() else {
            if let url = URL(string: "mailto:\("arxivicedorona11364@gmail.com")"),
                    UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                return
            }
            
            let alert = UIAlertController(
              title: "Mail's unavailable",
              message: "Please set up an email account on your device.",
              preferredStyle: .alert
            )
            alert.addAction(.init(title: "OK", style: .default))
            host.present(alert, animated: true)
            return
        }
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = host
        mailVC.setToRecipients(["arxivicedorona11364@gmail.com"])
        mailVC.setSubject("Requesting Plant ID application support")
        mailVC.setMessageBody(
                        """
                        Hello!
                        
                        Please describe your issue/question about the app.:
                        
                        """,
                        isHTML: false
        )
        host.present(mailVC, animated: true)
    }
}
