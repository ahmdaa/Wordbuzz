# Wordbuzz

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
This app helps the user improve their vocabulary in an engaging manner by providing the user with random words and their details in addition to allowing the user to practice their knowledge of these words through word games and challenges.

### App Evaluation
- **Category:** Education / Productivity
- **Mobile:** This app would be developed for mobile because it's meant to be a daily use app that can be accessed on the go. It can work on a computer but it would have less accessibility and convenience.
- **Story:** Improves vocabulary through word learning, engaging exercises and lets the user track their progress and score.
- **Market:** Students and any user looking to learn or practice their English vocabulary and speech.
- **Habit:** This app will be used as often as the user wants but the app will provide a daily user challenge to encourage frequent use.
- **Scope:** The app will start with simple English vocabulary learning and exercises at a level of the user's choice but it can be expanded to include user voice recognition, more advanced games and activities or multiple languages!

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [X] User can sign up for a new account
- [X] User can log in to their account
- [x] User can access word definitions
- [x] User can access examples of correct word usage in a sentence
- [x] User can save and access their individual progress
- [x] User can access and change settings
- [X] User can test their knowledge by playing a word game/challenge

**Optional Nice-to-have Stories**

* [x] User can see multiple definitions and their examples
* [x] User can favorite a word and access a list of their favorite words
* User receives a daily word challenge
* User can choose a word difficulty level
* User can choose a word category
* User can specify a language
* User can play audio to hear the pronunciation of a word
* User can do speaking exercises and track speaking progress
* User can share a word outside the app to their social media

### 2. Screen Archetypes

* Login/register screen
* Profile screen
   * Displays user score in games/challenges and/or user overall rating
* Word definition screen
   * Displays word, word definition, example of word used in a sentence, and audio button to play the pronunciation of a word
* Word game screen
   * Presents a word game for the user to solve to test user knowledge
   * Each game solved correctly will increase the user score for that game
* Favorite words screen (Nice to Have)
   * Displays a list of user-specified favorite words
   * Tapping on a word in the favorite words list will present the word definition screen
* Settings screen
   * Allows user to change notification settings
   * Allows user to specify word difficulty level, word category and/or language

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Word definition screen
* Profile screen
* Word game screen

**Flow Navigation** (Screen to Screen)

* Log in/Register
* Word definition screen
   * Favorite words screen
* Word game screen
* Profile screen
   * Settings screen


## Video Walkthrough

Demo: https://drive.google.com/file/d/18STziV23M7f8jDYkiNIFYexsdw68cRQq/view?usp=sharing

Here's walkthroughs of implemented user stories:

<p float="left">
 <img src='https://i.imgur.com/DlMjFHL.gif' width=250 alt='Spring #1' />
 <img src='https://imgur.com/up2sUL1.gif' width=250 alt='Spring #2' />
 <img src='https://imgur.com/FpN1lio.gif' width=250 alt='Spring #3' />
 <img src='https://i.imgur.com/NyWD0Tq.gif' width=250 alt='Spring #4' />
 <img src='https://i.imgur.com/ViEjgPd.gif' width=250 alt='Spring #5' />
 <img src='https://i.imgur.com/tP1A8iI.gif' width=250 alt='Spring #6' />
</p>

## Wireframes


