//
//  MeasurementEditViewController.swift
//  DepthMeasurements
//
//  Created by Jukka Aittola on 15/08/2018.
//  Copyright © 2018 Jukka Aittola. All rights reserved.
//

import UIKit

class MeasurementEditViewController: UIViewController {

    var measurement: Measurement? = nil
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var depth: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let m = measurement {
            latitude.text = String(m.latitude)
            longitude.text = String(m.longitude)
            depth.text = String(m.depth)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func saveClicked(_ sender: UIBarButtonItem) {
        print("Save clicked for \(measurement?.toString() ?? "")")
    }
}
