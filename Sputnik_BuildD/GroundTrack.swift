//
//  GroundTrack.swift
//  buildB
//
//  Created by Mini Panton on 8/19/16.
//  Copyright © 2016 SPUTNIK. All rights reserved.
//

import Foundation
import CoreLocation

open class GroundTrack:NSObject {
    
    //Orbit groundtrack plot Latitude longitude lat long
    //based on Richard Rieber
//    Copyright (c) 2009, Richard Rieber
//    All rights reserved.
//    
//    Redistribution and use in source and binary forms, with or without
//    modification, are permitted provided that the following conditions are
//    met:
//    
//    * Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in
//    the documentation and/or other materials provided with the distribution
//    
//    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//    AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//    ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
//    LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//    CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//    SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//    INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//    ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//    POSSIBILITY OF SUCH DAMAGE.
    //https://www.mathworks.com/matlabcentral/fileexchange/13439-orbital-mechanics-library/content/Groundtrack.m
    //    Purpose: This class plots the groundtrack of a given orbit.
    //    %
    //    % Inputs:  o Kepler - A vector of length 6 containing all of the keplerian
    //    %                    orbital elements [a,ecc,inc,Omega,w,nu] in km and radians
    //    %          o GMSTo  - The Greenwich Mean Siderial Time at the given initial position
    //    %                     in radians.
    //    %          o Tf     - The length of time to plot the groundtrack in seconds
    //    %          o fig    - The figure number on which to plot the groundtrack [OPTIONAL]
    //    %          o dT     - Timesteps for groundtrack, defaults to 60 seconds [OPTIONAL]
    //    %          o s      - String for customizing the plot (example: '--b*').
    //    %                     See, help plot, for more information [OPTIONAL]
    //    %          o mu     - Gravitational constant of Earth. Defaults to
    //    %                     3998600.4415 km^3/s^2 [OPTIONAL]
    
    //Sputnik's Keplerian Orbital Elements based on Sven Grahn's Sputnik 1 and Sputnik 2 TLE (Two Line Element set)
    //http://www.satobs.org/seesat/Aug-1997/0475.html
    
    open var orbit:Kepler?;
    open var flipFlag:Bool = false;
    open var prevSatLoc:Array<Double> = [0.46652651,1.9059610];//0.46652651, 1.9059610
    //public var prevSatLoc:Array<Double> = [-9999.0,-9999.0];
    open var gmsto:Double = 0.0, tf:Double = 0.0;
    open var dT:Double = 0.0, s:String = "", mu:Double = 0.0;
    open var a:Double=0.0, ecc:Double=0.0, inc:Double=0.0, O:Double=0.0, w:Double=0.0, nuo:Double=0.0;
    open var earthCoordinates = Coordinate();
    open var Lats = Array<Any>()
    open var Longs = Array<Any>()
    
