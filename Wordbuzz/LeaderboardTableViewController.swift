//
//  LeaderboardTableViewController.swift
//  Wordbuzz
//
//  Created by Ahmed Abdalla on 6/7/21.
//

import UIKit
import Parse

class LeaderboardTableViewController: UITableViewController {

    var rankedUsers = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUsers()
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankedUsers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath) as! LeaderboardTableViewCell
        
        //set fonts
        let customYellowColor = UIColor(red:255/255, green:209/255, blue:45/255, alpha: 1)
        cell.rankLabel.font = UIFont(name: "Poppins-Black", size: 27)
        cell.rankLabel.textColor = customYellowColor
        cell.nameLabel.font = UIFont(name: "Poppins-SemiBold", size: 21)
        cell.highscoreLabel.font = UIFont(name: "Poppins-SemiBold", size: 21)
        
        //set cards
        let customPurpleColor = UIColor(red:146/255, green:45/255, blue:254/255, alpha: 1)
        cell.cardView.layer.cornerRadius = 12
        cell.cardView.layer.backgroundColor = customPurpleColor.cgColor
        
        //show trophy image for highest scoring users
        cell.winnerLabel.isHidden = true //hide
        if (indexPath.row == 0) {
            cell.winnerLabel.text = String("🥇")
            cell.winnerLabel.isHidden = false //show
        } else if (indexPath.row == 1) {
            cell.winnerLabel.text = String("🥈")
            cell.winnerLabel.isHidden = false //show
        } else if (indexPath.row == 2) {
            cell.winnerLabel.text = String("🥉")
            cell.winnerLabel.isHidden = false //show
        }
        
        //populate labels
        cell.rankLabel.text = String(indexPath.row + 1)
        if rankedUsers.count >= 1 {
            let user = rankedUsers[indexPath.row]
            cell.nameLabel.text = user["username"] as? String
            if let score = user["highScore"] as? Int {
                cell.highscoreLabel.text = String(score)
                print(String(score))
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func getUsers() {
        
        let query = PFQuery(className: "_User")
        query.order(byDescending: "highScore")
        query.includeKeys(["username", "highScore"])
        query.limit = 10
        query.findObjectsInBackground{ (objects: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let objects = objects {
                print("Successfully retrieved \(objects.count) objects")
                self.rankedUsers = objects
                self.tableView.reloadData()
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
