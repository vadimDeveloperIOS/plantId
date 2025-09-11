//
//  MyPlantsViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 24.06.25.
//

import UIKit

class MyPlantsViewController: UIViewController {

    let rootView = MyPlantsWhenHavePlants()
//    private lazy var emptyRootView = MyPlantsView()
    private lazy var vm = MyPlantsViewModel()
    
    var viewModel: MyPlantsWhenHavePlants.Model? {
        didSet {
            guard let viewModel else { return }
            rootView.viewModel = viewModel
        }
    }
    
    var emptyRoot: Bool = false {
        didSet {
//            if emptyRoot == true {
//                view = emptyRootView
//            } else {
//                view = rootView
//            }
        }
    }
    
    var numberSegmented: Int = 0

    override func loadView() {
        view = rootView
        rootView.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .back:
                break
            case .setting:
                self.tabBarController?.selectedIndex = 4
            }
        }
        rootView.actionHandlerChild = { [weak self] action in
            guard let self else { return }
            
            switch action {
            case .viewAll(index: let index):
                self.showCarePlan(index: index)
            case .add(index: let index):
                self.addNewPlansAndShowCarePlan(index: index)
            }
        }
        
//        emptyRootView.actionHandler = { [weak self] action in
//            guard let self else { return }
//            if action == .createPlan {
////                self.goToSecondController()
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(getNotifiction),
            name: .needUpdateInfornation,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootView.segmetedNumber = numberSegmented
        getInf()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        numberSegmented = 0
    }
    
    @objc private func getNotifiction() {
        getInf()
    }
    
    private func getInf() {
        vm.getArrayOfPlants { [weak self] in
            guard let self = self else { return }
            
            let myPlantsData: [ContentForMyPlants.BigCellModel] = self.vm.myPlants.compactMap {
                
                let photoData = ($0.photos as? [Data])?.first
                let image = photoData.flatMap(UIImage.init(data:))
    
                return .init(
                    photo: image ?? UIImage(named: "not.plant.1")!,
                    firstText: $0.plantName ?? "No value",
                    secondText: $0.plantDescr ?? "No value",
                    cellStyle: .homeHistory,
                    carePlan: Int($0.amountVal)
                )
            }
            
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
            
            self.viewModel =
                .init(
                    my: myPlantsData,
                    history: historyData
                )
        }
    }
    
    private func addNewPlansAndShowCarePlan(index: Int) {
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
    
    private func showCarePlan(index: Int) {
        guard index >= 0, index < vm.myPlants.count else { return }
        
        let vc = CarePlanViewController()
        let plant = vm.myPlants[index]
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
                frequencyVal: plant.frequencyVal,
                reminderVal: plant.reminderVal,
                amountVal: Int(plant.amountVal)
            )
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    
    /*
     private func showIdent(_ index: Int) {
     guard index >= 0, index < vm.myPlants.count else { return }
     
     let vc = AboutPlantsViewController()
     let plant = vm.myPlants[index]
     let photosDataArray = (plant.photos as? [Data])
     let images: [UIImage] = photosDataArray?.compactMap { UIImage(data: $0) } ?? []
     
     vc.viewModel = .init(
     name: plant.plantName ?? "NO VALUE",
     description: plant.plantDescr,
     photos: images,
     size: plant.plantSize,
     humidity: plant.plantHumidity,
     spraying: plant.plantSpraying,
     fertilize: plant.plantFertilize
     )
     present(vc, animated: true)
     }
     
     */
    
}
