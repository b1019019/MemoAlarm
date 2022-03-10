//
//  NotificationSetter.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/02/14.
//
import UIKit
import RxSwift
import RxCocoa

protocol NotificationManager {
    var willPresent: PublishRelay<String> { get }
    var didReceive: PublishRelay<String> { get }
    func initNotification()
    func setNotification(alarm: Alarm)
    func releaseNotification(alarm: Alarm)
    func existNotification(alarm: Alarm) -> Bool
}

final class UserNotificationManager: NotificationManager {
    
    private init() {}
    
    static var shared = UserNotificationManager()
    
    let willPresent = PublishRelay<String>()
    let didReceive = PublishRelay<String>()
    
    func initNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]){ (granted, _) in
            if granted {
                UNUserNotificationCenter.current().delegate = self
            }
        }
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

extension UserNotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
        willPresent.accept(notification.request.identifier)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        didReceive.accept(response.notification.request.identifier)
    }
}

extension UserNotificationManager: NSObjectProtocol {
    func isEqual(_ object: Any?) -> Bool {
        object as? UserNotificationManager === self
    }
    
    var hash: Int {
        return -1
    }
    
    var superclass: AnyClass? {
        return nil
    }
    
    func `self`() -> Self {
        return self
    }
    
    func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
        return nil
    }
    
    func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
        return nil
    }
    
    func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
        return nil
    }
    
    func isProxy() -> Bool {
        return false
    }
    
    func isKind(of aClass: AnyClass) -> Bool {
        return false
    }
    
    func isMember(of aClass: AnyClass) -> Bool {
        return false
    }
    
    func conforms(to aProtocol: Protocol) -> Bool {
        return false
    }
    
    func responds(to aSelector: Selector!) -> Bool {
        return false
    }
    
    var description: String {
        return ""
    }
}

