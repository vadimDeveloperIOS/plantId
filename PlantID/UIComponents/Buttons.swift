//
//  Buttons.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 19.06.25.
//

import UIKit

extension UIButton {
    
    static var greenButtonEnableCamera: UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "Empty.Button.Middle"), for: .normal)
        view.widthAnchor ~= 158
        view.heightAnchor ~= 46
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "enable_camera_big".localized
        title.font = UIFont(name: "Onest-SemiBold", size: 14)
        title.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        title.textAlignment = .center
        view.addSubview(title)
        title.centerXAnchor ~= view.centerXAnchor
        title.centerYAnchor ~= view.centerYAnchor
        return view
    }
    
    static var greenButtonCreateCarePlan: UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "Empty.Button.Middle"), for: .normal)
        view.widthAnchor ~= 223
        view.heightAnchor ~= 52
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "create_care_plan_big".localized
        title.font = UIFont(name: "Onest-SemiBold", size: 14)
        title.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        title.textAlignment = .center
        view.addSubview(title)
        title.centerXAnchor ~= view.centerXAnchor
        title.centerYAnchor ~= view.centerYAnchor
        return view
    }
    
    static var greenButtonContinue: UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "Empty.Button"), for: .normal)
        view.widthAnchor ~= 343
        view.heightAnchor ~= 52
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "continue".localized
        title.font = UIFont(name: "Onest-SemiBold", size: 14)
        title.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        title.textAlignment = .center
        view.addSubview(title)
        title.centerXAnchor ~= view.centerXAnchor
        title.centerYAnchor ~= view.centerYAnchor
        return view
    }
    
    static var greenButtonGrabItNow: UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "Empty.Button"), for: .normal)
        view.widthAnchor ~= 343
        view.heightAnchor ~= 52
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "grab_it_now".localized
        title.font = UIFont(name: "Onest-SemiBold", size: 14)
        title.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        title.textAlignment = .center
        view.addSubview(title)
        title.centerXAnchor ~= view.centerXAnchor
        title.centerYAnchor ~= view.centerYAnchor
        return view
    }
    
    static var greenButtonAddToMyPlants: UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "Empty.Button"), for: .normal)
        view.widthAnchor ~= 343
        view.heightAnchor ~= 52
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "add_to_my_plants_big".localized
        title.font = UIFont(name: "Onest-SemiBold", size: 14)
        title.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        title.textAlignment = .center
        view.addSubview(title)
        title.centerXAnchor ~= view.centerXAnchor
        title.centerYAnchor ~= view.centerYAnchor
        return view
    }
    
    static var greenButtonSaveCarePlan: UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "Empty.Button"), for: .normal)
        view.widthAnchor ~= 343
        view.heightAnchor ~= 52
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "save_care_plan_big".localized
        title.font = UIFont(name: "Onest-SemiBold", size: 14)
        title.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        title.textAlignment = .center
        view.addSubview(title)
        title.centerXAnchor ~= view.centerXAnchor
        title.centerYAnchor ~= view.centerYAnchor
        return view
    }
    
    static var greenButtonTryAgain: UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "Empty.Button"), for: .normal)
        view.widthAnchor ~= 343
        view.heightAnchor ~= 52
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = "try_again".localized
        title.font = UIFont(name: "Onest-SemiBold", size: 14)
        title.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        title.textAlignment = .center
        view.addSubview(title)
        title.centerXAnchor ~= view.centerXAnchor
        title.centerYAnchor ~= view.centerYAnchor
        return view
    }
}






