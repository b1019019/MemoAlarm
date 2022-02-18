//
//  Router.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/01/09.
//

/*
import Foundation
import UIKit

class Router {
    static func showRoot(window: UIWindow?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationVC = storyboard.instantiateInitialViewController() as! UINavigationController
        let viewController = navigationVC.viewControllers[0] as! ViewController
        
        let alarmModel = AlarmModel()
        let presenter = MainPresenter(alarmModel: alarmModel, presenterOutput: viewController)
        viewController.inject(presenter: presenter)
        
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()
    }
    
    static func pushToNewEditAlarmVC(fromVC: ViewController, alarm: Alarm) {
        let editAlarmViewController = EditAlarmViewController(nibName: "EditAlarmViewController", bundle: nil)
        let presenter = EditAlarmPresenter(editAlarmPresenterOutput: editAlarmViewController, alarm: alarm)
        editAlarmViewController.inject(presenter: presenter)
        fromVC.navigationController?.pushViewController(editAlarmViewController, animated: true)

    }
    
    static func pushToEditAlarmVC(fromVC: ViewController, alarm: Alarm) {
        
        let editAlarmViewController = EditAlarmViewController(nibName: "EditAlarmViewController", bundle: nil)
        let presenter = EditAlarmPresenter(editAlarmPresenterOutput: editAlarmViewController, alarm: alarm)
        editAlarmViewController.setup(alarm: alarm)
        editAlarmViewController.inject(presenter: presenter)
        fromVC.navigationController?.pushViewController(editAlarmViewController, animated: true)
    }
}
*/
