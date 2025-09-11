//
//  HomeViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 23.06.25.
//

import UIKit

class HomeViewController: UIViewController {
    
    private lazy var rootView = HomeView()
    private lazy var vm = HomeViewModel()
    
    var viewModel: HomeView.Model? {
        didSet {
            guard let viewModel else { return }
            rootView.viewModel = viewModel
        }
    }
    
    var dontHavePlant: Bool = false

    override func loadView() {
        view = rootView
        rootView.actionHandler = { [weak self] action in
            
            guard let self else { return }
            switch action {
            case .readMore:
                print("")
            case .add(indexPath: let indexPath):
                if dontHavePlant == false {
                    self.showCarePlan(index: indexPath)
                } else {
                    self.tabBarController?.selectedIndex = 2
                }
            case .viewAllMyPlants:
                self.showMyPlantsCont(0)
            case .viewAllHistory:
                self.showMyPlantsCont(1)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationService.shared.requestAuthorization { granted in
            if granted {
                print("Пользователь разрешил уведомления")
            } else {
                print("Пользователь запретил уведомления")
            }
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getNotifiction),
            name: .needUpdateInfornation,
            object: nil
        )
        hideKeyboardWhenTappedAround()
        ProFeatureService.shared.updateStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.hideTabBar(false)
        getInf()
    }
    
    @objc private func getNotifiction() {
        getInf()
    }
    
    private func getInf() {
        vm.getArrayOfPlants { [weak self] in
            guard let self = self else { return }
                        
            let myPlantsData: [MyPlantsCellContent.Model] = self.vm.myPlants.compactMap {
                
                let photoData = ($0.photos as? [Data])?.first
                let image = photoData.flatMap(UIImage.init(data:))
                
                return .init(
                    image: image ?? UIImage(named: "not.plant.1")!,
                    name: $0.plantName ?? "No value",
                    carePlan: Int($0.amountVal)
                )
            }
            let plugMyPlants = [ MyPlantsCellContent.Model(
                    image: UIImage(named: "not.plant.1")!,
                    name: "Add a plant",
                    carePlan: 1
                )
            ]
            let historyData: [HistoryCellContent.BigCellModel] = self.vm.history.compactMap {
                
                let photoData = ($0.photos as? [Data])?.first
                let image = photoData.flatMap(UIImage.init(data:))
                
                return .init(
                    photo: image ?? UIImage(named: "not.plant.1")!,
                    firstText: $0.plantName ?? "No value",
                    secondText: $0.plantDescr ?? "No value",
                    cellStyle: .homeHistory
                )
            }
            let plugHistory = [ HistoryCellContent.BigCellModel(
                photo: UIImage(named: "not.plant.2")!,
                firstText: "you_do_not_have_any_verified_plants".localized,
                secondText: "identify_232323".localized,
                cellStyle: .homeHistory
                )
            ]
            
            dontHavePlant = historyData == [] && myPlantsData == []
            
            self.viewModel =
                .init(
                    search:
                            .init(
                                textForWeather: " "
                            ),
                    learnAboutPlants: [
                        .init(
                            photo: UIImage(named: "fake123")!,
                            firstText: "Some text2",
                            secondText: "Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9",
                            cellStyle: .homeLearnAboutPlants
                        ),
                        .init(
                            photo: UIImage(named: "fake123")!,
                            firstText: "Some text4",
                            secondText: "Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9",
                            cellStyle: .homeLearnAboutPlants
                        )
                    ],
                    myPlants: myPlantsData,
                    history: historyData == [] && myPlantsData == [] ? plugHistory : historyData
                )
        }
    }
    
    private func showCarePlan(index: Int) {
                
        guard index >= 0, index < vm.history.count else { return }
        
        let vc = CarePlanViewController()
        let plant = vm.history[index]
        let photoData = (plant.photos as? [Data])?.first
        let image = photoData.flatMap(UIImage.init(data:))
                
        vc.viewModel =
            .init(
                id: plant.id,
                didAddToMyPlans: plant.didAddToMyPlants,
                name: plant.plantName ?? "NO VALUE",
                healthNote: plant.plantDescr ?? "NO VALUE",
                image: image ?? UIImage(named: "fake123")!,
                photos: [image ?? UIImage(named: "fake123")!],
                frequencyVal: nil,
                reminderVal: nil,
                amountVal: nil
            )
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    func showScan() {
        let vc = ScanViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showMyPlantsCont(_ segmented: Int) {
        
        if let nav = self.tabBarController?.viewControllers?[3] as? UINavigationController,
           let vc = nav.viewControllers.first as? MyPlantsViewController {
            
            vc.numberSegmented = segmented
        }
        self.tabBarController?.selectedIndex = 3
    }
}