    open func Track(_ k:Kepler, gmsto:Double=0, tf:Double=0){
        
        self.orbit = k;
        self.gmsto = 5.3294239574885 //GMST calculated from the launch site not sure how accurate this is...
        //self.gmsto = M_PI*2/24/60
        self.tf = 1;
        self.dT  = 1;
        self.s   = "b";
        self.mu  = 398600.4415;     //km^3/s^2  Gravitational constant of Earth
        
        self.a   = (orbit?.a)!;//6955.2
        self.ecc = (orbit?.e)!;
        self.inc = (orbit?.i)!;
        self.O   = (orbit?.o)!;
        self.w   = (orbit?.w)!;
        self.nuo = (orbit?.v)!;
        
        
        let now = Date();
        var since70 = now.timeIntervalSinceReferenceDate
        since70 = floor(since70)
        //time = [0:dT:Tf]; %time vector - this creates an array from 0 to Tf seconds in dT increment
        //for example [0:60:96*60] = [0, 60, 120, 180, ... 96*60
        //first make an empty array with default values
        var time = Array(repeating: 0.0,count: Int(self.tf)/Int(self.dT))
        
        //now loop through and put in the right value
        for(index,var t) in time.enumerated() {
            
            t = Double(index+Int(since70)) * self.dT; //iterator decides which second we want to calculate ..it should increment every second
            time[index] = t;
        }
        
        //now make the bp array
        var bp = [Int]()
        bp.append(0);
        bp.append(time.count)
        var k = 2;
        var Lat_rad = Array(repeating: 0.0, count: time.count)
        var Long_rad = Array(repeating: 0.0, count: time.count)
        
        
        
        //dump all arrays to test
        //print("Lat_rad dump")
        //dump(Lat_rad)
        
        /* original MATLAB Code
         
         for j = 1:length(time)
         GMST = zeroTo360(GMSTo + w_earth*time(j),1);  %GMST in radians
         
         M  = zeroTo360(MA + n*time(j),1);  %Mean anomaly in rad
         nu = nuFromM(M,ecc,10^-12);        %True anomaly in rad
         
         [ECI,Veci] = randv(a,ecc,inc,O,w,nu);
         clear veci
         ECEF = eci2ecef(ECI,GMST);
         
         [Lat_rad(j),Long_rad(j)] = RVtoLatLong(ECEF);
         
         if j > 1 && ((Long_rad(j)-Long_rad(j-1)) < -pi || (Long_rad(j)-Long_rad(j-1)) > pi)
         //if this is not the first point and the difference between the current Longitude and the previous Longitude is
         //less than -180 degree or more than 180
         bp(k) = j-1;
         k     = k+1;
         end
         end*/
        //print(20.3569*2*M_PI/24.0)
        //self.n = (mu/a^3)^.5;  //Mean motion of satellite
        let n = pow((self.mu/(pow(self.a, 3))), 0.5)
        //print(n)
        //let's compute the semi major axis just for fun
        //let aa = pow((pow(96.2,2)*self.mu*83.6/4*pow(M_PI,2)), 1.0/3.0)
        //print(aa);
        //E  = atan2(sin(nuo)*(1-ecc^2)^.5,ecc+cos(nuo));  %Eccentric anomaly
        let E = atan2(sin(self.nuo)*pow((1-pow(self.ecc,2)),0.5),self.ecc+cos(self.nuo))
        //MA = E-ecc*sin(E); %Initial Mean anomaly
        let MA = E-self.ecc*sin(E);
        //let MA = 5.357340499
        //print(MA)
        let r2d = 180.0/M_PI;  //Radians to degrees conversion
        let w_earth  = 7.2921158553e-5; //rad/s  %Rotation rate of Earth
        
        //now loop through each time
        for (index, var t) in time.enumerated(){
            
            let GMST = zeroTo360(self.gmsto+w_earth*t,unit: 1);//GMST in radians
            //print("w_Earth*t", w_earth*t)
            
            let M = zeroTo360(MA + n*t, unit: 1);//Mean anomaly in rad
            let nu = nuFromM(M, ecc: ecc, tol: pow(10,-8));//true anomaly in rad
            
            let ECI = randv(a,ecc: ecc,inc: inc,Omega:O,w:w,nu: nu);
            let ECEF = eci2ecef(ECI, GST: GMST);
            //print(ECEF.valueAtRow(0, column: 0),",",ECEF.valueAtRow(1, column: 0),",", ECEF.valueAtRow(2, column: 0))
            
            var Lat_Long = RVtoLatLong(ECEF);
            Lat_rad[index] = Lat_Long[0]
            Long_rad[index] = Lat_Long[1]
            
            earthCoordinates.latitude = Lat_rad[index]*r2d
            earthCoordinates.longitude = Long_rad[index]*r2d
            earthCoordinates.latRad = Lat_rad[index]
            earthCoordinates.longRad = Long_rad[index]
            
        }
        
        //return coords!;
        
    }
    
