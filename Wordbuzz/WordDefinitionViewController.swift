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
    
    var randomWord = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        getRandomWord()
        // Do any additional setup after loading the view.
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
        let headers = [
            "x-rapidapi-key": "a10993a051msh078390884b6556fp17dfdfjsn6ef5bb0fb17f",
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com"
        ]

        let url = URL(string: "https://wordsapiv1.p.rapidapi.com/words/?random=true")!
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
            }
        }
        dataTask.resume()
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
