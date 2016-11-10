//
//  DataBlock.swift
//  Sputnik_BuildD
//
//  Created by Mini Panton on 9/5/16.
//  Copyright © 2016 Some Feelers. All rights reserved.
//

import UIKit

open class DataBlock: NSObject {
    
    open var shouldPrintInfo: Bool = true;
    open var earth: Earth;
    open var user: User;
    open var spok:Kepler;
    open var GT:GroundTrack;
    //    1) a = Semi-major axis = size
    //    2) e = Eccentricity = shape
    //    3) i = inclination = tilt
    //    4) ω = argument of perigee = twist
    //    5) o = longitude of the ascending node = pin
    //    6) v = mean anomaly = angle now
    override init(){
        //sputnik = Satellite();
        earth = Earth();
        user = User();
        spok = Kepler(a: 6955.2, ecc:0.05201, inc:1.136209, Omega:5.9407883598, w:1.01229, nu:5.3573509708)
        //spok = Kepler(a: 6955.2, ecc:0.55201, inc:1.136209, Omega:5.9407883598, w:1.01229, nu:5.3573509708)
        GT = GroundTrack();
        GT.Track(spok)
    }
    
    open func update(_ time: Double = 1){
        //earth.update();
        //sputnik.update(earth);
        GT.Track(spok)
        if(shouldPrintInfo){
            //print("Sputnik location: \(GT.earthCoordinates.latitude), \(GT.earthCoordinates.longitude)")
            print("Distance Between: \(distanceBetween(GT.earthCoordinates, coordinateTwo: user.coordinate)/1000.0)km");
        }
    }
    
    open func centralAngle(_ coordinateOne: Coordinate, coordinateTwo: Coordinate) -> Double{
        let partA = pow(sin((coordinateTwo.latRad-coordinateOne.latRad)/2),2);
        let partB = cos(coordinateOne.latRad) * cos(coordinateTwo.latRad);
        let partC = pow(sin(((coordinateTwo.longRad-coordinateOne.longRad)/2)),2);
        return 2 * asin(sqrt(partA + partB*partC));
    }
    
    open func distanceBetween(_ coordinateOne: Coordinate, coordinateTwo: Coordinate) -> Double{
        return earth.meanRadius * centralAngle(coordinateOne, coordinateTwo: coordinateTwo);
    }
    
    open func sputnikIsWithin(_ meters: Double) -> Bool{
        return (distanceBetween(GT.earthCoordinates, coordinateTwo: user.coordinate) <= meters);
    }
    
    open func sputnikIs() -> Double{
        return (distanceBetween(GT.earthCoordinates, coordinateTwo: user.coordinate));
    }
    
}
