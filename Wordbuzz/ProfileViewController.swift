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
    @IBOutlet var buttonsCollection: [UIButton]!
    @IBOutlet weak var lastScoreLabel: UILabel!
    @IBOutlet weak var favoritedWordsLabel: UILabel!
    
    @IBOutlet weak var intermediateButton: UIButton!
    @IBOutlet weak var advancedButton: UIButton!
    @IBOutlet weak var expertButton: UIButton!
    
    @IBOutlet var spacerViewCollection: [UIView]!
    @IBOutlet var cardTitleCollection: [UILabel]!
    @IBOutlet var greetingCollection: [UILabel]!
    @IBOutlet var smallTextCollection: [UILabel]!
    
    
    
    var userLevel = "vocab-beginner"
    
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
        
        //update favoritedWords label
        if let favoritedWords = user["favoriteWords"] as? [String] {
            let favnumber = favoritedWords.count
            favoritedWordsLabel.text = String(favnumber)
        } else {
            favoritedWordsLabel.text = "0"
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
        
        //add fonts
        intermediateButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 17)
        advancedButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 17)
        expertButton.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 17)
        highscoreLabel.font = UIFont(name: "Poppins-Black", size: 54)
        nameLabel.font = UIFont(name: "Poppins-SemiBold", size: 27)
        for card in cardTitleCollection {
            card.font = UIFont(name: "Poppins-SemiBold", size: 24)
        }
        for greeting in greetingCollection {
            greeting.font = UIFont(name: "Poppins-SemiBold", size: 27)
        }
        for text in smallTextCollection {
            text.font = UIFont(name: "Poppins-SemiBold", size: 17)
        }

    }
    
    func configureCards() {
        
        //hide spacer views
        for spacer in spacerViewCollection {
            spacer.isHidden = true
        }
        
        //set custom colors
        let customPurpleColor = UIColor(red:146/255, green:45/255, blue:254/255, alpha: 1)
        let customGrayColor = UIColor(red:39/255, green:40/255, blue:52/255, alpha: 1)
        let customButtonGrayColor = UIColor(red:183/255, green:175/255, blue:191/255, alpha: 1)
        let customRedColor = UIColor(red:254/255, green:45/255, blue:83/255, alpha: 1)

        
        for card in cardsCollection {
            card.layer.cornerRadius = 12
            card.layer.backgroundColor = customGrayColor.cgColor

            
            //set shadow
            card.layer.shadowOpacity = 1.0 // opacity, 100%
            card.layer.shadowColor = customPurpleColor.cgColor
            card.layer.shadowRadius = 0 // no blur
            card.layer.shadowOffset = CGSize(width: 0, height: 8) // Spread x, y
            card.layer.masksToBounds = false
        }
        
        for button in buttonsCollection {
            button.layer.cornerRadius = 12
            button.layer.backgroundColor = customButtonGrayColor.cgColor

        
            //set shadow
            button.layer.shadowOpacity = 1.0 // opacity, 100%
            button.layer.shadowColor = customPurpleColor.cgColor
            button.layer.shadowRadius = 0 // no blur
            button.layer.shadowOffset = CGSize(width: 0, height: 8) // Spread x, y
            button.layer.masksToBounds = false
        }
        
        //get user level
        let user = PFUser.current()!
        if let vocabLevel = user["vocabLevel"] as? String {
            userLevel = vocabLevel
            print("User level is set to \(userLevel).")
            
            if vocabLevel == "vocab-beginner" {
                intermediateButton.layer.backgroundColor = customRedColor.cgColor
            } else if (vocabLevel == "vocab-advanced") {
                advancedButton.layer.backgroundColor = customRedColor.cgColor
            } else if (vocabLevel == "vocab-expert") {
                expertButton.layer.backgroundColor = customRedColor.cgColor
            }
        } else {
            userLevel = "vocab-beginner"
            intermediateButton.layer.backgroundColor = customRedColor.cgColor
            print("User level set to default value.")
        }

        
        
    }
    
    
    @IBAction func didPressIntermediateButton(_ sender: Any) {
        //set custom colors
        let customButtonGrayColor = UIColor(red:183/255, green:175/255, blue:191/255, alpha: 1)
        let customRedColor = UIColor(red:254/255, green:45/255, blue:83/255, alpha: 1)
        
        //change button colors
        intermediateButton.layer.backgroundColor = customRedColor.cgColor
        advancedButton.layer.backgroundColor = customButtonGrayColor.cgColor
        expertButton.layer.backgroundColor = customButtonGrayColor.cgColor
        
        //set user level
        let user = PFUser.current()!
        user["vocabLevel"] = "vocab-beginner"
        user.saveInBackground { (success, error) in
            if success {
                print("User level updated")
            } else {
                print("Error saving user level")
            }
        }

    }
    
    @IBAction func didPressAdvancedButton(_ sender: Any) {
        //set custom colors
        let customButtonGrayColor = UIColor(red:183/255, green:175/255, blue:191/255, alpha: 1)
        let customRedColor = UIColor(red:254/255, green:45/255, blue:83/255, alpha: 1)
        
        //change button colors
        intermediateButton.layer.backgroundColor = customButtonGrayColor.cgColor
        advancedButton.layer.backgroundColor = customRedColor.cgColor
        expertButton.layer.backgroundColor = customButtonGrayColor.cgColor
        
        //set user level
        let user = PFUser.current()!
        user["vocabLevel"] = "vocab-advanced"
        user.saveInBackground { (success, error) in
            if success {
                print("User level updated")
            } else {
                print("Error saving user level")
            }
        }
    }
    
    @IBAction func didPressExpertButton(_ sender: Any) {
        //set custom colors
        let customButtonGrayColor = UIColor(red:183/255, green:175/255, blue:191/255, alpha: 1)
        let customRedColor = UIColor(red:254/255, green:45/255, blue:83/255, alpha: 1)
        
        //change button colors
        intermediateButton.layer.backgroundColor = customButtonGrayColor.cgColor
        advancedButton.layer.backgroundColor = customButtonGrayColor.cgColor
        expertButton.layer.backgroundColor = customRedColor.cgColor
        
        //set user level
        let user = PFUser.current()!
        user["vocabLevel"] = "vocab-expert"
        user.saveInBackground { (success, error) in
            if success {
                print("User level updated")
            } else {
                print("Error saving user level")
            }
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
