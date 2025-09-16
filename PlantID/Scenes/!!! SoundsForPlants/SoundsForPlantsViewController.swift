//
//  SoundsForPlantsViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 16.09.25.
//

import UIKit

final class SoundsForPlantsViewController: UIViewController {
    
    
    private let root = SoundsForPlantsView()
    
    private var viewModel: SoundsForPlantsView.Model? {
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
                self.navigationController?.popToRootViewController(animated: true)
            case .setting:
                self.tabBarController?.selectedIndex = 4
            }
        }
        
        root.actionHandlerChild = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .sound(let act, index: let index):
                switch act {
                case .play:
                    playMusic(index)
                case .pause:
                    stopMusic(index)
                }
            }
        }
    }
    
    private var previousSongIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewModel()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SoundService.shared.stop()
        updateViewModel()
    }
    
    deinit {
        print("🍀 [SoundsForPlantsViewController] - ОСВОБОЖДЕН ИЗ ПАМЯТИ \n")
    }
    
    // MARK: Methods
    
    private func updateViewModel() {
        viewModel =
            .init(
                textForFirstLbl: TextForSounds.title,
                textForSecondLbl: TextForSounds.subtitle,
                
                sounds: [
                    
                    .init(
                        nameIcon: "music_img_11",
                        title: TextForSounds.gentleWhiteNoiseTitle,
                        subtitle: TextForSounds.gentleWhiteNoiseSubtitle,
                        playIconName: "play.fill",
                        pauseIconName: "pause.fill",
                        isPlaying: false
                    ),
                    
                    .init(
                        nameIcon: "music_img_2",
                        title: TextForSounds.waterDropsTitle,
                        subtitle: TextForSounds.waterDropsSubtitle,
                        playIconName: "play.fill",
                        pauseIconName: "pause.fill",
                        isPlaying: false
                    ),
                    
                    .init(
                        nameIcon: "music_img_3",
                        title: TextForSounds.softBreezeTitle,
                        subtitle: TextForSounds.softBreezeSubtitle,
                        playIconName: "play.fill",
                        pauseIconName: "pause.fill",
                        isPlaying: false
                    ),
                    
                    .init(
                        nameIcon: "music_img_4",
                        title: TextForSounds.harmonicTonesTitle,
                        subtitle: TextForSounds.harmonicTonesSubtitle,
                        playIconName: "play.fill",
                        pauseIconName: "pause.fill",
                        isPlaying: false
                    ),
                    
                    .init(
                        nameIcon: "music_img_5",
                        title: TextForSounds.oceanWavesTitle,
                        subtitle: TextForSounds.oceanWavesSubtitle,
                        playIconName: "play.fill",
                        pauseIconName: "pause.fill",
                        isPlaying: false
                    ),
                    
                    .init(
                        nameIcon: "music_img_6",
                        title: TextForSounds.morningBirdsTitle,
                        subtitle: TextForSounds.morningBirdsSubtitle,
                        playIconName: "play.fill",
                        pauseIconName: "pause.fill",
                        isPlaying: false
                    )
                ])
    }
    
    private func playMusic(_ index: Int) {
        guard let viewModel else { return }
        
        var newModel = viewModel
        newModel.sounds[index].isPlaying.toggle()
        
        if let previousSongIndex {
            newModel.sounds[previousSongIndex].isPlaying = false
        }
        self.viewModel = newModel
        previousSongIndex = index
        
        SoundService.shared.playAndUpdateForIndex(index: index)
    }
    
    private func stopMusic(_ index: Int) {
        guard let viewModel,
              viewModel.sounds[index].isPlaying == true
        else { return }
        
        var newViewModel = viewModel
        newViewModel.sounds[index].isPlaying = false
        self.viewModel = newViewModel
        
        SoundService.shared.stop()
    }
}
