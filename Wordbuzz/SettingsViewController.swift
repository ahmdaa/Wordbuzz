//
//  SettingsViewController.swift
//  Wordbuzz
//
//  Created by Chizaram Chibueze on 5/21/21.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {

    @IBAction func notiswitch(_ sender: Any) {
        print ("Hi!")
        // Write code here for turning on and off the notification switch and add another outlet for switchoff
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Asking for permission
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Code later to let user know that if they deny notification that they can grant it later by going to settings
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
