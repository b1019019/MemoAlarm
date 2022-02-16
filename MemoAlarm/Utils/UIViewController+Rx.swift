//
//  UIViewController+Rx.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2022/02/14.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillDisappear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
}
