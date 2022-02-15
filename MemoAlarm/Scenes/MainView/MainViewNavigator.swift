//
//  MainViewNavigator.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/02/14.
//

import Foundation
import UIKit

protocol MainViewNavigatable {
    func navigateToEditAlarmScreen(alarm: Alarm)
    func navigateToMakeNewAlarmScreen()
}

final class MainVIewNavigator: MainViewNavigatable {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToEditAlarmScreen(alarm: Alarm) {
        //EditNavigator,ViewModel,ViewControllerを生成
        //navigationcontroller.showでViewControllerを指定して遷移
    }
    
    func navigateToMakeNewAlarmScreen() {
        //EditNavigator,ViewModel,ViewControllerを生成
        //navigationcontroller.showでViewControllerを指定して遷移
    }
}
