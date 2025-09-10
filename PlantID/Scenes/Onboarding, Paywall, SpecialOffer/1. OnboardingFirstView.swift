//
//  1. OnboardingFirstView.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 10.09.25.
//

import UIKit

final class OnboardingFirstView: BaseOnboardingView {
    
    
    override func setupContent() {
        super.setupContent()
        currentPage = 0
        textFor1Lbl = TextForFirstOnb.instantlyScan
        textFor1GrennLbl = TextForFirstOnb.anyPlant
        textForSecondTitle = TextForFirstOnb.accessSpeciesNamesAnd
        onb = .first
        nameImgForBg = "new_onb_1"
    }
    
    override func setupLayout() {
        super.setupLayout()
    }
}
