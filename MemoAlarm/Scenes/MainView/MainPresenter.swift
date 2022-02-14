//
//  MainPresenter.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/01/08.
//

import Foundation
import UIKit

protocol PresenterInput {
    var numberOfAlarms: Int { get }
    func tappedSwitchInAlarmTableViewCell(isOn: Bool, index: Int)
    func tappedButtonMakeNewAlarm()
    func didSelectAlarmTableViewCell(indexPath: IndexPath)
    func alarmTableViewCellForRowAt(indexPath: IndexPath) -> UITableViewCell
}

protocol PresenterOutput {
    func createAlarmTableViewCell(indexPath: IndexPath, name: String, ringTiming: DateComponents, isRepeated: Bool, isRingable: Bool) -> AlarmTableViewCell
    func transitionEditAlarmView(name: String, note: String, ringTiming: DateComponents, isRepeated: Bool)
    func transitionNewEditAlarmView()
}

class MainPresenter: PresenterInput {
    var alarms: [Alarm]
    let alarmModel: DatabaseIO & UserNotificationSetter
    let presenterOutput: PresenterOutput
    var numberOfAlarms: Int { return alarms.count }
    
    init(alarmModel: DatabaseIO & UserNotificationSetter, presenterOutput: PresenterOutput) {
        self.alarmModel = alarmModel
        self.presenterOutput = presenterOutput
        alarms = try! alarmModel.fetchAlarms()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(willTerminate(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc func willTerminate(_ notification: Notification) {
        print("BackGround!!")
        try! alarmModel.storeAlarms(alarms: alarms)
    }
    
    func tappedSwitchInAlarmTableViewCell(isOn: Bool, index: Int) {
        if isOn {
            alarms[index].isRingable = true
            alarmModel.setNotification(alarm: alarms[index])
        } else {
            alarms[index].isRingable = false
            alarmModel.setNotification(alarm: alarms[index])
        }
    }
    
    func tappedButtonMakeNewAlarm() {
        let alarm = Alarm(name: "", note: "", ringTime: DateComponents(), isRepeated: false, isRingable: false)
        alarms.append(alarm)
        Router.pushToNewEditAlarmVC(fromVC: presenterOutput as! ViewController, alarm: alarm)
    }
    
    func didSelectAlarmTableViewCell(indexPath: IndexPath) {
        let alarm = alarms[indexPath.row]
        Router.pushToEditAlarmVC(fromVC: presenterOutput as! ViewController, alarm: alarm)
    }
    
    func alarmTableViewCellForRowAt(indexPath: IndexPath) -> UITableViewCell {
        let alarm = alarms[indexPath.row]
        return presenterOutput.createAlarmTableViewCell(indexPath: indexPath, name: alarm.name, ringTiming: alarm.ringTiming, isRepeated: alarm.isRepeated, isRingable: alarm.isRingable)
    }
    
    
}
