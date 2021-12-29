//
//  AlarmData.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2021/12/26.
//

import UIKit

class Alarm {
    var name: String
    var note: String
    var ringTiming: DateComponents
    var isRepeated: Bool
    var isRingable: Bool
    let id = NSUUID().uuidString
    
    init(name: String, note: String, ringTime: DateComponents, isRepeated: Bool, isRingable: Bool) {
        self.name = name
        self.note = note
        self.ringTiming = ringTime
        self.isRepeated = isRepeated
        self.isRingable = isRingable
    }
    
    func set() {
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = "アラーム"
        content.subtitle = name
        content.body = note
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: ringTiming, repeats: isRepeated)
        
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
