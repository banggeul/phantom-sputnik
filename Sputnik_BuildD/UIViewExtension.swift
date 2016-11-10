//
//  UIViewExtension.swift
//
//  Created by Mini Panton on 9/4/16.
//
//  Sputnik_BuildD
//
//  Created by Mini Panton on 11/7/16.
//  Copyright © 2016 Some Feelers. All rights reserved.

import UIKit

extension UIView {
    /**
     Extension UIView
     by DaRk-_-D0G
     */
        /**
         Set x Position
         
         :param: x CGFloat
         by DaRk-_-D0G
         */
        func setX(_ x:CGFloat) {
            var frame:CGRect = self.frame
            frame.origin.x = x
            self.frame = frame
        }
        /**
         Set y Position
         
         :param: y CGFloat
         by DaRk-_-D0G
         */
        func setY(_ y:CGFloat) {
            var frame:CGRect = self.frame
            frame.origin.y = y
            self.frame = frame
        }
        /**
         Set Width
         
         :param: width CGFloat
         by DaRk-_-D0G
         */
        func setWidth(_ width:CGFloat) {
            var frame:CGRect = self.frame
            frame.size.width = width
            self.frame = frame
        }
    
        func setHeight(_ height:CGFloat) {
            var frame:CGRect = self.frame
            frame.size.height = height
            self.frame = frame
        }
}
