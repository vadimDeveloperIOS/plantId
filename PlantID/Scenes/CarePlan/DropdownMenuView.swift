//
//  DropdownMenuView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 8.07.25.
//

import UIKit

enum OptionsForFrequency: String, CaseIterable {
    case every3Days = "every_3_days"
    case onceAWeek = "once_a_week"
    case onceEveryTwoWeeks = "once_every_two_weeks"
    case onceAMonth = "once_a_month"
}

final class DropdownMenuView: UIView {
    
    var options = OptionsForFrequency.allCases
    var didSelectOption: ((OptionsForFrequency) -> Void)?
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.layer.cornerRadius = 12
        tv.delegate = self
        tv.dataSource = self
        tv.isScrollEnabled = false
        tv.separatorStyle = .none
        tv.backgroundColor = .white
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tv.layer.shadowColor = UIColor.black.cgColor
//        tv.layer.shadowOpacity = 0.1
//        tv.layer.shadowRadius = 4
//        tv.layer.shadowOffset = CGSize(width: 0, height: 2)
        return tv
    }()
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension DropdownMenuView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row].rawValue.localized
        cell.textLabel?.font = UIFont(name: "Onest-Regular", size: 14)
        cell.textLabel?.textColor = .gray
        cell.selectionStyle = .none
        cell.backgroundColor = .white

        // Выделение первой ячейки (для примера)
        if indexPath.row == 0 {
            cell.contentView.backgroundColor = UIColor(red: 0.9, green: 1.0, blue: 0.9, alpha: 1)
            cell.contentView.layer.cornerRadius = 10
        } else {
            cell.contentView.backgroundColor = .white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectOption?(options[indexPath.row])
        removeFromSuperview()
    }
}
