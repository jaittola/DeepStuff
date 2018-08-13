//
//  MeasurementTableRowTableViewCell.swift
//  DepthMeasurements
//
//  Created by Jukka Aittola on 13/08/2018.
//  Copyright © 2018 Jukka Aittola. All rights reserved.
//

import UIKit

class MeasurementTableRowTableViewCell: UITableViewCell {
    @IBOutlet weak var depthLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
