//
//  EditAlarmViewNavigator.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/02/14.
//

import Foundation
import UIKit

protocol EditViewNavigatable {
    func navigateToEditScreen()
}

final class EditVIewNavigator: EditViewNavigatable {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateToEditScreen() {
        navigationController.popViewController(animated: true)
    }
}
