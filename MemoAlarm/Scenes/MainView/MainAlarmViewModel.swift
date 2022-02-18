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
    
    init(database: DatabaseIO, notificationManager: NotificationManager, navigator: MainViewNavigatable){
        self.database = database
        self.notificationManager = notificationManager
        self.navigator = navigator
        
        alarms = PublishRelay<[Alarm]>().asDriver(onErrorJustReturn: [])
        
        let alarmsInitialSet = ready.map {
            return try database.fetchAlarms()
        }.asDriver(onErrorJustReturn: [])
        
        let alarmsChangedRingable = tappedSwitchInAlarmTableViewCell
            .withLatestFrom(alarms) { (pair,alarms) -> [Alarm] in
                let newRingable = pair.0
                let index = pair.1
                alarms[index].isRingable = newRingable
                return alarms
            }.asDriver(onErrorJustReturn: [])
        
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
            }.asDriver(onErrorJustReturn: [])
        
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
            }.asDriver(onErrorJustReturn: [])
        
        alarms = Driver.merge(alarmsInitialSet, alarmsChangedRingable, alarmNotificationWillPresent, notificationDidReceive)
        
        tappedButtonMakeNewAlarm
            .subscribe(onNext: {
                navigator.navigateToMakeNewAlarmScreen()
            })
            .disposed(by: disposeBag)
                
        tappedAlarmTableViewCell.withLatestFrom(alarms) { index, alarms in
            return alarms[index.row]
        }.asDriver(onErrorJustReturn: Alarm(name: "", note: "", ringTime: DateComponents(), isRepeated: false, isRingable: false))
            .drive(onNext: { alarm in navigator.navigateToEditAlarmScreen(alarm: alarm) })
            .disposed(by: disposeBag)
        
    }
}
