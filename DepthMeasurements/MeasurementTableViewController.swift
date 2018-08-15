//
//  MeasurementTableViewController.swift
//  DepthMeasurements
//
//  Created by Jukka Aittola on 13/08/2018.
//  Copyright © 2018 Jukka Aittola. All rights reserved.
//

import UIKit

class MeasurementTableViewController: UITableViewController, MeasurementsDelegate {
    var model: Measurements? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("App delegate not available")
        }
        model = appDelegate.depths
        model?.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func onUpdated(index: Int) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.values.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MeasurementTableViewCell", for: indexPath) as? MeasurementTableRowTableViewCell else {
            fatalError("The dequeued cell is not an instance of MeasurementTableRowTableViewCell")
        }
        if let measurement = model?.values[indexPath.row] {
            cell.depthLabel.text = "\(measurement.depth) m"
            cell.latitudeLabel.text = "\(measurement.latitude)°"
            cell.longitudeLabel.text = "\(measurement.longitude)°"
        }
        return cell
    }

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch (segue.identifier ?? "") {
        case "ShowDetail":
            guard let dest = segue.destination as? MeasurementEditViewController else {
                fatalError("Unexpected destionation for measurement editing")
            }
            guard let senderCell = sender as? UITableViewCell else {
                fatalError("Bad sender, expected table view cell")
            }
            if let row = tableView.indexPath(for: senderCell)?.row,
                let measurement = model?.values[row] {
                dest.measurement = measurement
            }
        default:
            print("Unknown segue identifier \(segue.identifier ?? "") in measurement detail navigation")
        }
    }

}