    open func calcGTrackPath() {
        
        let now = Date();
        var since70 = now.timeIntervalSinceReferenceDate
        since70 = floor(since70)
        let dT = 60
        let Tf = 400*60
       
        var time = Array(repeating: 0.0,count: Int(Tf)/Int(dT))
        
        //now loop through and put in the right value
        for(index,var t) in time.enumerated() {
            t = Double(index+Int(since70)) * self.dT; //iterator decides which second we want to calculate ..it should increment every second
            time[index] = t;
            since70 += 30;
        }
        //dump(time)
        
        //bp(1)    = 0;
        //        bp(2)    = length(time);
        //        k        = 2;
        //        Lat_rad  = zeros(1,length(time));
        //        Long_rad = zeros(1,length(time));
        //now make the bp array
        var bp = [Int]()
        bp.append(0);
        bp.append(time.count)
        
        var k = 2;
        Lats = Array(repeating: 0.0, count: time.count)
        Longs = Array(repeating: 0.0, count: time.count)
    
        //dump all arrays to test
        //print("Lat_rad dump")
        //dump(Lat_rad)
        
        let n = pow((self.mu/(pow(self.a, 3))), 0.5)
        let E = atan2(sin(self.nuo)*pow((1-pow(self.ecc,2)),0.5),self.ecc+cos(self.nuo))
        let MA = E-self.ecc*sin(E);
        let r2d = 180.0/M_PI;  //Radians to degrees conversion
        let w_earth  = 7.2921158553e-5; //rad/s  %Rotation rate of Earth
        
        //now loop through each time
        for (index, var t) in time.enumerated(){
            
            let GMST = zeroTo360(self.gmsto+w_earth*t,unit: 1);//GMST in radians
            //print("w_Earth*t", w_earth*t)
            
            let M = zeroTo360(MA + n*t, unit: 1);//Mean anomaly in rad
            let nu = nuFromM(M, ecc: ecc, tol: pow(10,-8));//true anomaly in rad
            
            let ECI = randv(a,ecc: ecc,inc: inc,Omega:O,w:w,nu: nu);
            let ECEF = eci2ecef(ECI, GST: GMST);
            //print(ECEF.valueAtRow(0, column: 0),",",ECEF.valueAtRow(1, column: 0),",", ECEF.valueAtRow(2, column: 0))
            
            var Lat_Long = RVtoLatLong(ECEF);
            Lats[index] = Lat_Long[0]*r2d
            Longs[index] = Lat_Long[1]*r2d
        
        }
        
        //return coords!;

        
    }
    
    
    func R1(_ x:Double)->Matrix{
        //        % This function creates a rotation matrix about the 1-axis (or the X-axis)
        //            %
        //            % A = [1      0       0;
        //            %      0      cos(x)  sin(x);
        //            %      0      -sin(x) cos(x)];
        //        %
        //            % Inputs:  x - rotation angle in radians
        //        % Outputs: A - the rotation matrix about the X-axis
        let r = Matrix(ofRows: 3, columns: 3, value: 0);
        r?.setValue(1, row: 0, column: 0);
        r?.setValue(cos(x), row: 1, column: 1)
        r?.setValue(sin(x), row: 1, column: 2)
        r?.setValue(-sin(x), row: 2, column: 1)
        r?.setValue(cos(x), row: 2, column: 2)
        
        return r!
    }
    
    func R3(_ x:Double)->Matrix{
        //        % This function creates a rotation matrix about the 1-axis (or the X-axis)
        //        A = [cos(x)  sin(x)     0;
        //            -sin(x) cos(x)     0;
        //            0       0          1];
        //        %
        //            % Inputs:  x - rotation angle in radians
        //        % Outputs: A - the rotation matrix about the X-axis
        let r = Matrix(ofRows: 3, columns: 3, value: 0);
        r?.setValue(cos(x), row: 0, column: 0);
        r?.setValue(sin(x), row: 0, column: 1)
        r?.setValue(-sin(x), row: 1, column: 0)
        r?.setValue(cos(x), row: 1, column: 1)
        r?.setValue(1, row: 2, column: 2)
        
        return r!
    }
    
    func randv(_ a:Double, ecc:Double, inc:Double, Omega:Double, w:Double, nu:Double)->Matrix
        
