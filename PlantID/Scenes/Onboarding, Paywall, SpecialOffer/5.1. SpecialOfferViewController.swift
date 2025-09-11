//
//  SpecialOfferViewController.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 8.07.25.
//

import UIKit

final class SpecialOfferViewController: UIViewController {
    
    private lazy var rootView = SpecialOfferView()
    
    private var timer: Timer?
    private var endDate: Date!
    
    override func loadView() {
        view = rootView
        rootView.actionHandler = { [weak self] action in
            guard let self else { return }
            switch action {
            case .cont:
                self.getSpecialOffer()
            case .cancel:
                self.cancelView()
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // стартуем отсчет 30 минут
        startCountdown(minutes: 30)
        tabBarController?.hideTabBar(true)
        rootView.currentPage = 5
    }
    
    private func getSpecialOffer() {
        guard timer != nil else { return }
        
        ProFeatureService.shared.purchase(.sales) { [weak self] response in
            guard let self else { return }
            
            switch response {
            case .success():
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            case .failure(let error):
                print("🛑 🛑 🛑 Ошибка при совершении покупки - - -", error)
                let alert = UIAlertController(
                    title: "Payment error",
                    message: "Please try paying for your subscription later.",
                    preferredStyle: .alert
                )
                alert.addAction(.init(title: "OK", style: .default))
                present(alert, animated: true)
            }
        }
    }
    
    private func cancelView() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func startCountdown(minutes: Int) {
        // вычисляем дату конца
        endDate = Date().addingTimeInterval(TimeInterval(minutes * 60))
        // сразу покажем текущее время
        updateCountdown()
        
        // запускаем таймер каждые 0.01 секунды
        timer = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(onTimerTick),
            userInfo: nil,
            repeats: true
        )
        // чтобы он работал во время скроллинга/UI-активностей
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    @objc private func onTimerTick() {
        updateCountdown()
    }
    
    private func updateCountdown() {
        let remaining = endDate.timeIntervalSinceNow
        if remaining <= 0 {
            // время вышло — останавливаем таймер и выставляем нули
            timer?.invalidate()
            timer = nil
            rootView.min = 0
            rootView.sec = 0
            rootView.mil = 0
            return
        }
        
        // минуты
        let minutes = Int(remaining) / 60
        // секунды
        let seconds = Int(remaining) % 60
        // сотые доли
        let fraction = remaining - floor(remaining)
        let centiseconds = Int(fraction * 100)
        
        // обновляем твой View
        rootView.min = minutes
        rootView.sec = seconds
        rootView.mil = centiseconds
    }
    
    deinit {
        timer?.invalidate()
    }
}
