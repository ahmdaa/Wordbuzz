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
    
    var wordList = [String]()
    var wordData = [String: Any]()
    var favorited = false

    override func viewDidAppear(_ animated: Bool) {
        nextWordButton.clipsToBounds = true
        nextWordButton.layer.cornerRadius = 14
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Vocabulary is going to be at the beginner level by default
        // Read words from vocab-beginner.txt and populate wordList
        if let filepath = Bundle.main.path(forResource: "vocab-beginner", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                wordList = contents.components(separatedBy: "\n")
                // print(wordList[0])
            } catch {
                print("Could not load content")
            }
        } else {
            print("File not found")
        }
        
        getRandomWord()
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
    func getRandomWord() {
        print("Making request..")
        let headers = [
            "x-rapidapi-key": "a10993a051msh078390884b6556fp17dfdfjsn6ef5bb0fb17f",
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com"
        ]

        var word = wordList.randomElement()! // Get a random word from the list
        word = String(word.dropLast()) // Remove trailing carriage return (\r)
        let urlString = String(format: "https://wordsapiv1.p.rapidapi.com/words/%@", word)
        
        if let url = URL(string: urlString) {
            
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
                    
                    print(dataDictionary)
                    
                    DispatchQueue.main.async {
                        self.wordData = dataDictionary // Store word data
                        
                        self.wordLabel.text = dataDictionary["word"] as? String
                        //print(dataDictionary["results"][0] ?? "")
                        //print(dataDictionary["syllables"] ?? "")
                        
                        // Get all definitions if any are available
                        if let definitions = dataDictionary["results"] as? [[String: Any]] {
                            
                            // Store the first definition in a variable
                            let definition = definitions[0]
                            
                            /* var definitionList = ""
                            
                            for definition in definitions {
                                definitionList += definition["definition"] as? String ?? ""
                            }
                            
                            print(definitionList) */
                            
                            // Set the word's definition label text
                            if let definitionText = definition["definition"] as? String {
                                self.definitionLabel.text = definitionText
                            } else {
                                self.definitionLabel.text = "No definition found"
                            }
                            
                            // Set the word's examples label text
                            if let examples = definition["examples"] as? [String] {
                                var examplesText = ""
                                for example in examples {
                                    examplesText += "\"" + example + "\"\n"
                                }

                                self.examplesLabel.text = examplesText
                            } else {
                                self.examplesLabel.text = "No examples found"
                            }
                        } else {
                            self.definitionLabel.text = "No definition found"
                            self.examplesLabel.text = "No examples found"
                        }
                    }
                    
                    
                }
            }
            dataTask.resume()
        } else {
            print("Invalid URL")
        }
        
    }
    
    // MARK:- Button Actions
    @IBAction func onNext(_ sender: Any) {
        getRandomWord()
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