![Wireframe_Drawing](https://user-images.githubusercontent.com/65603938/115076248-95f8f480-9efc-11eb-9d0f-12083d599890.png)


### [BONUS] Digital Wireframes & Mockups
![digital-wireframes](https://user-images.githubusercontent.com/39933444/115073845-e35a6f00-9ec6-11eb-90a8-ec0be6383d2e.png)

## Schema 
### Models
#### Post

##### User
  | Property        | Type              | Description |
  | --------------- | ----------------- | ------------|
  | objectId        | String            | Unique id for the user (default field) |
  | username        | String            | Username set by user |
  | password        | String            | Password set by user |
  | image           | File              | Profile image that user uploads |
  | level           | String            | Level chosen by user that determines which words they are tested on |
  | gamesCount      | Number            | Number of games won and lost by user |
  | streakCount     | Number            | Number of consecutive games won by user  |
  | highScore       | Number            | Number of consecutive games won by user (multiplied by 100 points) |
  | favoritedWords  | Array of strings  | List of words favorited by user |
  | seenWords       | Dictionary        | Dictionary of words and how many times the word was shown to the user |
  | createdAt       | DateTime          | Date when user was created (default field) |
  | updatedAt       | DateTime          | Date when user was last updated (default field) |
  
### Networking
#### List of network requests by screen
   - Login/Register Screen
      - (Create/POST) Create a new user object with provided information
         ```swift
         let user = PFUser()
         user.username = usernameField.text
         user.password = passwordField.text
         user.signUpInBackground { (success, error) in
            If success {
              self.performSegue(with Identifier: “loginSegue”, sender: nil)
            } else {
              print(“Error: \(error?.localizedDescription ?? “???”)”)
            }
         }
         ```
   - Profile Screen
      - (Read/GET) Query logged in user object
        ```swift
        let user = PFUser.current()!
        nameLabel.text = user.username
        highScoreLabel.text = user.highScore
        timesPlayedLabel.text = user.gamesCount
        favoritedWordsLabel.text = user.favoritedWords.count
        streakCountLabel.text = user.streakCount
        ```

      - (Update/PUT) Update user profile image
        ```swift
        let user = PFUser.current()!
        if let imageFile = user["image"] as? PFFileObject {
           let urlString = imageFile.url!
           let url = URL(string: urlString)!
           profileImageView.af.setImage(withURL: url)
        }
        ```
        
      - (Update/PUT) Update user level 
        ```swift
        let user = PFUser.current()!
        if let userLevel = user[“level”] as! Int {
            user[level] += 1
        }
        ```

   
   - Definition Screen
      - (Read/GET) Get seenWords *(To compare to a random word)*
         ```swift
         let user = PFUser.current()!
         if let seenWords = user[“seenWords”] as? Dictionary<String, Int> {
            // If the word was seen more than 10 times
            If seenWords[randomWord] > 10 {
              seenWords[randomWord] -= 1
              // Get a different random word
            } else {
              // Track when the word is seen
              seenWords[randomWord] += 1
            }
         }
         ```

   - Game Screen
      - (Read/GET) Get seenWords *(To test user on words they have already been shown in the definition screen, as priority words)*
         ```swift
         let user = PFUser.current()!
         if let seenWords = user[“seenWords”] as? Dictionary<String, Int> {
            // TODO: Do something with dictionary
         }
         ```

      - (Update/PUT) Update count for word in the seenWords dictionary
         ```swift
         let user = PFUser.current()!
         if let seenWords = user[“seenWords”] as? Dictionary<String, Int> {
            seenWords[currentWord] += 1 
         }
         ```

      - (Update/PUT) highestScore
         ```swift
         let user = PFUser.current()!
         if let highScore = user[“highScore”] as! Int {
            user[highScore] += 100 
         }
         ```
         
      - (Update/PUT) streakCount
         ```swift
         let user = PFUser.current()!
         // set streakCount to 0 every time player loses a game
         // otherwise update streakCount
         if let gamesCount = user[“streakCount”] as! Int {
            user[streakCount] += 1 
         }
         ```
         
      - (Update/PUT) gamesCount
         ```swift
         let user = PFUser.current()!
         if let gamesCount = user[“gamesCount”] as! Int {
            user[gamesCount] += 1 
         }
         ```

   - Favorite Words Screen
      - (Read/GET) favoritedWords
         ```swift
         let user = PFUser.current()!
         favoritedWords = user[“favoritedWords”] as! [String]
         ```

#### [OPTIONAL:] Existing API Endpoints
##### WordsAPI
- Base URL - [https://wordsapiv1.p.mashape.com/words](https://wordsapiv1.p.mashape.com/words)

   HTTP Verb | Endpoint | Description
   ----------|----------|------------
    `GET`    | /{word} | Get a word
    `GET`    | /{word}?random=true | Get a random word
    `GET`    | /{word}/definitions  | Get definitions of a word
    `GET`    | /{word}/examples | Get examples of a word's usage
    `GET`    | /{word}/frequency | Get frequency score indicating how common a word is in the English language, with a range of 1 to 7
    `GET`    | /{word}/pronunciation | Get a word’s pronunciation, according to the International Phonetic Alphabet
