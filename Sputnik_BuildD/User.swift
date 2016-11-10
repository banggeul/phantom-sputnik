//
//  User.swift
//  Sputnik_BuildD
//
//  Created by Mini Panton on 9/5/16.
//  Copyright © 2016 Some Feelers. All rights reserved.
//

import UIKit

open class User: NSObject {
    open var coordinate: Coordinate;
    
    public override init(){
        coordinate = Coordinate();
        
    }
    
    open func printInfo(){
        print("USER");
        print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)");
    }
    
}
