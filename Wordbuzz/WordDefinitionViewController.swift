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
    @IBOutlet weak var nextWordButton: UIButton!
    
    @IBOutlet weak var syllablesLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var definitionLabel: UILabel!
    @IBOutlet weak var examplesLabel: UILabel!
    @IBOutlet weak var frequencyWordLabel: UILabel!
    
    var wordList = [String]()
    var wordData = [String: Any]()
    var favorited = false

    override func viewDidAppear(_ animated: Bool) {
        nextWordButton.clipsToBounds = true
        nextWordButton.layer.cornerRadius = 12
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set fonts
        wordLabel.font = UIFont(name: "Poppins-Bold", size: 32)
        syllablesLabel.font = UIFont(name: "Poppins-Medium", size: 20)
        frequencyLabel.font = UIFont(name: "Poppins-Medium", size: 20)
        frequencyWordLabel.font = UIFont(name: "Poppins-Medium", size: 20)

        
        // Vocabulary is going to be at the beginner level by default
        // Read words from vocab-beginner.txt and populate wordList
        if let filepath = Bundle.main.path(forResource: "vocab-advanced", ofType: "txt") {
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
        // saveSeenWord(seen: "apple")
        // resetSeenWords()
    }
    
    // MARK:- Network Requests
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(identifier: "LoginViewController")
        
        let delegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        
        delegate.window?.rootViewController = loginViewController
    }
    
    func saveSeenWord(seen: String) {
        let user = PFUser.current()!
        
        if var seenWords = user["seenWords"] as? [String] {
            if( !seenWords.contains(seen) ) {
                seenWords.append(seen)
                user["seenWords"] = seenWords
            }
        } else {
            let seenWords = [String]()
            user["seenWords"] = seenWords
        }
        
        user.saveInBackground { (success, error) in
            if success {
                print("User updated")
            } else {
                print("Error saving user")
            }
        }
    }
    
    func resetSeenWords() {
        let user = PFUser.current()!
        
        let seenWords = [String]()
        user["seenWords"] = seenWords
        
        user.saveInBackground { (success, error) in
            if success {
                print("User updated")
            } else {
                print("Error saving user")
            }
        }
    }
    
    // Add a word to user's favorite words
    func favoriteWord(word: String) {
        let user = PFUser.current()!
        
        if var favoriteWords = user["favoriteWords"] as? [String] {
            if( !favoriteWords.contains(word) ) {
                favoriteWords.append(word)
                user["favoriteWords"] = favoriteWords
            } else {
                print("Word already favorited")
            }
        } else {
            var favoriteWords = [String]()
            favoriteWords.append(word)
            user["favoriteWords"] = favoriteWords
        }
        
        user.saveInBackground { (success, error) in
            if success {
                print("User updated")
            } else {
                print("Error saving user")
            }
        }
    }
    
    // Remove a word from user's favorite words
    func unfavoriteWord(word: String) {
        let user = PFUser.current()!
        
        if var favoriteWords = user["favoriteWords"] as? [String] {
            if let index = favoriteWords.firstIndex(of: word) {
                favoriteWords.remove(at: index)
                user["favoriteWords"] = favoriteWords
            } else {
                print("Word isn't favorited")
            }
        } else {
            let favoriteWords = [String]()
            user["favoriteWords"] = favoriteWords
        }
        
        user.saveInBackground { (success, error) in
            if success {
                print("User updated")
            } else {
                print("Error saving user")
            }
        }
    }
    
    // Check if a word is favorited in user data
    func checkFavorite(word: String) -> Bool {
        let user = PFUser.current()!
        
        if let favoriteWords = user["favoriteWords"] as? [String] {
            if favoriteWords.firstIndex(of: word) != nil {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    // MARK:- API
    func getRandomWord() {
        print("Making request..")
        let headers = [
            "x-rapidapi-key": "a10993a051msh078390884b6556fp17dfdfjsn6ef5bb0fb17f",
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com"
        ]

        var randomWord = wordList.randomElement()! // Get a random word from the list
        randomWord = String(randomWord.dropLast()) // Remove trailing carriage return (\r)
        
        // Check if word is favorited or not and update favorite button accordingly
        setFavorite(checkFavorite(word: randomWord))
        
        let urlString = String(format: "https://wordsapiv1.p.rapidapi.com/words/%@", randomWord)
        
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
                    
                    // print(dataDictionary)
                    
                    DispatchQueue.main.async {
                        self.wordData = dataDictionary // Store word data
                        
                        if let word = dataDictionary["word"] as? String {
                            self.wordLabel.text = word
                            // self.saveSeenWord(seen: word)
                        }
                        
                        if let freq = dataDictionary["frequency"] as? Double {
                            self.frequencyLabel.text = String(freq)
                        }
                        
                        //print(dataDictionary["results"][0] ?? "")
                        
                        // Get list of word syllables
                        if let syllables = dataDictionary["syllables"] as? [String: Any] {
                            if let list = syllables["list"] as? [String] {
                                var syllableString = ""
                                for syllable in list {
                                    syllableString += syllable + "·"
                                }
                                self.syllablesLabel.text = syllableString
                            }
                        } else {
                            self.syllablesLabel.text = ""
                        }
                        
                        // Get all definitions if any are available
                        if let definitions = dataDictionary["results"] as? [[String: Any]] {
                            
                            var definitionList = "" // Multi-line string for definitions
                            var examplesList = "" // Multi-line string for examples
                            var definitionIndex = 1 // Index for each definition
                            var exampleIndex = 1 // Index for each example
                            
                            for definition in definitions {
                                if let definitionText = definition["definition"] as? String {
                                    definitionList += String(definitionIndex) + ". " + definitionText + "\n"
                                    definitionIndex += 1
                                }
                                
                                if let examples = definition["examples"] as? [String] {
                                    examplesList += String(exampleIndex) + ". "
                                    for example in examples {
                                        examplesList += "\"" + example + "\"\n"
                                    }
                                    exampleIndex += 1
                                } else {
                                    exampleIndex += 1
                                }
                                
                            }
                            
                            self.definitionLabel.text = definitionList
                            
                            if examplesList == "" {
                                self.examplesLabel.text = "No examples found"
                            } else {
                                self.examplesLabel.text = examplesList
                            }
                            
                            // print(definitionList)
                            
                            // Set the word's definition label text
                            /* if let definitionText = definition["definition"] as? String {
                                self.definitionLabel.text = definitionText
                            } else {
                                self.definitionLabel.text = "No definition found"
                            } */
                            
                            // Set the word's examples label text
                            /* if let examples = firstDefinition["examples"] as? [String] {
                                var examplesText = ""
                                for example in examples {
                                    examplesText += "\"" + example + "\"\n"
                                }

                                self.examplesLabel.text = examplesText
                            } else {
                                self.examplesLabel.text = "No examples found"
                            } */
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
            
            if let wordToFavorite = wordData["word"] as? String {
                favoriteWord(word: wordToFavorite)
            } else {
                print("No word available")
            }
        } else {
            setFavorite(false)
            
            if let wordToUnfavorite = wordData["word"] as? String {
                unfavoriteWord(word: wordToUnfavorite)
            } else {
                print("No word available")
            }
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
