//
//  SecondViewController.swift
//  chatApp
//
//  Created by JeffChiu on 2/22/17.
//  Copyright © 2017 Jeff Chiu. All rights reserved.
//


import UIKit
import FirebaseDatabase

class SecondViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tableView : UITableView!
 
    /*
     // MARK: - Taks 5
     5. A tableview has a row for each group and lists the users belonging to the "group".  This should be loaded from Firebase.
     // Display lists the users belonging to the group at User List at thirdViewController

     */
    
    var friendsArr : NSMutableArray!
    var ref: FIRDatabaseReference!
    var groupRef : FIRDatabaseReference!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if appDelegate().chooseUser == true{
            appDelegate().chooseUser = false
            insertUsersInGroup(userArray: appDelegate().userListArr! as NSArray, groupName: appDelegate().groupName!)
            
        }
        
        print ("List arr:", appDelegate().userListArr)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        friendsArr = NSMutableArray()
        ref = FIRDatabase.database().reference()
        self.groupRef = self.ref.child("Groups")
           callAPI()

        
    }

    // displays LoadingIndicator when calling API.
    
    func callAPI (){
        LoadingIndicatorView.show(self.view, loadingText: "Loading...")
        self.groupRef.observeSingleEvent(of: .value, with: { (snapshot) in
             LoadingIndicatorView.hide()
            
            if snapshot.value is NSNull {
                
            } else {
                self.friendsArr.removeAllObjects()
                print("COunt",snapshot.childrenCount) // I got the expected number of items
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    print("value ",rest.value)
                    self.friendsArr.add(rest.value as! NSDictionary)
                }
                self.tableView.reloadData()


            }
        })
    }
    
    /*
     // MARK: - Taks 3
     3. Allow the user to select one or more friends in the table
     
     */ 
    

    func insertUsersInGroup (userArray : NSArray, groupName : String)
    {
        
        let key = self.groupRef.childByAutoId().key
        let group: NSDictionary = ["GroupName" : groupName, "userList": userArray]
        self.groupRef.updateChildValues(["/\(key)":group])
       callAPI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK : UITableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friendsArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath as IndexPath) as! groupCell
        cell.namelabel.text = ((friendsArr.value(forKey: "GroupName") as AnyObject).objectAt(indexPath.row)) as! String
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let UserVC = self.storyboard?.instantiateViewController(withIdentifier: "thirdViewController") as! thirdViewController
        let Arr  = ((friendsArr.value(forKey: "userList") as AnyObject).objectAt(indexPath.row)) as! NSArray
      UserVC.friendsArr = Arr
        self.present(UserVC, animated: true) {
            
        }
    }
/*
 // MARK: -Task 4
    //The user can press the ‘Create’ button to create a group from those selected users.  The group should be created in Firebase.

*/
    
    @IBAction func addButtonClicked(_ sender: UIButton)
    {
        let UserVC = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
        appDelegate().chooseUser = true
        self.present(UserVC, animated: true) {
            
        }
        
    }
}

