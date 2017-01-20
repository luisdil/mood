//
//  ViewController.swift
//  Mood
//
//  Created by Luis Dille on 10.01.17.
//  Copyright © 2017 Luis Dille. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //Outlets View Cotroller
    @IBOutlet weak var moodbtn: UIButton!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var LabelOut: UILabel!
    
    
    //Database
    let rootRef = FIRDatabase.database().reference()
    
    //Variables
    var date = [String]()
    // var moods = [moodandtime]()
    
    struct Object {
        var sectionname : String!
        var sectionobjects : [moodandtime]!
    }
    var Objectarray = [Object]()
    
    
    
    //Mood Button Press
    @IBAction func test(_ sender: UIButton) {
        
        let alert = UIAlertController (title: nil, message: nil, preferredStyle: .actionSheet)
        
        let firstAction = UIAlertAction(title: "Good", style: .default) { (alert: UIAlertAction!) -> Void in
            NSLog("You pressed button good")
            let time = getCurrentTime()
            let currentdate = getCurrentDate()
            
            let postgood : [String : String] = ["name" : "good",
                                               "time" : time,
                                               "date": currentdate]
            self.rootRef.child("moods").childByAutoId().setValue(postgood)
        }
        
        let secondAction = UIAlertAction(title: "Neutral", style: .default) { (alert: UIAlertAction!) -> Void in
            NSLog("You pressed button bad")
            let time = getCurrentTime()
            let currentdate = getCurrentDate()
            
            let postneutral : [String : String] = ["name" : "neutral",
                                                   "time" : time,
                                                   "date" : currentdate]
            self.rootRef.child("moods").childByAutoId().setValue(postneutral)
        }
        
        let thirdAction = UIAlertAction(title: "Bad", style: .default) { (alert: UIAlertAction!) -> Void in
            NSLog("You pressed button bad")
            let time = getCurrentTime()
            let currentdate = getCurrentDate()
            
            let postbad : [String : String] = ["name" : "bad",
                                                "time" : time,
                                                "date" : currentdate]
            self.rootRef.child("moods").childByAutoId().setValue(postbad)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(thirdAction)
        
        present(alert, animated: true, completion:nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
            if error != nil {
                let loginalert = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultaction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                loginalert.addAction(defaultaction)
                self.present(loginalert, animated: true, completion: nil)
                print(error!)
                return
            }
            print("Sigend in with UID" + user!.uid)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Listen for new entries in the Firebase database
        rootRef.child("moods").observe(.childAdded, with: { (snapshot) -> Void in
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let mood = moodandtime()
                mood.name = dictionary["name"] as! String?
                mood.time = dictionary["time"] as! String?
                let tempdate = dictionary["date"] as! String?
                
                if self.Objectarray.count == 0{
                    self.Objectarray.append(Object(sectionname: tempdate, sectionobjects: [mood]))
                }
                
            
                
                
                for item in self.date {
                    if tempdate == item {
                        print("Varibale schon vorhanden")
                    } else {
                        self.date.append((dictionary["date"] as! String?)!)
                        print("added variable")
                    }
                }
                
                self.Objectarray.append(contentsOf: mood)
                
                //?!?!?!!? WTF?!
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
                
                print(mood.name ?? "No name found")
                print(mood.time ?? "No time found")
            }
        })
        
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        // print("moods.count: ", moods.count)
        return(Objectarray[sectionname].sectionobjects.count)
    
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        NSLog("Wurde aufgerufen")
        let cell = tableView.dequeueReusableCell(withIdentifier: "info")
        
        
        // let cell = UITableViewCell(style: .default, reuseIdentifier: "cell"
        
        let label1 = cell?.viewWithTag(1) as! UILabel
        label1.text = Objectarray[indexPath.section].sectionobjects[indexPath.row].name
        
        let label2 = cell?.viewWithTag(2) as! UILabel
        label2.text = Objectarray[indexPath.section].sectionobjects[indexPath.row].time
        
        return (cell)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return(date.count)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currntdate = date[section]
        return currntdate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

