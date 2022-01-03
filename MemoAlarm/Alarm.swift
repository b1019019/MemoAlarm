//
//  AlarmData.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2021/12/26.
//

import UIKit

class Alarm: NSObject, NSCoding {
    static var supportsSecureCoding = false
    
    var name: String
    var note: String
    var ringTiming: DateComponents
    var isRepeated: Bool
    var isRingable: Bool
    var id = NSUUID().uuidString
    
    init(name: String, note: String, ringTime: DateComponents, isRepeated: Bool, isRingable: Bool) {
        self.name = name
        self.note = note
        self.ringTiming = ringTime
        self.isRepeated = isRepeated
        self.isRingable = isRingable
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as! String
        note = coder.decodeObject(forKey: "note") as! String
        ringTiming = coder.decodeObject(forKey: "ringTiming") as! DateComponents
        isRepeated = coder.decodeBool(forKey: "isRepeated") as! Bool
        isRingable = coder.decodeBool(forKey: "isRingable") as! Bool
        id = coder.decodeObject(forKey: "id") as! String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: "name")
        coder.encode(self.note, forKey: "note")
        coder.encode(self.ringTiming, forKey: "ringTiming")
        coder.encode(self.isRepeated, forKey: "isRepeated")
        coder.encode(self.isRingable, forKey: "isRingable")
        coder.encode(self.id, forKey: "id")
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
