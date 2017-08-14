//
//  SlideMenuVC.swift
//  APIStarters
//
//  Created by afsarunnisa on 6/19/15.
//  Copyright (c) 2015 NBosTech. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import idn_sdk_ios

class SlideMenuVC: UIViewController,UITableViewDelegate{

    
    var hud : MBProgressHUD = MBProgressHUD()

    @IBOutlet weak var sliderTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    let menuArray: NSArray = [USER_DASHBOARD_STR, USER_PROFILE_STR, USER_CHANGE_PASSWORD_STR]

    
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.backgroundColor = UIColor(red: 56/255.0, green: 63/255.0, blue: 69/255.0, alpha: 1.0)
        
        
        print("")
        
        userName.text = UserDefaults.standard.object(forKey: "user_Name") as? String
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor(red: 56/255.0, green: 63/255.0, blue: 69/255.0, alpha: 1.0)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func logoutBtnClick(_ sender: AnyObject) {
        self.addProgreeHud()
        
        let identityApiClass : IdentityApi.Type = IDS.getModuleApi("identity") as! IdentityApi.Type
        let identityAPi = identityApiClass.init()
        
        
        identityAPi.logout { (messageApiModel, error) in
            
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            if(error == nil){
                
                self.performSegueWithIdentifier("menuToLogin", sender: self)

            }else{
                
                SweetAlert().showAlert("Error", subTitle: "\(error)", style: AlertStyle.None)
            }

        }
    }
    
    
    func numberOfSectionsInTableView(_ tableView: UITableView?) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }

    
    func tableView(_ tableView: UITableView!, cellForRowAtIndexPath indexPath: IndexPath!) -> UITableViewCell!  {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)

        //we know that cell is not empty now so we use ! to force unwrapping
        
        cell.contentView.backgroundColor = UIColor.clear
        cell.textLabel!.text = menuArray.object(at: indexPath.row) as? String
        cell.textLabel!.textColor = UIColor.white
        cell.selectionStyle  = UITableViewCellSelectionStyle.none
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellText: String = menuArray.object(at: indexPath.row) as! String
        
        if(cellText == USER_LOGOUT_STR){
            self.addProgreeHud()
            
        }else if(cellText == USER_DASHBOARD_STR){
            performSegue(withIdentifier: "menuToDashboard", sender: self)
        }else if(cellText == USER_PROFILE_STR){
            performSegue(withIdentifier: "menuToSettings", sender: self)
        }else if(cellText == USER_CHANGE_PASSWORD_STR){
            performSegue(withIdentifier: "menuToChangepassword", sender: self)
        }else if(cellText == USER_SOCIAL_LINKS_STR){
            performSegue(withIdentifier: "menuToSocialLinks", sender: self)
        }
    }

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    

    func addProgreeHud(){
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .indeterminate
        hud.labelText = "Loading"
    }
}
