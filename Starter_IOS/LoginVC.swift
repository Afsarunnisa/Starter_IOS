//
//  ViewController.swift
//  idn_app_ios
//
//  Created by Afsarunnisa on 9/25/16.
//  Copyright © 2016 Afsarunnisa. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import MBProgressHUD
import idn_sdk_ios

class LoginVC: UIViewController,UIAlertViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,GIDSignInUIDelegate,GIDSignInDelegate {
   
    var hud : MBProgressHUD = MBProgressHUD()
    
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var cantRememberPasswordBtn: UIButton!
    @IBOutlet weak var loginFBBtn: UIButton!
    
    var loginBtnFrmae : CGRect = CGRect.zero
    var webViewRedirectUrl : String = ""
    var webViewTitle : String = ""
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    // alert views with actions
    
    var forgotPasswordAlert = UIAlertView()
    var forgotPasswordText = "";

    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var bannerImg_View_Height_Constraint:NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        
        utilities.textFieldBottomBorder(emailTextField)
        utilities.textFieldBottomBorder(passwordTextField)
        
        cantRememberPasswordBtn.contentHorizontalAlignment = .right
        registerBtn.contentHorizontalAlignment = .left
        LoginBtn.layer.cornerRadius = 8
        
        refreshTextFields()

        // Do any additional setup after loading the view, typically from a nib.
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        
        signInButton.style = GIDSignInButtonStyle.iconOnly
        var imgHeight : Int = 140
        
        
        if(DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS){
            imgHeight = 140
        }else if(DeviceType.IS_IPHONE_6){
            imgHeight = 160
        }else if(DeviceType.IS_IPHONE_6P){
            imgHeight = 200
        }
        
        if(bannerImg_View_Height_Constraint != nil){
            self.view.removeConstraint(bannerImg_View_Height_Constraint)
        }

        bannerImg_View_Height_Constraint  = (NSLayoutConstraint(
            item:bannerImageView, attribute:NSLayoutAttribute.height,
            relatedBy:NSLayoutRelation.equal,
            toItem:nil, attribute:NSLayoutAttribute.notAnAttribute,
            multiplier:0, constant:CGFloat(imgHeight)))

        
        self.view.addConstraint(bannerImg_View_Height_Constraint)
        
        utilities.addGradientLayer(bannerImageView, height: imgHeight)
        utilities.addLogoImage(logoImageView)
        utilities.statusBarGradientAppear()
        
        self.addProgreeHud()
        let tokenApiClass : TokenApi.Type = IDS.getModuleApi("token") as! TokenApi.Type
        let tokenAPi = tokenApiClass.init()
        
