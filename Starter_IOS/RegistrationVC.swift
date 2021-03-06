//
//  RegistrationVC.swift
//  APIStarters
//
//  Created by afsarunnisa on 6/19/15.
//  Copyright (c) 2015 NBosTech. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import MBProgressHUD
import idn_sdk_ios

//GPPSignInDelegate

class RegistrationVC: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
    
    
    var hud : MBProgressHUD = MBProgressHUD()

    var kPreferredTextFieldToKeyboardOffset: CGFloat = 600.0
    var keyboardFrame: CGRect = CGRect.null
    var keyboardIsShowing: Bool = false
    weak var activeTextField: UITextField?
    
    var textFieldOffset: CGFloat = 0

    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signUpScrollView: UIScrollView!
    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!


    @IBOutlet weak var loginButton: UIButton!
    
    var bannerImg_View_Height_Constraint:NSLayoutConstraint!

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // navigation bar title
        self.title = "Registration"
        
//        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        utilities.textFieldBottomBorder(firstNameTF)
        utilities.textFieldBottomBorder(lastNameTF)
        utilities.textFieldBottomBorder(emailTF)
        utilities.textFieldBottomBorder(passwordTF)
        utilities.textFieldBottomBorder(userNameTF)


        signUpBtn.layer.cornerRadius = 8
        loginButton.contentHorizontalAlignment = .left

        googleSignInButton.style = GIDSignInButtonStyle.iconOnly

        
        
        if(utilities.deviceType() as! String == "iPhone 4/4s" || utilities.deviceType() as! String == "iPhone 5/5s"){
            textFieldOffset = 70
        }else if(utilities.deviceType() as! String == "iPhone 6" || utilities.deviceType() as! String == "iPhone 6 Plus"){
            textFieldOffset = 100
        }
        
        refreshTextFields()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        
        
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

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Textfield Delegate Methods

    
    @IBAction func textFieldDidReturn(_ textField: UITextField!){
        textField.resignFirstResponder()
        self.activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        
        if(textField == firstNameTF){
            lastNameTF.becomeFirstResponder()
        }else if(textField == lastNameTF){
            userNameTF.becomeFirstResponder()
        }else if(textField == userNameTF){
            emailTF.becomeFirstResponder()
        }else if(textField == emailTF){
            passwordTF.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        self.activeTextField = textField
        
        if(utilities.deviceType() as! String != "iPad"){
            signUpScrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y-textFieldOffset), animated: true)
        }else{
            if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)){
                signUpScrollView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y-140), animated: true)
            }
        }

        if(textField == firstNameTF){
            utilities.setPlaceHolder("First Name*", validateText: "Valid", textField: firstNameTF)
        }else if(textField == lastNameTF){
            utilities.setPlaceHolder("Last Name", validateText: "Valid", textField: lastNameTF)
        }else if(textField == userNameTF){
            utilities.setPlaceHolder("User Name*", validateText: "Valid", textField: lastNameTF)
            
        }else if(textField == emailTF){
            utilities.setPlaceHolder("Email*", validateText: "Valid", textField: emailTF)
        }else if(textField == passwordTF){
            utilities.setPlaceHolder("Password*", validateText: "Valid", textField: passwordTF)
        }
    }
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(utilities.deviceType() as! String != "iPad"){
            signUpScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }else{
            if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)){
                signUpScrollView.setContentOffset(CGPoint(x: 0, y: -60), animated: true)
            }
        }
    }
    
    
    // MARK: - Button Actions

    @IBAction func resignBtnClikced(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func signUpBtnClicked(_ sender: AnyObject) {
        
        let firstNameStr: String = firstNameTF.text!
        let emailStr: String = emailTF.text!
        let passwordStr: String = passwordTF.text!
        let lastNameStr: String = lastNameTF.text!
        let userNameStr: String = userNameTF.text!
        
        if(firstNameStr.isEmpty && emailStr.isEmpty && passwordStr.isEmpty){
            
            utilities.setPlaceHolder(FIRST_NAME_IN_VALID_PLACEHOLDER, validateText: "Invalid", textField: firstNameTF)
            utilities.setPlaceHolder(USER_NAME_IN_VALID_PLACEHOLDER, validateText: "Invalid", textField: userNameTF)
            utilities.setPlaceHolder(EMAIL_IN_VALID_PLACEHOLDER, validateText: "Invalid", textField: emailTF)
            utilities.setPlaceHolder(PASSWORD_IN_VALID_PLACEHOLDER, validateText: "Invalid", textField: passwordTF)
            
        }else if(firstNameStr.isEmpty || emailStr.isEmpty || passwordStr.isEmpty){
            
            if firstNameStr.isEmpty {
                utilities.setPlaceHolder(FIRST_NAME_IN_VALID_PLACEHOLDER, validateText: "Invalid", textField: firstNameTF)
            }
            if userNameStr.isEmpty{
                utilities.setPlaceHolder(USER_NAME_IN_VALID_PLACEHOLDER, validateText: "Invalid", textField: userNameTF)
            }
            if emailStr.isEmpty{
                utilities.setPlaceHolder(EMAIL_IN_VALID_PLACEHOLDER, validateText: "Invalid", textField: emailTF)
            }
            
            if passwordStr.isEmpty{
                utilities.setPlaceHolder(PASSWORD_IN_VALID_PLACEHOLDER, validateText: "Invalid", textField: passwordTF)
            }
        }else{
            
            let rigisterDict : NSMutableDictionary = NSMutableDictionary()
            rigisterDict.setObject(userNameStr, forKey: "username" as NSCopying)
            rigisterDict.setObject(emailStr, forKey: "email" as NSCopying)
            rigisterDict.setObject(passwordStr, forKey: "password" as NSCopying)
            rigisterDict.setObject(firstNameStr, forKey: "firstName" as NSCopying)
            rigisterDict.setObject(lastNameStr, forKey: "lastName" as NSCopying)
//            rigisterDict.setObject(CLIENT_ID, forKey: "clientId")
            
            self.addProgreeHud()
//            usersApi.registerUser(rigisterDict)

        
            
            let identityApiClass : IdentityApi.Type = IDS.getModuleApi("identity") as! IdentityApi.Type
            let identityAPi = identityApiClass.init()
            
            var signUp : SignUpModel = SignUpModel()
            
            signUp.email = emailStr;
            signUp.username = userNameStr;
            signUp.password = passwordStr;
            signUp.firstName = firstNameStr;
            signUp.lastName = lastNameStr;

            
            identityAPi.signUp(signUp, responseHandler: {
                
                newMemberModel, messageApiModel, error in
                
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                
                
                if(newMemberModel?.memberApiModel != nil){
                    let memberEty : MemberApiModel = newMemberModel!.memberApiModel
                    
                    
                    let defaults = UserDefaults.standard
                    defaults.set(memberEty.id, forKey: "user_id")
                    defaults.set(memberEty.firstName, forKey: "user_Name")
                    defaults.synchronize()
                    
                    
                    self.performSegue(withIdentifier: "SignUpToDashboard", sender: self)
                    
                }else if(messageApiModel != nil){
                    SweetAlert().showAlert("Message", subTitle: "\((messageApiModel?.message)!)", style: AlertStyle.none)
                    
                }else if(error != nil){
                    SweetAlert().showAlert("Error", subTitle: "\(String(describing: error))", style: AlertStyle.none)
                }

            })
        
        }
    }


    @IBAction func loginButtonClicked(_ sender: AnyObject) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    @IBAction func goBackBtnClick(_ sender: AnyObject) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }

    
    
    // MARK: - Google Plus Delegate Methods
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: NSError!) {
        //        myActivityIndicator.stopAnimating()
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
//                let userId = user.userID                  // For client-side use only!
//                let idToken = user.authentication.idToken // Safe to send to the server
//                let name = user.profile.name
//                let email = user.profile.email
//                
//                let expiry = user.authentication // Safe to send to the server
                let accessToken = user.authentication.accessToken
                
                
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
                        let tokenEty : TokenApiModel = newMemberModel!.tokenApiModel
                        let memberEty : MemberApiModel = newMemberModel!.memberApiModel
                        
                        
                        let defaults = UserDefaults.standard
                        defaults.set(memberEty.id, forKey: "user_id")
                        defaults.set(memberEty.firstName, forKey: "user_Name")
                        defaults.synchronize()
                        
                        
                        self.performSegue(withIdentifier: "SignUpToDashboard", sender: self)
                        
                    }else if(messageApiModel != nil){
                        SweetAlert().showAlert("Message", subTitle: "\((messageApiModel?.message)!)", style: AlertStyle.none)
                        
                    }else if(error != nil){
                        SweetAlert().showAlert("Error", subTitle: "\(String(describing: error))", style: AlertStyle.none)
                    }
                })
            } else {
                print("\(error.localizedDescription)")
            }
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
                
                
                self.performSegue(withIdentifier: "SignUpToDashboard", sender: self)
                
            }else if(messageApiModel != nil){
                SweetAlert().showAlert("Message", subTitle: "\((messageApiModel?.message)!)", style: AlertStyle.none)
                
            }else if(error != nil){
                SweetAlert().showAlert("Error", subTitle: "\(String(describing: error))", style: AlertStyle.none)
            }
            

        })
    }
    
    
    func alertView(_ View: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    
    func addProgreeHud(){
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        hud.labelText = "Loading"
    }

    func refreshTextFields(){
        utilities.setPlaceHolder("First Name*", validateText: "Valid", textField: firstNameTF)
        utilities.setPlaceHolder("Last Name", validateText: "Valid", textField: lastNameTF)
        utilities.setPlaceHolder("User Name*", validateText: "Valid", textField: userNameTF)
        utilities.setPlaceHolder("Email*", validateText: "Valid", textField: emailTF)
        utilities.setPlaceHolder("Password*", validateText: "Valid", textField: passwordTF)
    }
}
