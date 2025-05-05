//
//  TableViewController.swift
//  EBikeV1-TestA
//
//  Created by Rick Mc on 9/5/18.
//  Copyright © 2018 Rick Mc. All rights reserved.
//

import UIKit
import CoreData

class TableViewController : UITableViewController {

    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    static var tableText = Array(repeating: "", count: 20)
    static var urlList = Array(repeating: "", count: 20)
 
    var fEntries: [NSManagedObject] = []
    var searchText : String = ""
    let textCellIndentifier = "feedCell"
    let feedProcess = NewsFeedClient.sharedInstance
    
    static var feedListAdded = [String]()
    static var urlListAdded = [String]()
    
  
    @IBOutlet var feedTableView: UITableView!

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        displayList()
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(TableViewController.longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0  
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewController.tableText.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIndentifier, for: indexPath as IndexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = TableViewController.tableText[indexPath.row]
                return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Favorite") { (action, view, bool) in
            debugPrint("Favorite")
            bool(true)
            TableViewController.feedListAdded.append(TableViewController.tableText[indexPath.row])
            TableViewController.urlListAdded.append(TableViewController.urlList[indexPath.row])
            
                self.save(title:TableViewController.tableText[indexPath.row], url:TableViewController.urlList[indexPath.row])
        }

        debugPrint(TableViewController.feedListAdded)
        
        action.backgroundColor = UIColor.blue
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let swipeAction = UISwipeActionsConfiguration(actions: [])
        swipeAction.performsFirstActionWithFullSwipe = false // This is the line which disables full swipe
        return swipeAction
    }
    
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let urlArticle = TableViewController.urlList[indexPath.row]
                if let urlArticle = URL(string: urlArticle), UIApplication.shared.canOpenURL(urlArticle) {
                    UIApplication.shared.openURL(urlArticle)
                }
            }
        }
    }
    
    func save(title: String, url : String) {
        
        let fEntry = CoreDataStack.sharedManager.insertEntry(title: title, url: url)
        
        if fEntry != nil {
            fEntries.append(fEntry!)
            tableView.reloadData()
        }
    }
    
    func displayList()
    {
    
        var textA : String = ""
    
        
        self.startLoading()
        
        feedProcess().getListArticles(searchText) { (data, error) in
            
                    let textList = data!["articles"] as! Array<Any>?
                    var articlesList : String = ""
                    var itemText : String = ""
                    var urlText = Array(repeating: "", count: 20)
                    var titleText = Array(repeating: "", count: 20)
                    var articleCount = textList?.count as! Int
                    if articleCount > 20 { articleCount = 20 }
                     for item in 0 ... articleCount - 1 {
                        let itemText = textList![item] as! [String : Any]
                        titleText[item].append(itemText["title"] as! String)
                        urlText[item].append(itemText["url"] as! String)
                            }
                    TableViewController.urlList = urlText
                    TableViewController.tableText = titleText
                    debugPrint(TableViewController.tableText)
                    debugPrint("TotalAdded :", titleText)
                    DispatchQueue.main.async {
                            self.stopLoading()
                            self.tableView.reloadData()
                    }
                 }
            }
    
    func startLoading(){
        activityIndicator.center = self.view.center;
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = UIColor.gray
        view.addSubview(activityIndicator);
        activityIndicator.startAnimating();
        UIApplication.shared.beginIgnoringInteractionEvents();
        
    }
    
    func stopLoading(){
        
        activityIndicator.stopAnimating();
        UIApplication.shared.endIgnoringInteractionEvents();
        
    }
    
    }




