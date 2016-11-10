//
//  Earth.swift
//  Sputnik_BuildD
//
//  Created by Mini Panton on 9/5/16.
//  Copyright © 2016 Some Feelers. All rights reserved.
//
import Foundation

open class Earth: NSObject {
    
    let mass:Double = 5.97219e24; //kilograms (kg)
    let meanRadius:Double = 6371000; //meters (m)
    
    open func printInfo(){
        print("*-*");
        print("-Earth-");
        print("Mass: \(mass)");
        print("Mean Radius: \(meanRadius)");
        print("*-*");
    }
}

