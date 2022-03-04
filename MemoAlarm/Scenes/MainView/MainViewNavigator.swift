//
//  MainViewNavigator.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/02/14.
//

import Foundation
import UIKit
import RxRelay

protocol MainViewNavigatable {
    func navigateToEditAlarmScreen(alarm: Alarm, index: Int)
    func navigateToMakeNewAlarmScreen()
}

final class MainViewNavigator: MainViewNavigatable {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToEditAlarmScreen(alarm: Alarm, index: Int) {
        //EditNavigator,ViewModel,ViewControllerを生成
        let editViewNavigator = EditViewNavigator(navigationController: navigationController)
        let editViewModel = EditAlarmViewModel(alarm: alarm, index: index, navigator: editViewNavigator)
        let editViewController = EditAlarmViewController(viewModel: editViewModel)
        //navigationcontroller.showでViewControllerを指定して遷移
        navigationController.pushViewController(editViewController, animated: true)
    }
    
    func navigateToMakeNewAlarmScreen() {
        //EditNavigator,ViewModel,ViewControllerを生成
        let editViewNavigator = EditViewNavigator(navigationController: navigationController)
        let editViewModel = EditAlarmViewModel(navigator: editViewNavigator)
        let editViewController = EditAlarmViewController(viewModel: editViewModel)
        //navigationcontroller.showでViewControllerを指定して遷移
        navigationController.pushViewController(editViewController, animated: true)
    }
}
