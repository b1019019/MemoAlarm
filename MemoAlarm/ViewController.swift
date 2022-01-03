//
//  ViewController.swift
//  MemoAlarm
//
//  Created by 山田純平 on 2021/11/25.
//

import UIKit

class ViewController: UIViewController {
    
    private struct Const {
        static let alarmTableViewCellNibName = "AlarmTableViewCell"
        static let alarmTableViewCellReuseIdentifier = "AlarmTableViewCell"
        static let numberOfRowsInSection = 20
    }
    
    private var alarms = [Alarm]()
    
    private let mock = Alarm(name: "アラームの名前", note: "メモ", ringTime: DateComponents(calendar: GlobalConst.calendar, hour: 7, minute: 23), isRepeated: true, isRingable: false)

    @IBOutlet weak var alarmTableView: UITableView! {
        didSet {
            alarmTableView.delegate = self
            alarmTableView.dataSource = self
            let nib = UINib(nibName: Const.alarmTableViewCellNibName, bundle: nil)
            alarmTableView.register(nib, forCellReuseIdentifier: Const.alarmTableViewCellReuseIdentifier)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 読み込み
        /*
        if let savedValue = UserDefaults.standard.data(forKey: "alarms") {
            let decoder = JSONDecoder()
            if let value = try? decoder.decode([Alarm].self, from: savedValue) {
                print("userDefaultの値",value)
                for v in value {
                    print(v.name)
                }
                alarms = value
            }
            
        } else {
            /// 値がない場合の処理
            print("値なし")
        }
         */
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(ViewController.storeAlarm(_:)), name: UIApplication.willTerminateNotification, object: nil)
        
        if let storedData = UserDefaults.standard.object(forKey: "alarms") as? Data {
            if let unarchivedObject = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedData) as? [Alarm] {
                alarms = unarchivedObject
                alarms.forEach { print("name",$0.name) }
            } else {
                print("else")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func storeAlarm(_ notification: Notification) {
        alarms.forEach { print("storedData",$0.name) }
        let archivedData = try! NSKeyedArchiver.archivedData(withRootObject: alarms, requiringSecureCoding: false)
        UserDefaults.standard.set(archivedData, forKey: "alarms")
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        print("disapper")
    }

    @IBAction func tappedAddCellButton(_ sender: UIBarButtonItem) {
        
        let newAlarm = Alarm(name: "", note: "", ringTime: DateComponents(), isRepeated: false, isRingable: false)
        alarms.append(newAlarm)
        let editAlarmViewController = EditAlarmViewController(nibName: "EditAlarmViewController", bundle: nil, alarm: newAlarm)
        self.navigationController?.pushViewController(editAlarmViewController, animated: true)
    }
    
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let semaphore = DispatchSemaphore(value: 0)
        UNUserNotificationCenter.current().getPendingNotificationRequests() {
            if $0.map({ $0.identifier }).contains(self.alarms[indexPath.row].id) {
                self.alarms[indexPath.row].isRingable = true
            } else {
                self.alarms[indexPath.row].isRingable = false
            }
            semaphore.signal()
        }
        semaphore.wait()
        alarms.forEach { print($0.name) }
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.alarmTableViewCellNibName, for: indexPath) as! AlarmTableViewCell
        cell.setup(alarm: alarms[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editAlarmViewController = EditAlarmViewController(nibName: "EditAlarmViewController", bundle: nil, alarm: alarms[indexPath.row])
        self.navigationController?.pushViewController(editAlarmViewController, animated: true)
        //self.present(editAlarmViewController, animated: true)
    }
}
