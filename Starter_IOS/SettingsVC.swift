//
//  SettingsVC.swift
//  APIStarters
//
//  Created by afsarunnisa on 6/19/15.
//  Copyright (c) 2015 NBosTech. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import idn_sdk_ios

class SettingsVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate {

    var hud : MBProgressHUD = MBProgressHUD()

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var uploadImageButton : UIButton!
    var photoSheet : UIActionSheet!
    var popOver:UIPopoverController?
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hud : MBProgressHUD = MBProgressHUD()

        
//        self.automaticallyAdjustsScrollViewInsets = false
        updateBtn.layer.cornerRadius = 8

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true

        
        utilities.textFieldBottomBorder(firstNameTF)
        utilities.textFieldBottomBorder(lastNameTF)
        utilities.textFieldBottomBorder(emailTF)

        
        imagePicker.delegate = self

        // navigation bar title
        self.title = "Settings"
        
        // navigation bar background and title colors
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.default
        nav?.tintColor = UIColor.darkGray
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGray]
        nav?.backgroundColor = UIColor.darkGray

        // for slider menu
        if self.revealViewController() != nil {
            menuButton.addTarget(self.revealViewController(), action:#selector(self.revealViewController().revealToggle(_:)), for: .touchUpInside)

            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        let defaults = UserDefaults.standard
        var userID : String
        
        if(utilities.nullToNil(defaults.string(forKey: "user_id") as AnyObject) == nil){ // checking for null
            userID = ""
        }else{
            userID = defaults.string(forKey: "user_id")! 
        }
        

        self.addProgreeHud()
        

        
        let identityApiClass : IdentityApi.Type = IDS.getModuleApi("identity") as! IdentityApi.Type
        let identityAPi = identityApiClass.init()
        
        identityAPi.getProfile(userID, responseHandler: {
            memberModel, messageApiModel, error in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            
            
            if(memberModel?.firstName != ""){
                self.firstNameTF.text = memberModel!.firstName
                self.lastNameTF.text = memberModel!.lastName
                self.emailTF.text = memberModel!.email
                
            }else if(messageApiModel != nil){
                
                SweetAlert().showAlert("Message", subTitle: "\((messageApiModel?.message)!)", style: AlertStyle.none)
                
            }else if(error != nil){
                SweetAlert().showAlert("Error", subTitle: "\(error)", style: AlertStyle.none)
            }

        })

        
        
        let mediaApiClass : MediaApi.Type = IDS.getModuleApi("media") as! MediaApi.Type
        let mediaAPi = mediaApiClass.init()
        
        mediaAPi.getMedia(userID, responseHandler: {
            mediaModel, messageApiModel, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            
            if(mediaModel?.mediaFileDetailsList != nil){
                print("Media responseObject \(String(describing: mediaModel))")
            
                let imgsArray = mediaModel!.mediaFileDetailsList as NSArray

                print("imgsArray \(imgsArray)")

                for i in 0 ..< imgsArray.count {
                    let mediaFileApiModel : MediaFileDetailsApiModel = imgsArray.object(at: i) as! MediaFileDetailsApiModel
                    let mediaType = mediaFileApiModel.mediatype

                    if(mediaType == "medium"){
                        
                        let mediaPathStr = mediaFileApiModel.mediapath
                        let mediaPathUrl: NSURL = NSURL(string: mediaPathStr)!

                        let data = NSData(contentsOf: mediaPathUrl as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
                        if(data != nil){
                            self.userImageView.image = UIImage(data: data! as Data)
                        }
                    }
                }
                
            }else if(messageApiModel != nil){
                    SweetAlert().showAlert("Message", subTitle: "\((messageApiModel?.message)!)", style: AlertStyle.none)
            }else if(error != nil){
                    SweetAlert().showAlert("Error", subTitle: "\(String(describing: error))", style: AlertStyle.none)
            }
            
        });
        
        
//        mediaAPi.getMedia(userID, responseHandler: {
//            mediaModel, messageModel, error in
//
//            
//            MBProgressHUD.hide(for: self.view, animated: true)
//
//            
//            if(mediaModel?.mediaFileDetailsList != nil){
//                print("Media responseObject \(String(describing: mediaModel))")
//
//                let imgsArray = mediaModel!.mediaFileDetailsList as NSArray
//
//                print("imgsArray \(imgsArray)")
//
//                for i in 0 ..< imgsArray.count {
//                    
//                    let mediaFileApiModel : MediaFileDetailsApiModel = imgsArray.object(at: i) as! MediaFileDetailsApiModel
//                    let mediaType = mediaFileApiModel.mediatype
//
//                    if(mediaType == "medium"){
//                        
//                        let mediaPathStr = mediaFileApiModel.mediapath
//                        let mediaPathUrl: NSURL = NSURL(string: mediaPathStr)!
//
//                        //                        let data = NSData(con)
//                        
//                        let data = try Data(contentsOf: mediaPathUrl as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
//
//                        if(data != nil){
//                            self.userImageView.image = UIImage(data: data!)
//                        }
//                    }
//                }
//
//            }else if(messageModel != nil){
//                SweetAlert().showAlert("Message", subTitle: "\((messageModel?.message)!)", style: AlertStyle.none)
//                
//            }else if(error != nil){
//                SweetAlert().showAlert("Error", subTitle: "\(String(describing: error))", style: AlertStyle.none)
//            }
//
//        })
        
        
//        mediaAPi.getMedia(userID, responseHandler: {
//            
//            mediaModel, messageModel, error in
//            
//            MBProgressHUD.hide(for: self.view, animated: true)
//            
//            
//            
//            
//            if(mediaModel?.mediaFileDetailsList != nil){
//                print("Media responseObject \(String(describing: mediaModel))")
//                
//                let imgsArray = mediaModel!.mediaFileDetailsList as NSArray
//                
//                print("imgsArray \(imgsArray)")
//                
//                for i in 0 ..< imgsArray.count {
//                    
//                    let mediaFileApiModel : MediaFileDetailsApiModel = imgsArray.object(at: i) as! MediaFileDetailsApiModel
//                    let mediaType = mediaFileApiModel.mediatype
//                    
//                    if(mediaType == "medium"){
//                        
//                        let mediaPathStr = mediaFileApiModel.mediapath
//                        let mediaPathUrl: NSURL = NSURL(string: mediaPathStr)!
//                        
////                        let data = NSData(con)
//                        
//                        let data = try Data(contentsOf: mediaPathUrl as URL) //make sure your image in this url does exist, otherwise unwrap in a if let check
//
//                        if(data != nil){
//                            self.userImageView.image = UIImage(data: data!)
//                        }
//                    }
//                }
//                
//            }else if(messageModel != nil){
//                SweetAlert().showAlert("Message", subTitle: "\((messageModel?.message)!)", style: AlertStyle.none)
//                
//            }else if(error != nil){
//                SweetAlert().showAlert("Error", subTitle: "\(String(describing: error))", style: AlertStyle.none)
//            }
//
//
//        })
        
        
        
        
        let imgHeight : CGFloat = bannerImageView.frame.size.height
        utilities.addGradientLayer(bannerImageView, height: Int(imgHeight))
        utilities.addLogoImage(logoImageView)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    
    // MARK: - Button actions

    @IBAction func updateBtnClicked(_ sender: AnyObject) {
        let firstNameStr : String = firstNameTF.text!
        let lastNameStr : String = lastNameTF.text!
        let emailStr : String = emailTF.text!
        
        if firstNameStr.isEmpty{
            let alert = utilities.alertView("Alert", alertMsg: FIRST_NAME_IN_VALID_PLACEHOLDER,actionTitle: "Ok")
            self.present(alert, animated: true, completion: nil)
        }else{
            
            let profileDict : NSMutableDictionary = NSMutableDictionary()
            profileDict.setObject(firstNameStr, forKey: "firstName" as NSCopying)
            profileDict.setObject(lastNameStr, forKey: "lastName" as NSCopying)
            profileDict.setObject("", forKey: "phone" as NSCopying)
            profileDict.setObject("", forKey: "description" as NSCopying)
            profileDict.setObject(emailStr, forKey: "email" as NSCopying)
            
            self.addProgreeHud()
//            usersApi.updateProfile(profileDict)
        
            let defaults = UserDefaults.standard
            var userID : String
            
            if(utilities.nullToNil(defaults.string(forKey: "user_id") as AnyObject) == nil){ // checking for null
                userID = ""
            }else{
                userID = defaults.string(forKey: "user_id")!
            }

            
            
            let identityApiClass : IdentityApi.Type = IDS.getModuleApi("identity") as! IdentityApi.Type
            let identityAPi = identityApiClass.init()
            
            
            identityAPi.updateProfile(profileDict as! Dictionary<String, Any>, userID: userID, responseHandler: {
                
                 memberModel, messageApiModel,error in
                
                MBProgressHUD.hide(for: self.view, animated: true)

                
                
                if(memberModel?.firstName != ""){
                    self.firstNameTF.text = memberModel!.firstName
                    self.lastNameTF.text = memberModel!.lastName
                    self.emailTF.text = memberModel!.email
                    
                    
                    SweetAlert().showAlert("Profile", subTitle: "Profile Updated", style: AlertStyle.none)
                    
                }else if(messageApiModel != nil){
                    SweetAlert().showAlert("Message", subTitle: "\((messageApiModel?.message)!)", style: AlertStyle.none)
                    
                }else if(error != nil){
                    SweetAlert().showAlert("Error", subTitle: "\(error)", style: AlertStyle.none)
                }

                
            })
            
        }
    }
    
    
    @IBAction func uploadProfilePhotoBtnClicked(_ sender: AnyObject) {
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            
            uploadImageButton = sender as! UIButton

            photoSheet = UIActionSheet()
            photoSheet.delegate = self
            photoSheet = UIActionSheet(title: "", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Camera Roll", "Camera","")
            photoSheet.show(from: CGRect(x: uploadImageButton.frame.origin.x,y: uploadImageButton.frame.origin.y, width: 100, height: 100), in: self.view, animated: true)
            photoSheet.show(in: self.view)
        }else{
            let alert = UIAlertController(title: "Please choose source", message: nil, preferredStyle:
                .actionSheet) // Can also set to .Alert if you prefer
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) -> Void in
                self.showPhotoPicker(.camera)
            }
            
            alert.addAction(cameraAction)
            
            let libraryAction = UIAlertAction(title: "Library", style: .default) { (action) -> Void in
                self.showPhotoPicker(.photoLibrary)
            }
            
            
            alert.addAction(libraryAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
            })
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: - Image picker delegate methods

    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int){
        if(buttonIndex == 1){
            self.showPhotoPopOver(.photoLibrary)
        }else if(buttonIndex == 2){
            self.showPhotoPopOver(.camera)
        }
    }

    
    func showPhotoPicker(_ source: UIImagePickerControllerSourceType) {
        
        if(source == UIImagePickerControllerSourceType.camera){
            if(UIDevice.current.model == "iPhone Simulator"){
                return
            }
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }

    func showPhotoPopOver(_ source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.delegate = self
        self.popOver  = UIPopoverController(contentViewController: imagePicker)
    
        let backgroundQueue = OperationQueue()
        
        backgroundQueue.addOperation(){
            OperationQueue.main.addOperation(){
                self.popOver?.present(from: CGRect(x: self.uploadImageButton.frame.origin.x,y: self.uploadImageButton.frame.origin.y,width: 100,height: 80), in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        
        let selectedImg = info[UIImagePickerControllerOriginalImage] as! UIImage
        userImageView.contentMode = .scaleAspectFit //3
        userImageView.image = selectedImg //4
        dismiss(animated: true, completion: nil) //5
    
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        
        let defaults = UserDefaults.standard
        let userID = defaults.string(forKey: "user_id")
        
        let fileName : String =  NSString(format:"%@.png", userID!) as String
        
        
        
        let fileManager = FileManager.default
        let docsURL = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

        let imageDirURL = docsURL.appendingPathComponent("Images")
        
        if !fileManager.fileExists(atPath: imageDirURL.path) {
            do {
                try fileManager.createDirectory(at: imageDirURL, withIntermediateDirectories: false, attributes:nil)
            } catch let error as NSError{
                print("Error creating SwiftData image folder", error)
            }
        }

        let storePath = URL(fileURLWithPath: imageDirURL.path).appendingPathComponent(fileName)
        let imgData : Data = UIImagePNGRepresentation(selectedImg)!
        try? imgData.write(to: storePath, options: [])
        
        self.addProgreeHud()
        
        
        
        let mediaApiClass : MediaApi.Type = IDS.getModuleApi("media") as! MediaApi.Type
        let mediaApi = mediaApiClass.init()

        
        mediaApi.uploadMedia(userID!, imgName: fileName, mediaFor:"profile", responseHandler: {
            
            messageApiModel,error in
            
            MBProgressHUD.hide(for: self.view, animated: true)

            if(error == nil){
                SweetAlert().showAlert("Profile", subTitle: "Profile Photo Updated", style: AlertStyle.none)
            }else{
                SweetAlert().showAlert("Error", subTitle: error?.description, style: AlertStyle.none)
            }
        })
        
        
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    

    func moveToLogin(){
       
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