        tokenAPi.getClientToken({
            tokenModel, messageApiModel, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if(tokenModel != nil){
                
            }else if(messageApiModel != nil){
                SweetAlert().showAlert("Message", subTitle: "\(String(describing: messageApiModel?.message))", style: AlertStyle.none)

            }else if(error != nil){
                SweetAlert().showAlert("Error", subTitle: "\(String(describing: error))", style: AlertStyle.none)
            }
            
        })
    }
        
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated);
//        var failResponse = Dictionary<String, String>()
//        let defaults = UserDefaults.standard
//        if((utilities.nullToNil(defaults.object(forKey: "webViewFailResponse") as! _ == nil)) != nil){
//            failResponse = Dictionary<String, String>()
//        }else{
//            failResponse = defaults.object(forKey: "user_id")! as! Dictionary
//        }
        
        refreshTextFields()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Button Actions
    
    
    @IBAction func loginBtnClicked(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        let emailStr: String = emailTextField.text!
        let passwordStr: String = passwordTextField.text!
        
        if (emailStr.isEmpty && passwordStr.isEmpty){
            utilities.setPlaceHolder(USER_NAME_IN_VALID_PLACEHOLDER, validateText: "Invalid", textField: emailTextField)
            utilities.setPlaceHolder(PASSWORD_IN_VALID_PLACEHOLDER, validateText: "Invalid", textField: passwordTextField)
        }else if emailStr.isEmpty {
            utilities.setPlaceHolder(USER_NAME_IN_VALID_PLACEHOLDER, validateText: "Invalid", textField: emailTextField)
        }else if passwordStr.isEmpty{
            utilities.setPlaceHolder(PASSWORD_IN_VALID_PLACEHOLDER, validateText: "Invalid", textField: passwordTextField)
        }else{
            
            let loginDict : NSMutableDictionary = NSMutableDictionary()
            loginDict.setObject(emailStr, forKey: "username" as NSCopying)
            loginDict.setObject(passwordStr, forKey: "password" as NSCopying)
            
            self.addProgreeHud()
  
            let identityApiClass : IdentityApi.Type = IDS.getModuleApi("identity") as! IdentityApi.Type
            let identityAPi = identityApiClass.init()
            
            let login : LoginModel = LoginModel()
            login.username = emailStr;
            login.password = passwordStr;
            
            
            
            identityAPi.login(login, responseHandler: {
                newMemberModel,messageApiModel, error in
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if(newMemberModel?.memberApiModel != nil){
                    let memberEty : MemberApiModel = newMemberModel!.memberApiModel
                    
                    let defaults = UserDefaults.standard
                    defaults.set(memberEty.id, forKey: "user_id")
                    defaults.set(memberEty.firstName, forKey: "user_Name")
                    defaults.synchronize()
                    
                    
                    self.performSegue(withIdentifier: "LoginToDashboard", sender: self)
                    
                }else if(messageApiModel != nil){
                    SweetAlert().showAlert("Message", subTitle: "\((messageApiModel?.message)!)", style: AlertStyle.none)
                    
                }else if(error != nil){
                    SweetAlert().showAlert("Error", subTitle: "\(String(describing: error))", style: AlertStyle.none)
                }

            })
        }
    }
    
    @IBAction func signUpBtnClicked(_ sender: AnyObject) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let registerVC: RegistrationVC = mainStoryboard.instantiateViewController(withIdentifier: "RegistrationVC") as! RegistrationVC
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @IBAction func resignBtnClikced(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func forgotPasswordBtnClicked(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        refreshTextFields()
        
        let alert = UIAlertController(title: "Enter email id", message: "Alert Message", preferredStyle:
            UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: textFieldHandler)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            print("forgotPasswordText\(self.forgotPasswordText)")
        }))
        
        self.present(alert, animated: true, completion:nil)
    }
    
    func textFieldHandler(textField: UITextField!)
    {
        if (textField) != nil {
            textField.delegate = self
            textField.tag = 1001
        }
    }
    
    
    // MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        if(textField == emailTextField){
            utilities.setPlaceHolder(USER_NAME_VALID_PLACEHOLDER, validateText: "Valid", textField: emailTextField)
        }else if(textField == passwordTextField){
            utilities.setPlaceHolder(PASSWORD_VALID_PLACEHOLDER, validateText: "Valid", textField: passwordTextField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        
        if(textField == emailTextField){
            passwordTextField.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        
        if(textField.tag == 1001){
            forgotPasswordText = textField.text!;
        }
        
        return true
    }
    
    
    // MARK: - Facebook Delegate Methods
    
    @IBAction func loginFbBtnClicked(_ sender: AnyObject) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self, handler: { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                
                if(fbloginresult.grantedPermissions != nil){
                    if(fbloginresult.grantedPermissions.contains("email")){
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        })
    }
    
    
    
    func getFBUserData(){
        
        let fbAccessToken = FBSDKAccessToken.current().tokenString
        
        let socialLoginDict : NSMutableDictionary = NSMutableDictionary()
        socialLoginDict.setObject(fbAccessToken, forKey: "accessToken" as NSCopying)
        socialLoginDict.setObject("", forKey: "expiresIn" as NSCopying)
        
        self.addProgreeHud()
        
        let identityApiClass : IdentityApi.Type = IDS.getModuleApi("identity") as! IdentityApi.Type
        let identityAPi = identityApiClass.init()

        identityAPi.socialLogin(socialLoginDict as! Dictionary<String, Any>, socialType: "facebook", responseHandler: {
            
            newMemberModel, messageApiModel, error in
            MBProgressHUD.hide(for: self.view, animated: true)

            
            
            if(newMemberModel?.memberApiModel != nil){
                let memberEty : MemberApiModel = newMemberModel!.memberApiModel
                
                let defaults = UserDefaults.standard
                defaults.set(memberEty.id, forKey: "user_id")
                defaults.set(memberEty.firstName, forKey: "user_Name")
                defaults.synchronize()
                
                
                self.performSegue(withIdentifier: "LoginToDashboard", sender: self)
                
            }else if(messageApiModel != nil){
                SweetAlert().showAlert("Message", subTitle: "\((messageApiModel?.message)!)", style: AlertStyle.none)
                
            }else if(error != nil){
                SweetAlert().showAlert("Error", subTitle: "\(error)", style: AlertStyle.none)
            }

        })
    }
    
    
    // MARK: - Google Plus Delegate Methods
    
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: NSError!) {
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
                present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
                dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let name = user.profile.name
//            let email = user.profile.email
            let accessToken = user.authentication.accessToken // Safe to send to the server
            
            let socialLoginDict : NSMutableDictionary = NSMutableDictionary()
            socialLoginDict.setObject(accessToken, forKey: "accessToken" as NSCopying)
            socialLoginDict.setObject("", forKey: "expiresIn" as NSCopying)
            
            self.addProgreeHud()
            
            let identityApiClass : IdentityApi.Type = IDS.getModuleApi("identity") as! IdentityApi.Type
            let identityAPi = identityApiClass.init()
            
            identityAPi.socialLogin(socialLoginDict as! Dictionary<String, Any>, socialType: "googlePlus", responseHandler: {
                
                newMemberModel, messageApiModel, error in
                MBProgressHUD.hide(for: self.view, animated: true)

                if(newMemberModel?.memberApiModel != nil){
                    let memberEty : MemberApiModel = newMemberModel!.memberApiModel
                    
                    let defaults = UserDefaults.standard
                    defaults.set(memberEty.id, forKey: "user_id")
                    defaults.set(memberEty.firstName, forKey: "user_Name")
                    defaults.synchronize()
                    
                    
                    self.performSegue(withIdentifier: "LoginToDashboard", sender: self)
                    
                }else if(messageApiModel != nil){
                    SweetAlert().showAlert("Message", subTitle: "\((messageApiModel?.message)!)", style: AlertStyle.none)
                    
                }else if(error != nil){
                    SweetAlert().showAlert("Error", subTitle: "\(error)", style: AlertStyle.none)
                }

            })
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    
    
    // MARK: - Alert view Delegates
    
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int){
        
        if(alertView == forgotPasswordAlert){
            if(buttonIndex == 1){
                let textField: UITextField = alertView.textField(at: 0)!
                if(textField.text == ""){
                    let alert = utilities.alertView("Alert", alertMsg: "Please enter email id",actionTitle: "Ok")
                    self.present(alert, animated: true, completion: nil)
                }else{
                    
                    let forgotPswDict : NSMutableDictionary = NSMutableDictionary()
                    forgotPswDict.setObject(textField.text!, forKey: "email" as NSCopying)
                    
                    self.addProgreeHud()
                    
                    let identityApiClass : IdentityApi.Type = IDS.getModuleApi("identity") as! IdentityApi.Type
                    let identityAPi = identityApiClass.init()
                    
                    
                    identityAPi.forgotPassword(forgotPswDict as! Dictionary<String, Any>, responseHandler: {
                        messageModel, error in
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        if(error == nil){                            
                            SweetAlert().showAlert("Message", subTitle: "\(messageModel?.message)", style: AlertStyle.none)
                        }else{
                            SweetAlert().showAlert("Error", subTitle: "\(error)", style: AlertStyle.none)
                        }
                    })
                }
            }
        }
    }
    
    
    
    
    func refreshTextFields(){
        utilities.setPlaceHolder(USER_NAME_VALID_PLACEHOLDER, validateText: "Valid", textField: emailTextField)
        utilities.setPlaceHolder(PASSWORD_VALID_PLACEHOLDER, validateText: "Valid", textField: passwordTextField)
    }
    
    func addProgreeHud(){
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        hud.labelText = "Loading"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "LoginToWebView") {
            // pass data to next view
            
            //            if let destinationVC = segue.destinationViewController as? WebViewVC{
            //                destinationVC.redirectUrl = webViewRedirectUrl
            //                destinationVC.headerTitle = webViewTitle
            //                destinationVC.parentView  = "LoginView"
            //            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        if (GIDSignIn.sharedInstance().currentUser != nil) {
            let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
            // Use accessToken in your URL Requests Header
        }
    }
}
