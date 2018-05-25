//
//  InstructionsTableViewController.swift
//  MilkyWay
//
//  Created by Zanetti, Rafael on 25/05/18.
//  Copyright © 2018 Zanetti, Rafael. All rights reserved.
//

import UIKit

class RouteInstructionsViewController: UIViewController, UITableViewDataSource{
    var steps: [String]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = steps?.count {
            return count
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stepIdentifier", for: indexPath)
        
        if let step = steps?[indexPath.row] {
            cell.textLabel?.text = step
        }
        
        return cell
    }
}
