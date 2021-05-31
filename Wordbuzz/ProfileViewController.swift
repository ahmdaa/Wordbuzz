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
    @IBOutlet weak var favoritedWordsLabel: UILabel!
    @IBOutlet var cardsCollection: [UIView]!
    @IBOutlet weak var lastScoreLabel: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        let user = PFUser.current()!
        
        //update highScore label
        if let highScore = user["highScore"] as? Int {
            highscoreLabel.text = String(highScore)
        }
                
        //update favoritedWordsLabel
        if let favoritedWords = user["favoriteWords"] as? [String] {
            favoritedWordsLabel.text = String(favoritedWords.count)
        }
        
        //update timesPlayed label
        //saved in Parse as "gamesCount"
        if let timesPlayed = user["gamesCount"] as? Int {
            timesPlayedLabel.text = String(timesPlayed)
        }
        
        //update streakCount label
        if let streakCount = user["streakCount"] as? Int {
            longestStreakLabel.text = String(streakCount)
        }
        
        //update lastScore label
        if let lastScore = user["lastScore"] as? Int {
            lastScoreLabel.text = String(lastScore)
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
        
        //update highScore label
        if let highScore = user["highScore"] as? Int {
            highscoreLabel.text = String(highScore)
        }
                
        //update favoritedWordsLabel
        if let favoritedWords = user["favoriteWords"] as? [String] {
            favoritedWordsLabel.text = String(favoritedWords.count)
        }
        
        //update timesPlayed label
        //saved in Parse as "gamesCount"
        if let timesPlayed = user["gamesCount"] as? Int {
            timesPlayedLabel.text = String(timesPlayed)
        }
        
        //update streakCount label
        if let streakCount = user["streakCount"] as? Int {
            longestStreakLabel.text = String(streakCount)
        }
        
        //update lastScore label
        if let lastScore = user["lastScore"] as? Int {
            lastScoreLabel.text = String(lastScore)
        }

    
        configureCards()
    }
    
    func configureCards() {
        
        //set custom purple color
        let customPurpleColor = UIColor(red:146/255, green:45/255, blue:254/255, alpha: 1)
        
        for card in cardsCollection {
            card.layer.cornerRadius = 12
            
            //set shadow
            card.layer.shadowOpacity = 1.0 // opacity, 100%
            card.layer.shadowColor = customPurpleColor.cgColor
            card.layer.shadowRadius = 0 // no blur
            card.layer.shadowOffset = CGSize(width: 0, height: 8) // Spread x, y
            card.layer.masksToBounds = false
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
