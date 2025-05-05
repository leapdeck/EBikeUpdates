//
//  EMotoTableView.swift
//  EBikeV1-TestA
//
//  Created by Rick Mc on 9/13/18.
//  Copyright © 2018 Rick Mc. All rights reserved.
//

import UIKit
import CoreData

class EMotoViewController : UITableViewController {
    
    var tableText = Array(repeating: "", count: 20)
    
    let evMotoTypes = ["Alta Motorcycles", "Enegerica Motorcycles", "Zero Motorcycles", "Volta Motorcycles", "Yamaha Motorcycles", "Curtiss Motorcycles", "Honda Motorcycles" ]
    
    let evMotoPicList = ["Bike1","Bike2","Bike3","Bike4","Bike5","Bike6","Bike7"]
    let evMotoList = ["alta, electric", "+energica, +ego", "zero, electric, motorcycle","+volta +electric","+yamaha,+electric,+motorcycle","+curtiss +electric", "honda,+electric,+motorcycle"]
    
    static var titlesLoaded : [String] = []
    static var urlsLoaded : [String] = []
    static var connectionOn : Bool = true
    
    var currentRow : Int = 0
    let textCellIndentifier = "itemCell"
    
    static var fEntries: [NSManagedObject] = []

    @IBOutlet var EMotoTableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("view did load")
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchEntries), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fetchEntries), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        debugPrint("Entries 2 :", EMotoViewController.fEntries)
        loadEntries()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evMotoTypes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIndentifier, for: indexPath as IndexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = evMotoTypes[indexPath.row]
        cell.imageView?.image = UIImage(named :evMotoPicList[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentRow = indexPath.row
  
        // Catching the connection error and display an alert view.
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        }else{
            let alertController = UIAlertController(title: "Check Network Connection", message:
                "Can't connect. Please check your Internet connection.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Return", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        debugPrint("Text when selected.")
        debugPrint(currentRow)
        debugPrint(EMotoViewController.fEntries)
        performSegue(withIdentifier: "tabBar", sender: self)

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = CGFloat()
        height = 135
        return height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let tabVc = segue.destination as! UITabBarController
        let navVc = tabVc.viewControllers!.first as! UINavigationController
        let tabviewVc = navVc.viewControllers.first as! TableViewController
        tabviewVc.searchText = evMotoList[currentRow]

    }
    
    @objc func fetchEntries(){
        
        if CoreDataStack.sharedManager.fetchAllEntries() != nil{
            
            EMotoViewController.fEntries = CoreDataStack.sharedManager.fetchAllEntries()!
        }
        debugPrint("Entries 2 :", EMotoViewController.fEntries)
        }
    
    func loadEntries(){
        let entrycount = EMotoViewController.fEntries.count
        if entrycount != 0 {
            EMotoViewController.titlesLoaded = []
            EMotoViewController.urlsLoaded = []
            for count in 0 ... entrycount-1 {
                
                    EMotoViewController.urlsLoaded.append(EMotoViewController.fEntries[count].value(forKeyPath: "url") as! String)
                    EMotoViewController.titlesLoaded.append(EMotoViewController.fEntries[count].value(forKeyPath: "title") as! String)
            }
            TableViewController.feedListAdded = EMotoViewController.titlesLoaded
            TableViewController.urlListAdded = EMotoViewController.urlsLoaded
        }
        
    }
}

