//
//  Coordinate.swift
//  Sputnik_BuildD
//
//  Created by Mini Panton on 9/5/16.
//  Copyright © 2016 Some Feelers. All rights reserved.
//

import UIKit

open class Coordinate: NSObject {
    
    open var latitude:Double = 0, longitude:Double = 0;
    open var latRad:Double = 0, longRad:Double = 0;
    
    
    public init(latitude: Double = 0.0, longitude:Double = 0.0 ){
        self.latitude = latitude;
        self.longitude = longitude;
    }

    
    open func printLatLon(){
        print("Latitude: \(latitude) Longitude: \(longitude)");
    }
    
}
