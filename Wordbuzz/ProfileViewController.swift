//
//  ProfileViewController.swift
//  Wordbuzz
//
//  Created by Chizaram Chibueze on 5/14/21.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var highscoreLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = PFUser.current()!
        
        if let name = user["fullName"] as? String {
            nameLabel.text = name
        } else {
            nameLabel.text = user.username
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
