//
//  AlarmData.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2021/12/26.
//

import UIKit

enum RepeatDate {
    case everyMonday
    case everyTuesday
    case everyWednesday
    case everyThursday
    case everyFriday
    case everySaturday
    case everySunday
}

class Alarm {
    var name: String
    var note: String
    var ringTime: DateComponents
    var repeatDates: Set<RepeatDate>
    var isRingable: Bool
    let id = NSUUID().uuidString
    
    init(name: String, note: String, ringTime: DateComponents, repeatDates: Set<RepeatDate>, isRingable: Bool) {
        self.name = name
        self.note = note
        self.ringTime = ringTime
        self.repeatDates = repeatDates
        self.isRingable = isRingable
    }
    
    func set() {
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "アラーム"
        content.subtitle = name
        content.body = note
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: ringTime, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request){ (error : Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func release() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
