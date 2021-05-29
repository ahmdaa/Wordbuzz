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
    @IBOutlet weak var timesPlayedLabel: UILabel!
    @IBOutlet weak var longestStreakLabel: UILabel!
    @IBOutlet var cardsCollection: [UIView]!
    @IBOutlet weak var lastScoreLabel: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        configureCards()
        
        let user = PFUser.current()!
        
        //update highScore label
        if let highScore = user["highScore"] as? Int {
            highscoreLabel.text = String(highScore)
        } else {
            highscoreLabel.text = "0"
        }
        
        //update lastScore label
        if let lastScore = user["lastScore"] as? Int {
            lastScoreLabel.text = String(lastScore)
        } else {
            lastScoreLabel.text = "0"
        }
                
        //update timesPlayed label
        //saved in Parse as "gamesCount"
        if let timesPlayed = user["gamesCount"] as? Int {
            timesPlayedLabel.text = String(timesPlayed)
        } else {
            timesPlayedLabel.text = "0"
        }
        
        //update streakCount label
        if let streakCount = user["streakCount"] as? Int {
            longestStreakLabel.text = String(streakCount)
        } else {
            longestStreakLabel.text = "0"
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = PFUser.current()!
        
        //update name label
        if let name = user["fullName"] as? String {
            nameLabel.text = name
        } else {
            nameLabel.text = user.username
        }
    }
    
    func configureCards() {
        for card in cardsCollection {
            card.layer.cornerRadius = 12
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
