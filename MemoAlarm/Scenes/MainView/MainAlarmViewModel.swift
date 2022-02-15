//
//  MainAlarmViewModel.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/02/14.
//

import Foundation
import RxSwift
import RxCocoa

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
        
        let alarms = Driver.merge(alarmsInitialSet,alarmsChangedRingable)
        
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
