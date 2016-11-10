//
//  Kepler.swift
//  Sputnik_BuildD
//
//  Created by Mini Panton on 9/5/16.
//  Copyright © 2016 Some Feelers. All rights reserved.
//
import Foundation

open class Kepler:NSObject {
    
    //this class describes the Keplererian classic orbital elements
    //    1) a = Semi-major axis = size
    //    2) e = Eccentricity = shape
    //    3) i = inclination = tilt
    //    4) ω = argument of perigee = twist
    //    5) o = longitude of the ascending node = pin
    //    6) v = mean anomaly = angle now
    
    open var a:Double=0,e:Double=0,i:Double=0,o:Double=0,w:Double=0,v:Double=0;
    
    public init(a:Double, ecc:Double, inc:Double, Omega:Double, w:Double, nu:Double)
    {
        self.a = a;
        self.e = ecc;
        self.i = inc;
        self.o = Omega;
        self.w = w;
        self.v = nu;
    }
}

