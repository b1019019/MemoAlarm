//
//  MainAlarmViewModel.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/02/14.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol MainViewModelInputs: AnyObject {
    var tappedSwitchInAlarmTableViewCell: PublishRelay<(Bool,Int)> { get }
    var tappedButtonMakeNewAlarm: PublishRelay<Void> { get }
    var tappedAlarmTableViewCell: PublishRelay<IndexPath> { get }
    var ready: PublishRelay<Void> { get }
 }

protocol MainViewModelOutputs: AnyObject {
    var alarms: Driver<[Alarm]> { get }
}

protocol MainViewModelType: AnyObject {
    var inputs: MainViewModelInputs { get }
    var outputs: MainViewModelOutputs { get }
}

final class MainViewModel: MainViewModelType, MainViewModelInputs, MainViewModelOutputs {
    var inputs: MainViewModelInputs { return self }
    var outputs: MainViewModelOutputs { return self }
    
    // MARK: - Input
    let tappedSwitchInAlarmTableViewCell = PublishRelay<(Bool, Int)>()
    let tappedButtonMakeNewAlarm = PublishRelay<Void>()
    let tappedAlarmTableViewCell = PublishRelay<IndexPath>()
    let ready = PublishRelay<Void>()
    
    // MARK: - OutPut
    var alarms: Driver<[Alarm]>
    
    private var database: DatabaseIO
    private var notificationManager: NotificationManager
    private var navigator: MainViewNavigatable
    private let disposeBag = DisposeBag()
    
    var addedAlarm: Alarm?
    var editedAlarmAndIndex: (Alarm,Int)?
    
    init(database: DatabaseIO, notificationManager: NotificationManager, navigator: MainViewNavigatable){
        self.database = database
        self.notificationManager = notificationManager
        self.navigator = navigator
        
        let behaviorAlarm = BehaviorRelay<[Alarm]>(value: [])
        alarms = behaviorAlarm.asDriver()
        
        let initialSet = PublishRelay<Void>()
        
        let alarmsInitialSet = initialSet.map { (_) -> [Alarm] in
            print("initialSet")
            //return behaviorAlarm.value
            return try database.fetchAlarms()
        }.share()
        
        let alarmsChangedRingable = tappedSwitchInAlarmTableViewCell
            .withLatestFrom(behaviorAlarm) { (pair,alarms) -> [Alarm] in//
                let newRingable = pair.0
                let index = pair.1
                alarms[index].isRingable = newRingable
                if newRingable {
                    notificationManager.setNotification(alarm: alarms[index])
                } else {
                    notificationManager.releaseNotification(alarm: alarms[index])
                }
                return alarms
            }.share().debug()
        
        let alarmsEdited = ready.withLatestFrom(behaviorAlarm) { [weak self] (_, alarms) -> [Alarm] in
            print("alarmEdited")
            if let alarmAndIndex = self!.editedAlarmAndIndex {
                var newAlarms = alarms
                let element = alarmAndIndex.0
                let index = alarmAndIndex.1
                if alarms[index].isRingable && !element.isRingable {
                    notificationManager.releaseNotification(alarm: alarms[index])
                } else if !alarms[index].isRingable && element.isRingable {
                    //alarmsに新しいAlarmを追加する、それはalarms[index]のIDが更新されることを意味する。alarms[index].idは古いIDで、更新されてしまうため、削除する際、参照できなくなってしまう。
                    notificationManager.setNotification(alarm: element)
                }
                newAlarms[index] = element
                self!.editedAlarmAndIndex = nil
                return newAlarms
            } else {
                return alarms
            }
        }.share().debug()
        
        let alarmsAdded = ready.withLatestFrom(behaviorAlarm) { [weak self] (_, alarms) -> [Alarm] in
            print("added!!")
            if let alarm = self!.addedAlarm {
                var newAlarms = alarms
                if alarm.isRingable {
                    notificationManager.setNotification(alarm: alarm)
                }
                newAlarms.append(alarm)
                self!.addedAlarm = nil
                return newAlarms
            } else {
                return alarms
            }
        }.share()
        
        //willPresentを受け取ったときに行う行動：アラーム通知削除、データベースのRingableをfalseに
        let alarmNotificationWillPresent = notificationManager.willPresent
            .withLatestFrom(alarms) { (id, alarms) -> [Alarm] in
                let newAlarms = alarms
                newAlarms.forEach { alarm in
                    if alarm.id == id {
                        notificationManager.releaseNotification(alarm: alarm)
                        alarm.isRingable = false
                    }
                }
                return newAlarms
            }.share()
        
        let notificationDidReceive = notificationManager.didReceive
            .withLatestFrom(alarms) { (id, alarms) -> [Alarm] in
                let newAlarms = alarms
                newAlarms.forEach { alarm in
                    if alarm.id == id {
                        notificationManager.releaseNotification(alarm: alarm)
                        alarm.isRingable = false
                    }
                }
                return newAlarms
            }.share()
        
        let didBecome = NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
            .withLatestFrom(alarms) { (_, alarms) -> [Alarm] in
                alarms.forEach { alarm in
                    print("didBecome")
                    if alarm.isRingable && !notificationManager.existNotification(alarm: alarm) {
                        alarm.isRingable = false
                    }
                }
                return alarms
            }.share()
        
        let alarms = Observable.merge(alarmsInitialSet, alarmsChangedRingable, alarmsEdited, alarmsAdded, alarmNotificationWillPresent, notificationDidReceive, didBecome)
        
        alarms.subscribe(onNext: {alarm in
            print("alarmsOnNext")
        })
        
        alarms.do(onNext: {alarm in 
            print("alarmsOnNextBindBehavior")
        }).bind(to: behaviorAlarm).disposed(by: disposeBag)
        
        tappedButtonMakeNewAlarm
            .subscribe(onNext: {
                navigator.navigateToMakeNewAlarmScreen()
            })
            .disposed(by: disposeBag)
                
        tappedAlarmTableViewCell.withLatestFrom(alarms) { index, alarms in
            return (alarms[index.row], index.row)
        }.asDriver(onErrorJustReturn: (Alarm(name: "", note: "", ringTime: DateComponents(), isRepeated: false, isRingable: false), -1))
            .drive(onNext: { alarm, index in
                navigator.navigateToEditAlarmScreen(alarm: alarm, index: index)
            })
            .disposed(by: disposeBag)
        
        //例外をどう処理するか
        NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
            .withLatestFrom(alarms)
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { alarms in
                try? database.storeAlarms(alarms: alarms)
            })
            .disposed(by: disposeBag)
        
        
        initialSet.accept(())
    }
}
