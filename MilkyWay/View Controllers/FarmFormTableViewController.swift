//
//  FarmFormTableViewController.swift
//  MilkyWay
//
//  Created by Aluno on 24/05/2018.
//  Copyright © 2018 Zanetti, Rafael. All rights reserved.
//

import UIKit

class FarmFormTableViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var gallonStepper: UIStepper!
    @IBOutlet weak var nowLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var gallonTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //First Time Setup - New Farm
    func setupUI() {
        updateNowLabel(date: timePicker.date)
        gallonTextField.text = "0"
    }
    
    func updateNowLabel(date: Date) {
        nowLabel.text = Farm.produceHourFormatter.string(from: date)
    }
    
    @IBAction func gallonStepperChanged(_ sender: UIStepper) {
        gallonTextField.text = Int(sender.value).description
    }
    
    @IBAction func pickerTimeChanged(_ sender: UIDatePicker) {
        updateNowLabel(date: timePicker.date)
    }
    
    var isPickerHidden = true
    
    override func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(43)
        let largeCellHeight = CGFloat(200)
        
        switch(indexPath) {
        case [0,2]: //Due Date Cell
            return isPickerHidden ? normalCellHeight :
            largeCellHeight
            
        case [1,0]: //Notes Cell
            return largeCellHeight
            
        default: return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
        switch (indexPath) {
        case [0,2]:
            isPickerHidden = !isPickerHidden
            
            nowLabel.textColor =
                isPickerHidden ? .black : tableView.tintColor
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default: break
        }
    }
    
    // MARK: - Table view data source

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
