//
//  NotificationSetter.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/02/14.
//
import UIKit

protocol NotificationManager {
    func setNotification(alarm: Alarm)
    func releaseNotification(alarm: Alarm)
    func existNotification(alarm: Alarm) -> Bool
}

final class UserNotificationManager: NotificationManager {
    func setNotification(alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "アラーム"
        content.subtitle = alarm.name
        content.body = alarm.note
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: alarm.ringTiming, repeats: false)
        
        let request = UNNotificationRequest(identifier: alarm.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request){ (error : Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func releaseNotification(alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.id])
    }
    
    func existNotification(alarm: Alarm) -> Bool {
        let semaphore = DispatchSemaphore(value: 0)
        var result = false
        UNUserNotificationCenter.current().getPendingNotificationRequests() {
            if $0.map({ $0.identifier }).contains(alarm.id) {
                result = true
            }
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }
}

