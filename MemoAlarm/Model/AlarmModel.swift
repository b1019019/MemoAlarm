//
//  AlarmModel.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/01/08.
//

import Foundation
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
        isRepeated = coder.decodeBool(forKey: "isRepeated")
        isRingable = coder.decodeBool(forKey: "isRingable")
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
}

protocol DatabaseIO {
    func fetchAlarms() throws -> [Alarm]
    func storeAlarms(alarms: [Alarm]) throws
}

protocol UserNotificationSetter {
    func setNotification(alarm: Alarm)
    func releaseNotification(alarm: Alarm)
    func existNotification(alarm: Alarm) -> Bool
}

class AlarmModel: DatabaseIO, UserNotificationSetter {
    func fetchAlarms() throws -> [Alarm] {
        let storedData = UserDefaults.standard.object(forKey: "alarms") as! Data
        let unarchivedObject = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData) as! [Alarm]
        unarchivedObject.map{print("fetchData",$0.isRingable,$0.name)}
        return unarchivedObject
    }
    
    func storeAlarms(alarms: [Alarm]) throws {
        alarms.map{print("storeData",$0.isRingable,$0.name)}
        let archivedData = try! NSKeyedArchiver.archivedData(withRootObject: alarms, requiringSecureCoding: false)
        UserDefaults.standard.set(archivedData, forKey: "alarms")
    }
    
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
