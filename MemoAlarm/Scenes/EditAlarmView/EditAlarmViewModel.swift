//
//  EditAlarmViewModel.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/02/14.
//

import Foundation
import RxSwift
import RxCocoa

protocol EditAlarmViewModelInputs: AnyObject {
    var isPauseTimer: PublishRelay<Bool> { get }
    var isResetButtonTaped: PublishRelay<Void> { get }
 }

protocol EditAlarmViewModelOutputs: AnyObject {
    var isTimerWorked: Driver<Bool> { get }
    var timerText: Driver<String> { get }
    var isResetButtonHidden: Driver<Bool> { get }
}

protocol EditAlarmViewModelType: AnyObject {
    var inputs: EditAlarmViewModelInputs { get }
    var outputs: EditAlarmViewModelOutputs { get }
}

final class StopWatchViewModel: EditAlarmViewModelType, EditAlarmViewModelInputs, EditAlarmViewModelOutputs {
    var inputs: EditAlarmViewModelInputs { return self }
    var outputs: EditAlarmViewModelOutputs { return self }
