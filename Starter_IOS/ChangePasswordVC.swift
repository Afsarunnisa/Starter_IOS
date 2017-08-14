//
//  ChangePasswordVC.swift
//  APIStarters
//
//  Created by afsarunnisa on 6/22/15.
//  Copyright (c) 2015 NBosTech. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import idn_sdk_ios

class ChangePasswordVC: UIViewController{
    
//    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var currentPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var changePasswordBtn: UIButton!
    @IBOutlet weak var resetPasswordByEmailBtn: UIButton!

    var hud : MBProgressHUD = MBProgressHUD()
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar title
        self.title = "Change Password"
        
        // navigation bar background and title colors
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        nav?.tintColor = UIColor.darkGray
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
        nav?.backgroundColor = UIColor.darkGray
        
        if self.revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action:#selector(self.revealViewController().revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        changePasswordBtn.layer.cornerRadius = 8

        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        utilities.textFieldBottomBorder(currentPasswordTF)
        utilities.textFieldBottomBorder(newPasswordTF)

        
        let imgHeight : CGFloat = bannerImageView.frame.size.height
        utilities.addGradientLayer(bannerImageView, height: Int(imgHeight))
        utilities.addLogoImage(logoImageView)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    
    // MARK: - Button Actions

    @IBAction func resetPswdByEmailBtnClicked(_ sender: AnyObject) {
    }
    
    @IBAction func changePasswordBtnClicked(_ sender: AnyObject) {
        self.view.endEditing(true)

        let currentPswdStr: String = currentPasswordTF.text!
        let newPswdStr: String = newPasswordTF.text!
        
        if currentPswdStr.isEmpty {
            let alert = utilities.alertView("Alert", alertMsg: "Please enter current password",actionTitle: "Ok")
            self.present(alert, animated: true, completion: nil)
        }else if newPswdStr.isEmpty{
            let alert = utilities.alertView("Alert", alertMsg: "Please enter new password",actionTitle: "Ok")
            self.present(alert, animated: true, completion: nil)
        }else{
            
            let changePswDict : NSMutableDictionary = NSMutableDictionary()
            changePswDict.setObject(currentPswdStr, forKey: "password" as NSCopying)
            changePswDict.setObject(newPswdStr, forKey: "newPassword" as NSCopying)
            
            self.addProgreeHud()
            
            let identityApiClass : IdentityApi.Type = IDS.getModuleApi("identity") as! IdentityApi.Type
            let identityAPi = identityApiClass.init()
            
            identityAPi.changePassword(changePswDict as! Dictionary<String, Any>, responseHandler: {
                
                messageApimodel, error in
                
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if(error == nil){
                    SweetAlert().showAlert("Password", subTitle: "\(messageApimodel?.message)", style: AlertStyle.none)
                }else{
                    SweetAlert().showAlert("Error", subTitle: "\(messageApimodel?.message)", style: AlertStyle.none)
                }
                
            })

        }
    }
    
    
    @IBAction func resignBtnClikced(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    
    
    func moveToLogin(){
        
        print("Self \(self)")
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC: UINavigationController = mainStoryboard.instantiateViewController(withIdentifier: "mainNavigation") as! UINavigationController
        
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func addProgreeHud(){
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        hud.labelText = "Loading"
    }

}

