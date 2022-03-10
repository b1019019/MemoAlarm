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
        guard let storedData = UserDefaults.standard.object(forKey: "alarms") as? Data else { return [] }
        do {
            guard let unarchivedObject = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData) as? [Alarm] else { return [] }
            return unarchivedObject
        } catch {
            return []
        }
    }
    
    func storeAlarms(alarms: [Alarm]) throws {
        let archivedData = try! NSKeyedArchiver.archivedData(withRootObject: alarms, requiringSecureCoding: false)
        UserDefaults.standard.set(archivedData, forKey: "alarms")
    }
}
