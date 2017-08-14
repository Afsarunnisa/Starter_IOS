//
//  Utilities.swift
//  APIStarters
//
//  Created by afsarunnisa on 6/19/15.
//  Copyright (c) 2015 NBosTech. All rights reserved.
//

import Foundation
import UIKit



//    Side menu list


var USER_DASHBOARD_STR           = "Dashboard"
var USER_PROFILE_STR             = "My Profile"

var USER_SETTINGS_STR           = "Settings"
var USER_CHANGE_PASSWORD_STR    = "Change Password"
var USER_SOCIAL_LINKS_STR       = "Social Links"
var USER_LOGOUT_STR             = "Logout"


//    Socail Buttons list

var SOCIAL_FACEBOOK_BTN         = "Facebook"
var SOCIAL_GOOGLE_BTN           = "GooglePlus"
var SOCIAL_LINKEDIN_BTN         = "LinkedIn"
var SOCIAL_GITHUB_BTN           = "GitHub"
var SOCIAL_INSTAGRAM_BTN        = "Instagram"


// Validations Errors

let USER_NAME_VALID_PLACEHOLDER = "Email*"
let USER_NAME_IN_VALID_PLACEHOLDER = "Please enter username!"

let PASSWORD_VALID_PLACEHOLDER = "Password*"
let PASSWORD_IN_VALID_PLACEHOLDER = "Please enter password!"


let EMAIL_VALID_PLACEHOLDER = "Email*"
let EMAIL_IN_VALID_PLACEHOLDER = "Please enter email id!"

let FIRST_NAME_VALID_PLACEHOLDER = "First Name*"
let FIRST_NAME_IN_VALID_PLACEHOLDER = "Please enter first name!"

let LAST_NAME_VALID_PLACEHOLDER = "Last Name"



var USER_SOCIAL_CONNECTS : NSMutableArray!



var CLIENT_ID = (Bundle.main.infoDictionary?["WavelabsAPISettings"]! as AnyObject).object(forKey: "WAVELABS_CLIENT_ID") as! String
var BASE_URL = (Bundle.main.infoDictionary?["WavelabsAPISettings"]! as AnyObject).object(forKey: "WAVELABS_BASE_URL") as! String
var CLIENT_SECRET = (Bundle.main.infoDictionary?["WavelabsAPISettings"]! as AnyObject).object(forKey: "WAVELABS_CLIENT_SECRET") as! String



struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}




struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
}


class utilities {
    
    
    static var serviceUrl = "http://starterapp.com:8080/starter-app-rest-grails/api/v0/"
//    static var clientID = "my-client"

    
    // padding view callback
    
    class func setLeftIcons(_ imgName: String,textField: UITextField) {
    
        var width : CGFloat = 0
        var height : CGFloat = 0
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            width = 40
            height = 40
            
        }else{
            width = 32
            height = 32
        }
        
        
//        let imageView = UIImageView(frame: CGRectMake(0, 0, width, height)); // set as you want
  //      let image: UIImage = UIImage(named: imgName)!
    //    imageView.image = image;
      //  imageView.contentMode = UIViewContentMode.Center
        
  //      let paddingView=UIView(frame: CGRectMake(0, 0, width, height))
    //    paddingView.addSubview(imageView)

      //  textField.leftViewMode = UITextFieldViewMode.Always
//        textField.leftView = paddingView

    }
    
    // alert view call back
    
    
    class func alertView(_ alertTitle: String, alertMsg:String, actionTitle: String) -> UIAlertController{
        let alert = UIAlertController(title:alertTitle, message:alertMsg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title:actionTitle, style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
    
    
    class func nullToNil(_ value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }

    
    
    class func  deviceType() -> AnyObject{
    
        var screenHeight : CGFloat = UIScreen.main.bounds.size.height
        let screenWidth : CGFloat = UIScreen.main.bounds.size.width
        
        if( screenHeight < screenWidth ){
            screenHeight = screenWidth;
        }
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
            // Ipad
            return "iPad" as AnyObject;
        }else{
            // Iphone
            
            if( screenHeight > 480 && screenHeight < 667 ){
                return "iPhone 5/5s" as AnyObject
            } else if ( screenHeight > 480 && screenHeight < 736 ){
                return "iPhone 6" as AnyObject
            } else if ( screenHeight > 480 ){
                return "iPhone 6 Plus" as AnyObject
            } else {
                return "iPhone 4/4s" as AnyObject
            }
        }
    }
    
    class func setPlaceHolder(_ text : String, validateText : String, textField : UITextField) {
        var semiColor : AnyObject = "" as AnyObject
        
        if(validateText == "Invalid"){
            let redColor = UIColor.red // 1.0 alpha
            semiColor = redColor.withAlphaComponent(0.5)
        }else{
            let lightGrayColor = UIColor.lightGray // 1.0 alpha
            semiColor = lightGrayColor.withAlphaComponent(0.5)
            
        }
        
        let placeHolder=NSAttributedString(string:text, attributes:    [NSForegroundColorAttributeName : semiColor])
        textField.attributedPlaceholder = placeHolder

    }

    class func isValueNull(_ value : AnyObject) -> AnyObject {

        var str : AnyObject!
    
        
//        if((value.isKind(of: NSNull())) == true){
//            str = "" as AnyObject
//        }else{
//            str = value
//        }
        return str
    }
    
    
    class func getParamsFromDict(_ paramsDict : NSDictionary) -> [String: AnyObject?] {
        
        let paramsStr = NSMutableString()
        var parameters: [String: AnyObject?] = [:]
        
        for index in 0 ..< paramsDict.allKeys.count {
            let keysList : NSArray = paramsDict.allKeys as NSArray
            
            let key : String = keysList.object(at: index) as! String
            let value : String = paramsDict.object(forKey: key) as! String

            parameters[key] = value as AnyObject
        }
        print("parameters \(parameters)")
        return parameters
    }
    
    
    
    
    func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
    class func textFieldBottomBorder(_ textField: UITextField) {
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true

    }
    
    
    class func addGradientLayer(_ imageView: UIImageView, height: Int) {
    
        let gradient = CAGradientLayer()
        gradient.name = "ImgGradientLayer"
        gradient.frame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y, width: imageView.frame.size.width, height: CGFloat(height))
       
        gradient.colors = [
                 UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3).cgColor,
                 UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3).cgColor
             ]
        
        
        let url = URL(string: "{{banner}}")
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            
            if(url != nil){
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                if(data != nil){
                    DispatchQueue.main.async(execute: {
                        imageView.image = UIImage(data: data!)
                    });
                }else{
                    imageView.image = UIImage(named:"console-window.png")
                }
            }else{
                imageView.image = UIImage(named:"console-window.png")
            }
        }
        imageView.layer.insertSublayer(gradient, at: 0)
    }
    
    
    class func addLogoImage(_ imageView : UIImageView) {
        
        let url = URL(string: "{{logo}}")
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            
            if(url != nil){
                let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                if(data != nil){
                    DispatchQueue.main.async(execute: {
                        imageView.image = UIImage(data: data!)
                    });
                }else{
                    imageView.image = UIImage(named:"nbos_ic")
                }
            }else{
                imageView.image = UIImage(named:"nbos_ic")
            }
        }
    }
    
    
    class func statusBarGradientAppear() {
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView

        let gradient = CAGradientLayer()
        gradient.name = "StatusGradientLayer"
        gradient.frame = statusBar.frame
        
        gradient.colors = [
            UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3).cgColor,
            UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3).cgColor
        ]
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.layer.insertSublayer(gradient, at: 0)
        }
    }
    
    
}
