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
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
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
        if let gamesCount = user["gamesCount"] as? [String] {
            timesPlayedLabel.text = String(gamesCount.count)
        }
        
        //update streakCount label
        if let streakCount = user["streakCount"] as? [String] {
            longestStreakLabel.text = String(streakCount.count)
        }
        
        //update lastScore label
//        if let lastScore = user["lastScore"] as? Int {
//            lastScoreLabel.text = String(lastScore)
//        }

    
        configureCards()
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
