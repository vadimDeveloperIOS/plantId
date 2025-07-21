//
//  HomeViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 23.06.25.
//

import UIKit

class HomeViewController: UIViewController {
    
    private lazy var rootView = HomeView()
    private lazy var emptyRootView = HomeIsEmptyView()
    private lazy var vm = HomeViewModel()
    
    var viewModel: HomeView.Model? {
        didSet {
            guard let viewModel else { return }
            rootView.viewModel = viewModel
        }
    }
    
    var coreDataIsEmpty: Bool = false {
        didSet {
            view = coreDataIsEmpty ? emptyRootView : rootView
        }
    }

    override func loadView() {
        view = rootView
        rootView.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .addMyPlants(let index):
                self.showCarePlan(index: index)
            }
        }
        
        emptyRootView.actionHandler = { [weak self] action in
            guard let self else { return }
            if action == .scan {
                self.showScan()
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
            
            var myWith: [MyPlantsWithPhotoContent.Model] = []
            self.vm.myPlants.forEach { my in
                let photoData = (my.photos as? [Data])?.first
                let image = photoData.flatMap(UIImage.init(data:))
                myWith.append(
                    .init(
                        photo: image,
                        plantName: my.plantName,
                        plantDescription: my.plantDescr,
                        rateWatering: Int(my.amountVal))
                )
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
                    myPlantsWithPhoto: myWith,
                    historyWithPhoto: array,
                    haveOnCoreDataPlant: myWith == [] ? false : true,
                    haveOnCoreDataHistory: array == [] ? false : true
                )
            coreDataIsEmpty = myWith == [] && array == [] ? true : false
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
//        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    func showScan() {
        let vc = ScanViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
