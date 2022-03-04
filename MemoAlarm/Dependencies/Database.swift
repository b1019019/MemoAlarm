//
//  Database.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/02/14.
//

import Foundation

protocol DatabaseIO {
    func fetchAlarms() throws -> [Alarm]
    func storeAlarms(alarms: [Alarm]) throws
}

final class UserDefaultsDatabase: DatabaseIO {
    
    private init(){}
    
    static var shared = UserDefaultsDatabase()
    
    func fetchAlarms() throws -> [Alarm] {
        guard let storedData = UserDefaults.standard.object(forKey: "alarms") as? Data else { return [Alarm(name: "テスト", note: "", ringTime: DateComponents(), isRepeated: false, isRingable: false)] }
        do {
            guard let unarchivedObject = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData) as? [Alarm] else { return [Alarm(name: "テスト2", note: "", ringTime: DateComponents(), isRepeated: false, isRingable: false)] }
            unarchivedObject.map{print("fetchData",$0.isRingable,$0.name)}
            return unarchivedObject
        } catch {
            return [Alarm(name: "テスト3", note: "", ringTime: DateComponents(), isRepeated: false, isRingable: false)]
        }

    }
    
    func storeAlarms(alarms: [Alarm]) throws {
        alarms.map{print("storeData",$0.isRingable,$0.name)}
        let archivedData = try! NSKeyedArchiver.archivedData(withRootObject: alarms, requiringSecureCoding: false)
        UserDefaults.standard.set(archivedData, forKey: "alarms")
    }
}
