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

    override func loadView() {
        view = rootView
        rootView.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
//            case .addMyPlants(let index):
//                self.showCarePlan(index: index)
            case .readMore:
                print("")
            case .add(indexPath: let indexPath):
                print("")
            case .viewAllMyPlants:
                print("")
            case .viewAllHistory:
                print("")
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
        
        viewModel =
            .init(
                search:
                        .init(
                            textForWeather: "Some text1"
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
                myPlants: [
                    .init(
                        image: UIImage(named: "fake123")!,
                        name: "Some text6",
                        carePlan: 2
                    ),
                    .init(
                        image: UIImage(named: "fake123")!,
                        name: "Some text7",
                        carePlan: 1
                    )
                ],
                history: [
                    .init(
                        photo: UIImage(named: "fake123")!,
                        firstText: "Some text8",
                        secondText: "Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9",
                        cellStyle: .homeHistory
                    ),
                    .init(
                        photo: UIImage(named: "fake123")!,
                        firstText: "Some text10 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9 Some text9",
                        secondText: "Some text11",
                        cellStyle: .homeHistory
                    )
                ]
            )
    }
    
    @objc private func getNotifiction() {
        getInf()
    }
    
    private func getInf() {
//        vm.getArrayOfPlants { [weak self] in
//            guard let self = self else { return }
//            
//            var myWith: [MyPlantsWithPhotoContent.Model] = []
//            self.vm.myPlants.forEach { my in
//                let photoData = (my.photos as? [Data])?.first
//                let image = photoData.flatMap(UIImage.init(data:))
//                myWith.append(
//                    .init(
//                        photo: image,
//                        plantName: my.plantName,
//                        plantDescription: my.plantDescr,
//                        rateWatering: Int(my.amountVal))
//                )
//            }
//            var array: [HistoryWhenHavePlantsContent.Model] = []
//            self.vm.history.forEach { his in
//                let photoData = (his.photos as? [Data])?.first
//                let image = photoData.flatMap(UIImage.init(data:))
//                
//                array.append(
//                    .init(
//                        photo: image,
//                        name: his.plantName,
//                        descr: his.plantDescr
//                    )
//                )
//            }
//            self.viewModel =
//                .init(
//                    myPlantsWithPhoto: myWith,
//                    historyWithPhoto: array,
//                    haveOnCoreDataPlant: myWith == [] ? false : true,
//                    haveOnCoreDataHistory: array == [] ? false : true
//                )
//            
//            if myWith == [] && array == [] {
//                
//                self.viewModel =
//                    .init(
//                        myPlantsWithPhoto: [
//                            .init(
//                                photo: UIImage(named: "not.plant.1") ,
//                                plantName: "Some name",
//                                plantDescription: "Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text ",
//                                rateWatering: 2
//                            )
//                        ],
//                        historyWithPhoto: [
//                            .init(
//                                photo: UIImage(named: "not.plant.2"),
//                                name:  "Some name",
//                                descr: "Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text Some text "
//                            )
//                        ],
//                        haveOnCoreDataPlant: true,
//                        haveOnCoreDataHistory: true
//                    )
//            }
//            
////            coreDataIsEmpty = myWith == [] && array == [] ? true : false
//            coreDataIsEmpty = false
//
//        }
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