    {
        //        % function [R,V] = randv(a,ecc,inc,Omega,w,nu,U)
        //            %
        //            % Updates:  9/27/09 - Preallocated memory before the for-loop.
        //                %                     No longer save R_pqw and V_pqw in the for-loop.
        //                    %
        //                    % Purpose:  This function converts Kepler orbital elements (p,e,i,O,w,nu)
        //        %           to ECI cartesian coordinates in km
        //        %           This function is derived from algorithm 10 on pg. 125 of
        //        %           David A. Vallado's Fundamentals of Astrodynamics and
        //        %           Applications (2nd Edition)
        //        %
        //        % WARNING:  o If the orbit is near equatorial and near circular, set w = 0 and Omega = 0
        //        %             and nu to the true longitude.
        //        %           o If the orbit is inclined and near circular, set w = 0 and nu to the argument
        //        %             of latitude.
        //        %           o If the orbit is near equatorial and elliptical, set Omega = 0 and w to the true
        //        %             longitude of periapse.
        //        %
        //        % Inputs:  a:     Semi-major axis in km of length n
        //        %          ecc:   Eccentricity of length n
        //        %          inc:   Inclination of orbit in radians of length n
        //        %          Omega: Right ascension of ascending node in radians of length n
        //        %          w:     Argument of perigee in radians of length n
        //        %          nu:    True anomaly in radians of length n
        //        %          U:     Gravitational constant of body being orbited (km^3/s^2).  Default is Earth
        //        %                 at 398600.4415 km^3/s^2.  OPTIONAL
        //        %
        //        % Outputs: R:  3 x n array of the radius in km
        //        %          V:  3 x n array of the velocity in km/s
        
        //original code//
        /*for j = 1:length(a)
         p = a(j)*(1-ecc(j)^2);
         
         % CREATING THE R VECTOR IN THE pqw COORDINATE FRAME
         R_pqw(1,1) = p*cos(nu(j))/(1 + ecc(j)*cos(nu(j)));
         R_pqw(2,1) = p*sin(nu(j))/(1 + ecc(j)*cos(nu(j)));
         R_pqw(3,1) = 0;
         
         % CREATING THE V VECTOR IN THE pqw COORDINATE FRAME
         V_pqw(1,1) = -(U/p)^.5*sin(nu(j));
         V_pqw(2,1) =  (U/p)^.5*(ecc(j) + cos(nu(j)));
         V_pqw(3,1) =   0;
         
         % ROTATING THE pqw VECOTRS INTO THE ECI FRAME (ijk)
         R(:,j) = R3(-Omega(j))*R1(-inc(j))*R3(-w(j))*R_pqw;
         V(:,j) = R3(-Omega(j))*R1(-inc(j))*R3(-w(j))*V_pqw;
         end*/
        
        let U = 398600.4415; //%Gravitational Constant for Earth (km^3/s^2)
        var R = Array(repeating: 0.0, count: 3)
        var V = Array(repeating: 0.0, count: 3)
        
        let p = a*(1-pow(ecc,2))
        let rp00 = p*cos(nu)/(1 + ecc*cos(nu));
        let rp10 = p*sin(nu)/(1 + ecc*cos(nu));
        
        let vp00 = -sqrt(U/p)*sin(nu);
        let vp10 =  sqrt(U/p)*(ecc + cos(nu));
        
        let R_pqw = Matrix(ofRows: 3, columns: 2, value: 0)
        let V_pqw = Matrix(ofRows: 3, columns: 2, value: 0)
        
        R_pqw?.setValue(rp00, row: 0, column: 0)
        R_pqw?.setValue(rp10, row: 1, column: 0)
        
        V_pqw?.setValue(vp00, row: 0, column: 0)
        V_pqw?.setValue(vp10, row: 1, column: 0)
        
        //        % ROTATING THE pqw VECOTRS INTO THE ECI FRAME (ijk)
        //        R(:,j) = R3(-Omega(j))*R1(-inc(j))*R3(-w(j))*R_pqw;
        //        V(:,j) = R3(-Omega(j))*R1(-inc(j))*R3(-w(j))*V_pqw;
        //
        let rr1:Matrix = R3(-Omega).multiplying(withRight: R1(-inc))
        let rr2:Matrix = rr1.multiplying(withRight: R3(-w))
        var rr3:Matrix = rr2.multiplying(withRight: R_pqw)
        //
        //        let v1:Matrix = R3(-Omega).matrixByMultiplyingWithRight(R1(-inc))
        //        var v2:Matrix = r1.matrixByMultiplyingWithRight(R3(-w))
        //        var v3:Matrix = r2.matrixByMultiplyingWithRight(V_pqw)
        
        //try from the right?
        
        let r1:Matrix = R3(-w).multiplying(withRight: R_pqw)
        let r2:Matrix = R1(-inc).multiplying(withRight: r1)
        let r3:Matrix = R3(-Omega).multiplying(withRight: r2)
        
        let v1:Matrix = R3(-w).multiplying(withRight: V_pqw)
        let v2:Matrix = R1(-inc).multiplying(withRight: v1)
        var v3:Matrix = R3(-Omega).multiplying(withRight: v2)
        
        
        return r3.column(0); //do I need to just make the first column into an array before returning it? Yes
        
    }
    
