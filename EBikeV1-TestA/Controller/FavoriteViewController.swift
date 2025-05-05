//
//  FavoriteViewController.swift
//  EBikeV1-TestA
//
//  Created by Rick Mc on 9/15/18.
//  Copyright © 2018 Rick Mc. All rights reserved.
//

import UIKit
import CoreData

class FavViewController : UITableViewController {
    
    var tableText = Array(repeating: "", count: 20)
    var currentRow : Int = 0
    let textCellIndentifier = "favCell"
    
    var fEntries: [NSManagedObject] = []
    
    @IBOutlet var favTableView: UITableView!
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(FavViewController.longPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var listArticles = TableViewController.feedListAdded
        debugPrint(listArticles)
        return listArticles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var listArticles = TableViewController.feedListAdded
        
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIndentifier, for: indexPath as IndexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = listArticles[indexPath.row]
        return cell
    }
    
    @objc func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let urlArticle = TableViewController.urlListAdded[indexPath.row]
                if let urlArticle = URL(string: urlArticle), UIApplication.shared.canOpenURL(urlArticle) {
                    UIApplication.shared.openURL(urlArticle)
                }
            }
        }
    }
}


