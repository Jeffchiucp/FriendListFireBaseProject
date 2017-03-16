//
//  thirdViewController.swift
//  chatApp
//
//  Created by JeffChiu on 2/22/17.
//  Copyright © 2017 Jeff Chiu. All rights reserved.
//


import UIKit

class thirdViewController: UIViewController,UITableViewDelegate,UITableViewDataSource 
 {
    @IBOutlet var tableView : UITableView!
    var friendsArr : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : UITableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendsArr.count
        
    }
    
    // task 5
    // Display lists the users belonging to the group.
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath as IndexPath) as! userCell
        
        cell.namelabel.text = friendsArr.object(at: indexPath.row) as! String
        
        
        
        return cell;
    }
    
    
    @IBAction func backClicked(_ sender: UIButton)
    {
       self.dismiss(animated: true) { 
        
        }
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