    func nuFromM(_ M:Double, ecc:Double, tol:Double)->Double{
        //        % function nu = nuFromM(M,ecc,tol)
        //            %
        //            % Purpose:  This function calculates the true anomaly (nu) of a position in an orbit given
        //        %           the mean anomaly of the position (M) and the eccentricity (ecc) of the orbit.
        //        %           This uses another function, calcEA.
        //        %
        //        % Inputs:  M   - mean anomaly of position in radians
        //        %          ecc - eccentricity of orbit
        //        %          tol - A tolerance for calculating the eccentric anomaly (see help calcEA.m)
        //        %                Default is 10^-8 radians [OPTIONAL]
        //        %
        //        % Output:  nu  - true anomaly of position in radians
        //
        //        function nu = nuFromM(M,ecc,tol)
        //
        //        E = CalcEA(M,ecc,tol);  %Determining eccentric anomaly from mean anomaly
        //        if (M > -pi && M < 0) || M > pi
        //        E = M - ecc;
        //        else
        //        E = M + ecc;
        //        end
        
        let E = CalcEA(M,ecc: ecc,tol: tol);
        //print(E);
        let nu = atan2((sin(E)*sqrt(1-pow(ecc,2))),(cos(E)-ecc))
        return nu;
        //
        //        % Since tan(x) = sin(x)/cos(x), we can use atan2 to ensure that the angle for nu
        //        % is in the correct quadrant since we know both sin(nu) and cos(nu).  [see help atan2]
        //        nu = atan2((sin(E)*(1-ecc^2)^.5),(cos(E)-ecc));
        
    }
    
    func CalcEA(_ M:Double, ecc:Double, tol:Double) ->Double
    {
        /*% Orbit eccentric anomaly, Kepler's equation keplers equation
         % Richard Rieber
         % 1/23/2005
         % rrieber@gmail.com
         %
         % Revision 8/21/07: Fixed typo in line 38 if statement
         %                   Added H1 line for lookfor functionality
         %
         % function E = CalcEA(M,ecc,tol)
         %
         % Purpose: Solves for eccentric anomaly, E, from a given mean anomaly, M,
         %          and eccentricty, ecc.  Performs a simple Newton-Raphson iteration
         %
         % Inputs: o M   - Mean anomaly in radians.
         %         o ecc - Eccentricity of the orbit.
         %         o tol - a tolerance at which to terminate iterations; Default
         %                 is 10^-8 radians. [OPTIONAL]
         %
         % Outputs: o E  - The eccentric anomaly in radians.
         %
         % E = CalcEA(M,ecc) uses default tolerances
         %
         % E = CalcEA(M,ecc,tol) will use a user specified tolerance, tol
         %*/
        var E:Double;
        
        if(M>M_PI && M<0)
        {
            E = M - ecc
        }else{
            E = M + ecc
        }
        
        if(M > M_PI){
            E = M - ecc
        }else{
            E = M + ecc
        }
        
        
        var Etemp  = E + (M - E + ecc*sin(E))/(1-ecc*cos(E));
        var Etemp2 = E;
        
        while (abs(Etemp - Etemp2) > tol)
        {
            Etemp = Etemp2;
            Etemp2 = Etemp + (M - Etemp + ecc*sin(Etemp))/(1-ecc*cos(Etemp));
        }
        
        E = Etemp2;
        return E;
        
    }
    
