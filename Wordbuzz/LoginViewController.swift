//
//  LoginViewController.swift
//  Wordbuzz
//
//  Created by Joey Steigelman on 4/27/21.
//

import UIKit
import Parse


class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var textFieldCollection: [UITextField]!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        configureTextFields()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onSignin(_ sender: Any) {
        
        let username = usernameField.text!
        let password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    
    @IBAction func onRegister(_ sender: Any) {
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        
        user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(error?.localizedDescription ?? "")")
            }
        }
    }
    
    
    func configureTextFields() {
        
        //set custom colors
        let customMediumGrayColor = UIColor(red:48/255, green:48/255, blue:61/255, alpha: 1)
        let customLightGrayColor = UIColor(red:194/255, green:194/255, blue:196/255, alpha: 1)
        
        //set placeholder text
        usernameField.attributedPlaceholder = NSAttributedString(string:"Username", attributes:[NSAttributedString.Key.foregroundColor: customLightGrayColor])
        passwordField.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSAttributedString.Key.foregroundColor: customLightGrayColor])
        
        //set left indentation
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        usernameField.leftViewMode = UITextField.ViewMode.always
        usernameField.leftView = spacerView
        
        let spacerView_password = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
        passwordField.leftViewMode = UITextField.ViewMode.always
        passwordField.leftView = spacerView_password
        
        //set borders
        configureGradient()
         
    }
    
    func configureGradient() {
        
        //set custom colors
        let customPurpleColor = UIColor(red:144/255, green:45/255, blue:254/255, alpha: 1)
        let customBlueColor = UIColor(red:42/255, green:55/255, blue:231/255, alpha: 1)
        
        //set gradient border on text fields
        for field in textFieldCollection {
            let lineWidth: CGFloat = 2
            let rect = field.bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: 14)
            let gradient = CAGradientLayer()
            gradient.frame =  CGRect(origin: CGPoint.zero, size: field.frame.size)
            gradient.colors = [customPurpleColor.cgColor, customBlueColor.cgColor]
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
            let shape = CAShapeLayer()
            shape.lineWidth = lineWidth
            shape.path = path.cgPath
            shape.strokeColor = UIColor.black.cgColor
            shape.fillColor = UIColor.clear.cgColor
            gradient.mask = shape
            field.layer.addSublayer(gradient)
        }
    }
    
    
    func configureButtons() {
        signinButton.clipsToBounds = true
        signinButton.layer.cornerRadius = 14
        registerButton.layer.cornerRadius = 14
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
