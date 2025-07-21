//
//  MyPlantsViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 24.06.25.
//

import UIKit

class MyPlantsViewController: UIViewController {

    private lazy var rootView = MyPlantsWhenHavePlants()
    private lazy var emptyRootView = MyPlantsView()
    private lazy var vm = MyPlantsViewModel()
    
    var viewModel: MyPlantsWhenHavePlants.Model? {
        didSet {
            guard let viewModel else { return }
            rootView.viewModel = viewModel
        }
    }
    
    var emptyRoot: Bool = false {
        didSet {
            if emptyRoot == true {
                view = emptyRootView
            } else {
                view = rootView
            }
        }
    }

    override func loadView() {
        view = rootView
        rootView.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .back:
                print("CLICK BACK")
            case .help:
                print("CLICK help")
            case .changeSection:
                print("CLICK changeSection")
            case .viewMore(let index):
                self.showCarePlan(index: index)
            case .addToMyPlants(let index):
                self.addNewPlansAndShowCarePlan(index: index)
            }
        }
        
        emptyRootView.actionHandler = { [weak self] action in
            guard let self else { return }
            if action == .createPlan {
                self.goToSecondController()
            }
        }
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
        rootView.segmetedNumber = 0
        getInf()
    }
    
    @objc private func getNotifiction() {
        getInf()
    }
    
    private func getInf() {
        vm.getArrayOfPlants { [weak self] in
            guard let self = self else { return }
            print("🌱 Данные загружены:", self.vm.history.count)
            
            var myArray: [MyPlantsWhenHavePlantsContent.Model] = []
            self.vm.myPlants.forEach { my in
                let photoData = (my.photos as? [Data])?.first
                let image = photoData.flatMap(UIImage.init(data:))
                
                myArray.append(
                    .init(photo: image,
                          name: my.plantName,
                          descr: my.plantDescr,
                          amountVal: Int(my.amountVal)))
            }

            var array: [HistoryWhenHavePlantsContent.Model] = []
            self.vm.history.forEach { his in
                let photoData = (his.photos as? [Data])?.first
                let image = photoData.flatMap(UIImage.init(data:))
                
                array.append(
                    .init(
                        photo: image,
                        name: his.plantName,
                        descr: his.plantDescr
                    )
                )
            }
            self.viewModel =
                .init(
                    my: myArray,
                    history: array
                )
            if myArray == [] && array == [] {
                emptyRoot = true
            } else {
                emptyRoot = false
            }
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
//        vc.modalPresentationStyle = .overFullScreen
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
//        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    private func goToSecondController() {
        if let tbc = self.tabBarController {
            tbc.selectedIndex = 1
        }
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
