//
//  EditAlarmViewNavigator.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/02/14.
//

import Foundation
import UIKit

protocol EditViewNavigatable {
    func navigateToMainScreen(addedAlarm: Alarm)
    func navigateToMainScreen(editedAlarm: Alarm, index: Int)
}

final class EditViewNavigator: EditViewNavigatable {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToMainScreen(addedAlarm: Alarm) {
        guard let mainViewController = navigationController.viewControllers[0] as? ViewController else { return }
        mainViewController.addAlarm(alarm: addedAlarm)
        navigationController.popViewController(animated: true)
    }
    
    func navigateToMainScreen(editedAlarm: Alarm, index: Int) {
        guard let mainViewController = navigationController.viewControllers[0] as? ViewController else { return }
        mainViewController.editAlarm(alarm: editedAlarm, index: index)
        navigationController.popViewController(animated: true)
    }
}
