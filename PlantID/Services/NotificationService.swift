//
//  NotificationService.swift
//  PlantID
//
//  Created by Вадим Игнатенко on 14.07.25.
//

import UserNotifications


final class NotificationService {
    static let shared = NotificationService()
    private let center = UNUserNotificationCenter.current()

    private init() {}

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            completion(granted)
        }
    }

    func scheduleWateringNotification(for plantId: UUID, plantName: String, frequency: OptionsForFrequency) {
        removeNotification(for: plantId)
        let content = UNMutableNotificationContent()
        content.title = "plant_care".localized
        content.body = "\(plantName)" + " " + "plant_needs_care".localized
        content.sound = .default

        let trigger = makeTrigger(for: frequency)
        let request = UNNotificationRequest(identifier: plantId.uuidString, content: content, trigger: trigger)
        center.add(request) { error in
            if let err = error {
                print("❌ Ошибка при добавлении нотификации:", err)
            }
        }
    }

    func removeNotification(for plantId: UUID) {
        center.removePendingNotificationRequests(withIdentifiers: [plantId.uuidString])
    }

    func removeAllNotifications() {
        center.removeAllPendingNotificationRequests()
    }
    
    /// Проверяет текущий статус разрешений на уведомления и возвращает его в замыкании
    func checkAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    private func makeTrigger(
        for frequency: OptionsForFrequency,
        hour: Int = 9,
        minute: Int = 0
    ) -> UNNotificationTrigger {
        
        switch frequency {
        case .every3Days:
            // чтобы было примерно в 9:00, запустите этот метод около 9 утра
            let interval = TimeInterval(3 * 24 * 60 * 60)
            return alignmentDate(interval)
            
        case .onceAWeek:
            // раз в неделю в тот же день недели, что сегодня, в 9:00
            let weekday = Calendar.current.component(.weekday, from: Date())
            var dc = DateComponents()
            dc.weekday = weekday
            dc.hour    = hour
            dc.minute  = minute
            return UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
            
        case .onceEveryTwoWeeks:
            let interval = TimeInterval(14 * 24 * 60 * 60)
            return alignmentDate(interval)

        case .onceAMonth:
            // в тот же день месяца, что сегодня, в 9:00
            let day = Calendar.current.component(.day, from: Date())
            var dc = DateComponents()
            dc.day    = day
            dc.hour   = hour
            dc.minute = minute
            return UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
        }
    }
    
    private func alignmentDate(_ interval: TimeInterval) -> UNCalendarNotificationTrigger {
        
        let now = Date()
        let futureDate = now.addingTimeInterval(interval)
        
        var comps = Calendar.current.dateComponents([.year, .month, .day], from: futureDate)
        comps.hour   = 9
        comps.minute = 0
        return UNCalendarNotificationTrigger(dateMatching: comps, repeats: true)
    }
}


extension Notification.Name {
    static let needUpdateInfornation = Notification.Name("UpdateInformation")
}