    func eci2ecef(_ ECI:Matrix, GST:Double)->Matrix
    {
        //This function rotates Earth Centered Inertial (ECI) coordinates to Earth
        //Centered Earth Fixed (ECEF) coordinates via the Greenwich Sideral Time
        //hour angle (GST).
        /*% Inputs:  ECI     - A 3 x n matrix of position vectors in km
         %          GST     - A vector of length n providing the Greenwich hour angle for each of
         %                    the above ECI position vectors in radians
         %          V_ECI   - A 3 x n matrix of the velocity vectors in km/s [OPTIONAL]
         %
         % Outputs:  ECEF   - A 3 x n matrix of position vectors in the ECEF coordinate system in km
         %           V_ECEF - A 3 x n matrix of velocity vectors in the ECEF coordinate system in km/s
         %
         % NOTE:  This function requires the use of the subfunction 'R3.m' which creates a
         %        rotation matrix about the 3-axis (Z-axis).*/
        
        //GST doesnt need to be a vector it just needs to match the n size of the ECI matrix
        //so make the ECI matrix into a vector then no problem
        var ECEF = Matrix(ofRows: 1, columns: 3, value: 0);
        //Rotating the ECI vector into the ECEF frame via the GST angle about the Z-axis
        
        ECEF = R3(GST).multiplying(withRight: ECI)
        //ECEF = R3(GST).matrixByElementWiseMultiplyWith(ECI)
        //        print("dump ECI")
        //        dump(ECI)
        //        print("dump ECEF")
        //        dump(ECEF)
        return ECEF!;
    }
    
    
    func rad2lat(_ rd:Double) -> Double {
        //latitude is the horizontal lines go from 0(equator) to 90 (north pole) or -90(south pole)
        // first of all get everthing into the range -2pi to 2pi
        var rad = rd.truncatingRemainder(dividingBy: (M_PI*2));
        
        // convert negatives to equivalent positive angle
        if (rad < 0)
        { rad = 2*M_PI + rad;}
        
        // restict to 0 - 180
        var rad180 = rad.truncatingRemainder(dividingBy: (M_PI));
        
        // anything above 90 is subtracted from 180
        if (rad180 > M_PI/2)
        { rad180 = M_PI - rad180;}
        // if it is greater than 180 then make negative
        if (rad > M_PI)
        { rad = -rad180;}
        else
        { rad = rad180;}
        
        return (rad/M_PI*180);
    }
    
    // convert radians into longitude
    // 180 to -180
    func rad2long(_ rd:Double) -> Double {
        //longitude is the vertical lines go from 0(Greenwich) to 180 (east) or -180(west)
        // first of all get everthing into the range -2pi to 2pi
        var rad = rd.truncatingRemainder(dividingBy: (M_PI*2));
        
        if (rad < 0)
        {   rad = 2*M_PI + rad; }
        
        // convert negatives to equivalent positive angle
        var rad360 = rad.truncatingRemainder(dividingBy: (M_PI*2));
        
        // anything above 180 is subtracted from 360
        if (rad360 > M_PI)
        {   rad360 = M_PI*2 - rad360;  }
        
        // if it is greater than 180 then make negative
        if (rad > M_PI)
        {   rad = -rad360;}
        else
        { rad = rad360;}
        
        return (rad/M_PI*180);
    }
    
    
    func GetGMST(){
        // Get the NSDate components
        var currentCalendar = Calendar.current
        currentCalendar.timeZone = TimeZone(abbreviation: "UTC")!
        let strDate = "1957-10-04T19:28:34Z" // "2015-10-06T15:42:34Z"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let eciDate = dateFormatter.date( from: strDate )
        
        //NSDateComponents *components = [currentCalendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:self.eciDate];
        let components = (currentCalendar as NSCalendar).components(NSCalendar.Unit.day, from: eciDate!)
        (components as NSDateComponents).timeZone = TimeZone(abbreviation: "UTC")
        let h = components.hour
        let m = components.minute
        let s = components.second
        
        print("eciDate h", h);
        print("eciDate m", m);
        
        // Get UTC in terms of decimal hours
        let ss = Double(s!)/3600.0
        let mm = Double(m!)/60.0
        let utc = Double(h!) + mm + ss; // UTC is expressed in hours as a decimal number
        
        print("UTC:",utc,h,mm,ss);
        
    }
    
    
    func zeroTo360(_ x:Double,unit:Int)->Double
    {
        //        % function y = zeroTo360(x,unit)
        //            %
        //            % Purpose: This function reduces an angle to the range of 0 - 360 degrees
        //        %          or 0 - 2*pi radians.
        //        %
        //        % Inputs:   x    - Angle to be reduced, may be an array of angles
        //        %           unit - Boolean, 1 for radians, 0 for degrees, defaults to
        //            %                  degrees [OPTIONAL]
        //            %
        //            % Output:   y    - Reduced angle
        //        %
        //
        //        function y = zeroTo360(x,unit)
        //
        //        if nargin == 1
        //        unit = 0;
        //        elseif nargin > 2
        //        error('Too many inputs')
        //        end
        //
        //        if unit
        //        deg = 2*pi;
        //        else
        //        deg = 360;
        //        end
        //
        //        y = zeros(1,length(x));
        //
        //        for j = 1:length(x)
        //        if (x(j) >= deg)
        //        x(j) = x(j) - fix(x(j)/deg)*deg;
        //        elseif (x(j) < 0)
        //        x(j) = x(j) - (fix(x(j)/deg) - 1)*deg;
        //        end
        //        y(j) = x(j);
        //        end
        var deg:Double;
        var y:Double;
        var x = x;
        
        //check if the call wants the degree or rad
        if(unit>0){
            deg = M_PI*2
        }else{
            deg = 360
        }
        
        if(x >= deg)
        {
            x = x - floor(x/deg)*deg;
        }else if(x < 0){
            x = x - (floor(x/deg)-1)*deg
        }
        
        y = x;
        
        return y;
        
        
    }
    
