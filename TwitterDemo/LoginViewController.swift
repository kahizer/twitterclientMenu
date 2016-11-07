//
//  LoginViewController.swift
//  TwitterDemo
//
//  Created by Jose Villanuva on 10/25/16.
//  Copyright © 2016 Jose Villanuva. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var twittercolor = UIColor.init(red: 85/250.0, green: 172/250.0, blue: 238/50.0, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = twittercolor

        navigationController?.navigationBar.tintColor = twittercolor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    @IBAction func onLoginButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.login(success: {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
            }, failure: { (error:NSError) in
                print("Erro: \(error.localizedDescription)")
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
