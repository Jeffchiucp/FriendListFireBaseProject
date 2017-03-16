//
//  FirstViewController.swift
//  chatApp
//
//  Created by JeffChiu on 2/22/17.
//  Copyright © 2017 Jeff Chiu. All rights reserved.
//

import UIKit
import Alamofire
import ReachabilitySwift

class FirstViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView : UITableView!
     @IBOutlet var doneButton : UIButton!
    var friendsArr : NSMutableArray!
       var reachability = Reachability()!
    
    override func viewWillAppear(_ animated: Bool) {
        if appDelegate().chooseUser == true{
            doneButton.isHidden = false
         self.tableView.allowsMultipleSelection = true
        }
        else{
         doneButton.isHidden = true
        }
    }
    
    //Display list of friends 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsArr = NSMutableArray()
              self.fetchFriendsList()
       doneButton.isHidden = true
     
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable {
       
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            let    alert = UIAlertController(title: "Network Error!", message: "Please check your internet connection setting", preferredStyle: UIAlertControllerStyle.alert)
            self.present(alert, animated: true, completion: nil)
          
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil));
            print("Network not reachable")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchFriendsList (){
         LoadingIndicatorView.show(self.view, loadingText: "Loading...")
        
        //Task #2
        //successfully retrieve a list of sample users from http://api.lookfwd.co/api/test/users and display them in a table
        
        Alamofire.request("http://api.lookfwd.co/api/test/users").responseJSON { response in
            debugPrint(response)
            
            if let status = response.response?.statusCode {
                switch(status){
                case 201:
                    print("example success")
                default:
                    print("error with response status: \(status)")
                }
            }
            LoadingIndicatorView.hide()
            //to get JSON return value
            if let result = response.result.value {
                let JSON = result as! NSDictionary
             //   print("response:",JSON)
               let Arr = JSON["users"] as! NSArray
                self.friendsArr.addObjects(from: Arr as! [Any])
               // print ("Arr",self.friendsArr,self.friendsArr.count)
                self.tableView.reloadData()
                
            }
        }
    }
    @IBAction func doneButtonClicked(_ sender: UIButton)
    {
       alertControllermessage()
       
    }
    
    func alertControllermessage(){
        let alertController = UIAlertController(title: "Add Group Name", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            // appDelegate().chooseUser = false
            appDelegate().groupName = firstTextField.text
            self.dismiss(animated: true) {
                
            }
            
            print("firstName \(firstTextField.text))")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Group Name"
        }
      
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    //MARK : UITableview Delegate
    // Mark: Task 1.
    // The app should have two tabs, Friends, and Groups
    // namelabel

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return friendsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath as IndexPath) as! nameCell

    cell.namelabel.text = ((friendsArr.value(forKey: "name") as AnyObject).objectAt(indexPath.row)) as! String
        if appDelegate().chooseUser == true{
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none
        }
        
        return cell;
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if appDelegate().chooseUser == true{
            let string = ((friendsArr.value(forKey: "name") as AnyObject).objectAt(indexPath.row)) as! String
            
            appDelegate().userListArr?.add(string)

        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
     func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
           if appDelegate().chooseUser == true{
            appDelegate().userListArr?.removeObject(at: indexPath.row)
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
}

