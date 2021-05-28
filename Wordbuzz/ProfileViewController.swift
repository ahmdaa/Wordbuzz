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
        
        // get high score
        if let highScore = user["highScore"] as? Int{
            highscoreLabel.text = String(highScore)
        }
        
        // get last score
        if let highScore = user["highScore"] as? Int{
            //lastscorelabel.text = String(highScore)
        }
        
        // get times played
        if let gamesCount = user["gamesCount"] as? Int{
            //gamescountLabel.text = String(gamesCount)
        }
        
        // get longest streak
        if let streakCount = user["streakCount"] as? Int{
            //streakcountLabel.text = String(streakCount)
        }
        
        // get favorited words
        if let favoritedWords = user["favoritedWords"] as? Int{
            //favoritedwordsLabel.text = String(favoritedWords)
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
