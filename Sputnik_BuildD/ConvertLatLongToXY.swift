//
//  ConvertLatLongToXY.swift
//  LandscapeController_Swift
//
//  Created by Mini Panton on 9/4/16.
//  Copyright © 2016 Olga Dalton. All rights reserved.
//

import Foundation

class ConvertLatLongToXY: NSObject {
//    
//    let dot_size:Double = 10
//    let longitude_shift:Double = 0 //number of pixels your map's prime meridian is off-center.
//    let x_pos:Double = -139 //54
//    let y_pos:Double = 0 //19
//    var map_width:Double = 364
//    var map_height:Double = 360
   
    
    func PlotPoint(_ lat:Double, long:Double, dot_size:Double, longitude_shift:Double, x_pos:Double, y_pos:Double, map_width:Double, map_height:Double) -> (x:Double, y:Double){
        
        let latitude = lat
        let longitude = long
        let half_dot = floor(dot_size/2.0)
//        var x = (map_width * (180 + longitude) / 360.0) % map_width + longitude_shift
        let x = (longitude+180)*(map_width/360)
        // latitude: using the Mercator projection
        let latRad = latitude * M_PI / 180.0;  // convert from degrees to radians
//        var y = log(tan((latitude/2.0) + (M_PI/4.0)));  // do the Mercator projection (w/ equator of 2pi units)
//        y = (map_height / 2.0) - (map_width * y / (2 * M_PI)) + y_pos;   // fit it to our map
        
        let mercN = log(tan((M_PI/4.0)+(latRad/2.0)));
        let y = (map_height/2.0) - (map_width*mercN/(2*M_PI))
        
        //x -= x_pos
        //y -= y_pos
        
        return (x:x-half_dot, y:y-half_dot)
        //return (x:x, y:y)
    }
}
