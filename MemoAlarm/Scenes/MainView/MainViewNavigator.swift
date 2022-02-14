//
//  MainViewNavigator.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/02/14.
//

import Foundation

protocol MainViewNavigatable {
    func navigateToEditAlarmScreen(alarm: Alarm)
    func navigateToMakeNewAlarmScreen()
}
