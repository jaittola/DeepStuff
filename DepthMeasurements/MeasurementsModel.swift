//
//  MeasurementsModel.swift
//  DepthMeasurements
//
//  Created by Jukka Aittola on 09/08/2018.
//  Copyright © 2018 Jukka Aittola. All rights reserved.
//

import Foundation

struct Measurement {
    let latitude: Double
    let longitude: Double
    let depth: Double
    let timestamp: Date
    
    init(latitude lat: Double, longitude long: Double, depth: Double) {
        self.latitude = lat
        self.longitude = long
        self.depth = depth
        self.timestamp = Date()
    }
    
    init?(latitude sLat: String?, longitude sLong: String?, depth sDepth: String?) {
        func toDouble(_ txt: String?) -> Double? {
            if let t = txt {
                return Double(t)
            } else {
                return nil
            }
        }
        
        if let numLatitude = toDouble(sLat),
            let numLongitude = toDouble(sLong),
            let numDepth = toDouble(sDepth) {
            self.init(latitude: numLatitude, longitude: numLongitude, depth: numDepth)
        } else {
            return nil
        }
    }

    func toString() -> String {
        return "\(latitude) \(longitude) \(depth)"
    }
}

class Measurements {
    private var measurements = Array<Measurement>()
    
    var values: [Measurement] {
        return measurements
    }
    
    func add(_ measurement: Measurement) {
        measurements.append(measurement)
        print("Measuremens after append: ",
              measurements.map { (m: Measurement) in m.toString()
            }.joined(separator: "\n")
        )
    }
}
