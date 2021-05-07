//
//  WordDefinitionViewController.swift
//  Wordbuzz
//
//  Created by Joey Steigelman on 4/28/21.
//  Modified by Ahmed Abdalla
//

import UIKit
import Foundation
import Parse

class WordDefinitionViewController: UIViewController {
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var listenButton: UIButton!
    @IBOutlet weak var nextWordButton: UIButton!
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var examplesLabel: UILabel!
    
    var randomWord = [String: Any]()
    var wordSet = ["study", "fun", "happy", "construction"]
    var wordIndex = 0
    var favorited = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextWordButton.clipsToBounds = true
        nextWordButton.layer.cornerRadius = 14

        getRandomWord(index: wordIndex)
    }
    
    // MARK:- Network Requests
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        
        delegate.window?.rootViewController = loginViewController
    }
    
    // MARK:- API
    func getRandomWord(index: Int) {
        print("Making a request..")
        let headers = [
            "x-rapidapi-key": "a10993a051msh078390884b6556fp17dfdfjsn6ef5bb0fb17f",
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com"
        ]

        let urlString = String(format: "https://wordsapiv1.p.rapidapi.com/words/%@", wordSet[wordIndex])
        let url = URL(string: urlString)!
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
               print(error.localizedDescription)
            } else if let data = data {
               let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // print(dataDictionary)
                
                DispatchQueue.main.async {
                    self.randomWord = dataDictionary // Store random word
                    self.wordLabel.text = dataDictionary["word"] as? String
                    //print(dataDictionary["results"][0] ?? "")
                    //print(dataDictionary["syllables"] ?? "")
                    if let definitions = dataDictionary["results"] as? [[String: Any]] {
                        let definition = definitions[0] // Get the first definition
                        /* var definitionList = ""
                        
                        for definition in definitions {
                            definitionList += definition["definition"] as? String ?? ""
                        }
                        
                        print(definitionList) */
                        
                        // Set the word's definition
                        if let definitionText = definition["definition"] as? String {
                            self.definitionLabel.text = definitionText
                        }
                        
                        // Set the word's examples
                        if let examples = definition["examples"] as? [String] {
                            var examplesText = ""
                            for example in examples {
                                examplesText += "\"" + example + "\"\n"
                            }

                            self.examplesLabel.text = examplesText
                        }
                    } else {
                        self.definitionLabel.text = "No definition found"
                        self.examplesLabel.text = "No examples found"
                    }
                }
                
                
            }
        }
        dataTask.resume()
    }
    
    // MARK:- Button Actions
    @IBAction func onNext(_ sender: Any) {
        wordIndex += 1
        getRandomWord(index: wordIndex)
    }
    
    @IBAction func onFavorite(_ sender: Any) {
        if(!favorited) {
            setFavorite(true)
        } else {
            setFavorite(false)
        }
    }
    
    func setFavorite(_ isFavorited: Bool){
        favorited = isFavorited
        if (favorited) {
            favoriteButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: UIControl.State.normal)
        } else {
            favoriteButton.setBackgroundImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
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