    func RVtoLatLong(_ ECEF:Matrix)->Array<Double>{
        /*% Purpose:  This fuction convertes ECEF coordinates to Geocentric latitude
         %           and longitude given ECEF radius in km. Valid for any planetary
         %           body.
         %
         % Inputs:  o ECI  - A 3x1 vector of Earth-Centered Inertial (IJK)
         %                   coordinates in km.
         %
         % Outputs: o Lat  - Geocentic latitude of spacecraft in radians
         %          o Long - Longitude of spacecraft in radians*/
        
        //var LatLong;
        /*r_delta = norm(ECEF(1:2));//pick the first and second element of the ECEF vector and get the euclidean length of the vector or magnitude
         sinA = ECEF(2)/r_delta; //pick the second element(y) of the ECEF and divide it by the norm vector
         cosA = ECEF(1)/r_delta; //pick the first element(x) of the ECEF and divide it by the norm vector
         
         Long = atan2(sinA,cosA);
         
         if Long < -pi
         Long = Long + 2*pi;
         end
         
         Lat = asin(ECEF(3)/norm(ECEF));*/
        //so I can use the function in Matrix+Advanced to calculate the euclidean distance between ECEF(1:2) and [0,0]
        //or do it manually like pythagorean theorem and compare the result
        //first extract the first two rows of the matrix from ECEF
        //let ECEF_2D = ECEF.rows(NSMutableIndexSet(integersIn: 0...1))
        //        dump(ECEF_2D);
        let mRange = NSMakeRange(0, 2)
        let ECEF_2D = ECEF.rowsM(NSMutableIndexSet(indexesIn:mRange) as IndexSet)
        //now make an empty 2D matrix
        let Empty2D = Matrix(ofRows: 2, columns: 1, value: 0.0)
        let Empty3D = Matrix(ofRows: 3, columns: 1, value: 0.0)
        //now do the euclidean length calculation
        let r_delta = ECEF_2D?.euclideanDistance(to: Empty2D)
        let z_delta = ECEF.euclideanDistance(to: Empty3D)
        //        print("r delta:", r_delta)
        //        print("z delta:", z_delta)
        //
        let x = ECEF.value(atRow: 0, column: 0)
        let y = ECEF.value(atRow: 1, column: 0)
        let z = ECEF.value(atRow: 2, column: 0)
        //        var dist = sqrt((pow(x, 2)+pow(y,2)))
        //
        //        print("norm2 manual:", dist)
        
        let sinA = y/r_delta!;
        let cosA = x/r_delta!;
        var Long = atan2(sinA, cosA)
        
        var r2d = 180*M_PI;
        
        if(Long < -M_PI)
        {
            Long = Long + M_2_PI
        }
        
        var Lat = asin(z/z_delta)
        
        return [Lat, Long]
        
    }
    
    
}


