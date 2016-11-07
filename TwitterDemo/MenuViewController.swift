//
//  MenuViewController.swift
//  TwitterDemo
//
//  Created by Jose Villanuva on 11/1/16.
//  Copyright © 2016 Jose Villanuva. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var muneTable: UITableView!
    
    private var tweetsNavigationController : UIViewController!
    private var profileNavigationController : UIViewController!
    private var mentionsNavigationController : UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController : HamburgerViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        muneTable.dataSource = self
        muneTable.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        tweetsNavigationController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        
        profileNavigationController = storyboard.instantiateViewController(withIdentifier: "ProfileNavigationController")
        
        mentionsNavigationController = storyboard.instantiateViewController(withIdentifier: "MentionsNavigationController")
        

        viewControllers.append(profileNavigationController)
        viewControllers.append(tweetsNavigationController)
        viewControllers.append(mentionsNavigationController)

        
        hamburgerViewController.contentViewController = tweetsNavigationController
        
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        let titles = ["Profile", "Home Timeline", "Mentions"]
        
        cell.menuTitleLabel.text = titles[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        
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
