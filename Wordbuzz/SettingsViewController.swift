//
//  SettingsViewController.swift
//  Wordbuzz
//
//  Created by Chizaram Chibueze on 5/21/21.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {

    @IBOutlet weak var switchout: UISwitch!
    @IBAction func notiswitch(_ sender: Any) {
        print ("Hi!")
        // Turning notification switch on and off
//        if switchout.isOn
//        {
//            if #available(iOS 10.0, *), list.isEmpty == false { //Fix error later
//
//                let content = UNMutableNotificationContent()
//                content.title = "You have to keep up with your streak!"
//                content.subtitle = ""
//                content.body = "Launch app to keep up with learning"
//                let alarmTime = Date().addingTimeInterval(60)
//                let components = Calendar.current.dateComponents([.weekday, .hour, .minute], from: alarmTime)
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
//                let request = UNNotificationRequest(identifier: "taskreminder", content: content, trigger: trigger)
//                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
//            } else {
//                print("hello")
//            }
//        } else {
//            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        }
//        self.saveSwitchesStates() //Fix error later
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Asking for permission
        let center = UNUserNotificationCenter.current()
        
        // Letting user know that if they deny notification that they can grant it later by going to settings
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Notifications permission granted")
            } else {
                print("Notification permission denied because: \(error?.localizedDescription ?? "")")
            }
        }
        
        // Creating notification content
        let content = UNMutableNotificationContent()
        content.title = "I am a notification!"
        content.body = "Check me out!"
        
        // Creating the notification trigger
        let date = Date().addingTimeInterval(5)
        
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        
        // Creating the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        // Registering the request with notification center
        center.add(request) {(error) in
            // check the error parameter and handle any errors
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
