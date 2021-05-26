//
//  GameViewController.swift
//  Wordbuzz
//
//  Created by Joey Steigelman on 5/17/21.
//
 
import UIKit
import Parse
 
class GameViewController: UIViewController {
 
    
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var wordExampleLabel: UILabel!
    @IBOutlet weak var wordChoiceOneButton: UIButton!
    @IBOutlet weak var wordChoiceTwoButton: UIButton!
    @IBOutlet weak var wordChoiceThreeButton: UIButton!
    @IBOutlet weak var wordChoiceFourButton: UIButton!
    @IBOutlet weak var answerMessageLabel: UILabel!
    @IBOutlet weak var answerMessageEmojiLabel: UILabel!
    @IBOutlet weak var spacerView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var wordChoiceButtons: [UIButton]!
    
    var wordList = [String]()
    var wordData = [String: Any]()
    var score = 0
    var streakCount = 0
    var gamesCount = 0
    var highScore = 0

    var answerA = false
    var answerB = false
    var answerC = false
    var answerD = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerMessageLabel.isHidden = true // hide
        answerMessageEmojiLabel.isHidden = true // hide
        spacerView.isHidden = true // hide

        configureButtons()
        getFourRandomWords()
        getWordList()
    }
    
    func getWordList() {
        if let filepath = Bundle.main.path(forResource: "vocab-beginner", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                wordList = contents.components(separatedBy: "\n")
            } catch {
                print("Could not load content")
            }
        } else {
            print("File not found")
        }
    }
    
    func configureButtons() {
        //set custom colors
        let whiteTextColor = UIColor(red:253/255, green:253/255, blue:253/255, alpha: 1)
        let darkButtonColor = UIColor(red:39/255, green:40/255, blue:52/255, alpha: 1)
        
        for wordButton in wordChoiceButtons {
            wordButton.backgroundColor = darkButtonColor
            wordButton.setTitleColor(whiteTextColor, for: .normal)
            wordButton.clipsToBounds = true
            wordButton.layer.cornerRadius = 12
        }
    }
    
    func getFourRandomWords() {
        let user = PFUser.current()!
        var gameWords = [String]()
        gameWords = user["seenWords"] as! [String]
        
        //ensure gameWords array has enough words
        while (gameWords.count < 10) {
            var randomWord = wordList.randomElement()! // Get a random word from the list
            randomWord = String(randomWord.dropLast()) // Remove trailing carriage return (\r)
            gameWords.append(randomWord)
        }
        
        //put words array in random order
        gameWords.shuffle()
        
        //get first four words from shuffled words array
        var word = gameWords[0]
        var word_incorrect_1 = gameWords[1]
        var word_incorrect_2 = gameWords[2]
        var word_incorrect_3 = gameWords[3]
        
        //randomly assign words to buttons
        let randomInt = Int.random(in: 0..<4)
        switch randomInt {
        case 0:
            self.wordChoiceOneButton.setTitle(word, for: .normal)
            self.wordChoiceTwoButton.setTitle(word_incorrect_1, for: .normal)
            self.wordChoiceThreeButton.setTitle(word_incorrect_2, for: .normal)
            self.wordChoiceFourButton.setTitle(word_incorrect_3, for: .normal)
            answerA = true
            answerB = false
            answerC = false
            answerD = false
        case 1:
            self.wordChoiceOneButton.setTitle(word_incorrect_1, for: .normal)
            self.wordChoiceTwoButton.setTitle(word, for: .normal)
            self.wordChoiceThreeButton.setTitle(word_incorrect_2, for: .normal)
            self.wordChoiceFourButton.setTitle(word_incorrect_3, for: .normal)
            answerA = false
            answerB = true
            answerC = false
            answerD = false
        case 2:
            self.wordChoiceOneButton.setTitle(word_incorrect_2, for: .normal)
            self.wordChoiceTwoButton.setTitle(word_incorrect_1, for: .normal)
            self.wordChoiceThreeButton.setTitle(word, for: .normal)
            self.wordChoiceFourButton.setTitle(word_incorrect_3, for: .normal)
            answerA = false
            answerB = false
            answerC = true
            answerD = false
            
        case 3:
            self.wordChoiceOneButton.setTitle(word_incorrect_3, for: .normal)
            self.wordChoiceTwoButton.setTitle(word_incorrect_1, for: .normal)
            self.wordChoiceThreeButton.setTitle(word_incorrect_2, for: .normal)
            self.wordChoiceFourButton.setTitle(word, for: .normal)
            answerA = false
            answerB = false
            answerC = false
            answerD = true
        default:
            self.wordChoiceOneButton.setTitle(word, for: .normal)
            self.wordChoiceTwoButton.setTitle(word_incorrect_1, for: .normal)
            self.wordChoiceThreeButton.setTitle(word_incorrect_2, for: .normal)
            self.wordChoiceFourButton.setTitle(word_incorrect_3, for: .normal)
            answerA = true
            answerB = false
            answerC = false
            answerD = false
        }
        
        print("Making request..")
        let headers = [
            "x-rapidapi-key": "a10993a051msh078390884b6556fp17dfdfjsn6ef5bb0fb17f",
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com"
        ]
        
        
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
                    
                    // print(dataDictionary)
                    
                    DispatchQueue.main.async {
                        self.wordData = dataDictionary // Store word data
                        
                        //update count of seenWords
//                        if let seenWords = user["seenWords"] as? Dictionary[String, Int] {
//                            seenWords[word] += 1
//                        }
                        
                        // Get all definitions if any are available
                        if let definitions = dataDictionary["results"] as? [[String: Any]] {
                            
                            // Store the first definition in a variable
                            var question = definitions[0]["definition"] as? String
                            self.wordExampleLabel.text = question

                            
                        } else {
                            self.wordExampleLabel.text = "No definition found"
                        }
                    }
                }
            }
            dataTask.resume()
        } else {
            print("Invalid URL")
        }
    }

    
    
    @IBAction func onChoiceAButton(_ sender: Any) {
        checkAnswer(chosenAnswer: answerA, button: wordChoiceOneButton)
    }
    
    @IBAction func onChoiceBButton(_ sender: Any) {
        checkAnswer(chosenAnswer: answerB, button: wordChoiceTwoButton)
    }
    
    @IBAction func onChoiceCButton(_ sender: Any) {
        checkAnswer(chosenAnswer: answerC, button: wordChoiceThreeButton)
    }
    
    @IBAction func onChoiceDButton(_ sender: Any) {
        checkAnswer(chosenAnswer: answerD, button: wordChoiceFourButton)
    }
    
    func checkAnswer(chosenAnswer: Bool, button: UIButton) {
        updateUserProgress(chosenAnswer: chosenAnswer)
        if(chosenAnswer) {
            guessIsCorrect(chosenAnswer: chosenAnswer, button: button)
        } else if !(chosenAnswer) {
            guessIsIncorrect(chosenAnswer: chosenAnswer, button: button)
        }
    }
    
    func updateUserProgress(chosenAnswer: Bool) {
        let user = PFUser.current()!
        
        //update streakCount
        if (chosenAnswer) {
            streakCount += 1
        } else if !(chosenAnswer) {
            streakCount = 0
        }
        user["streakCount"] = streakCount
        
        //update gamesCount
        gamesCount += 1
        user["gamesCount"] = gamesCount
        
        //update highScore
        if ((streakCount * 200) > highScore) {
            highScore = streakCount * 200
            user["highScore"] = highScore
        }
    }
    
    func guessIsCorrect(chosenAnswer: Bool, button: UIButton) {
        
        //change button background color
        button.setBackgroundImage(UIImage(named: "Gradient.png"), for: .normal)
 
        //display success message
        answerMessageLabel.text = String("Great job!")
        answerMessageLabel.isHidden = false // show
        
        answerMessageEmojiLabel.text = String("👏")
        answerMessageEmojiLabel.isHidden = false // show
        
        scoreLabel.text = String("+200")

        //update score
        score += 200
        currentScoreLabel.text = String(score)
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in

            //restore UI after a delay
            self.answerMessageLabel.isHidden = true // hide
            self.answerMessageEmojiLabel.isHidden = true // hide
            self.scoreLabel.text = String("Score")

            let darkButtonColor = UIColor(red:39/255, green:40/255, blue:52/255, alpha: 1)
            
            for wordButton in self.wordChoiceButtons {
                wordButton.backgroundColor = darkButtonColor
                wordButton.setBackgroundImage(nil, for: .normal)
            }

            self.wordExampleLabel.text = " "
            

            //Put the code to display the next question here
            //so it doesn't happen until after the delay
            self.getFourRandomWords() //Or whatever...
        }
    }
    
    
    func guessIsIncorrect(chosenAnswer: Bool, button: UIButton) {
        
        //change button color
        let redButtonColor = UIColor(red:254/255, green:45/255, blue:83/255, alpha: 1)
        button.backgroundColor = redButtonColor
        
        //display wrong answer message
        answerMessageLabel.isHidden = false // show
        answerMessageLabel.text = String("Try again!")
        answerMessageEmojiLabel.isHidden = false // show
        answerMessageEmojiLabel.text = String("👉")
        scoreLabel.text = String("-100")

        //update score
        score -= 100
        currentScoreLabel.text = String(score)

        //restore UI after a delay
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { (timer) in

            self.answerMessageLabel.isHidden = true // hide
            self.answerMessageEmojiLabel.isHidden = true // hide
            self.scoreLabel.text = String("Score")

            let darkButtonColor = UIColor(red:39/255, green:40/255, blue:52/255, alpha: 1)
            
            for wordButton in self.wordChoiceButtons {
                wordButton.backgroundColor = darkButtonColor
                wordButton.setBackgroundImage(nil, for: .normal)
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

