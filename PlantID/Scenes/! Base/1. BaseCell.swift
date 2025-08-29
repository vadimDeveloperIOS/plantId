//
//  BaseCell.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 29.08.25.
//

import UIKit

class BaseCell: View {
    
    var colorForCell: UIColor? {
        didSet {
            if let colorForCell {
                backgroundColor = colorForCell
            }
        }
    }
    
    var acolorForCell: [UIColor] = [#colorLiteral(red: 0.7268947959, green: 0.8790093064, blue: 0.4223229885, alpha: 1), #colorLiteral(red: 0.6784567833, green: 0.835986197, blue: 0.5326029062, alpha: 1), #colorLiteral(red: 0.7602327466, green: 0.8659850955, blue: 0.6632146835, alpha: 1), #colorLiteral(red: 0.8830724359, green: 0.9430875778, blue: 0.8293510079, alpha: 1), #colorLiteral(red: 0.8801065683, green: 0.9350890517, blue: 0.7774763703, alpha: 1)]
    
    override func setupContent() {
        
    }
    
    override func setupLayout() {
        
    }
}
