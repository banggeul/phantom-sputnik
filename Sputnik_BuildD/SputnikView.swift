//
//  SputnikView.swift
//  LandscapeController_Swift
//
//  Created by Mini Panton on 9/4/16.
//

import UIKit

class SputnikView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.*/

    //let π:CGFloat = CGFloat(M_PI)
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        // Drawing code
        // 1
        //self.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        //let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        
        //self.imageView = UIImageView()
               
        // 2
//        let radius: CGFloat = max(bounds.width, bounds.height)
//        let startAngle: CGFloat = 0
//        let endAngle: CGFloat = 2*π
//        
//        let path = UIBezierPath(arcCenter: center,
//                                radius: 2,
//                                startAngle: startAngle,
//                                endAngle: endAngle,
//                                clockwise: true)
        let path = UIBezierPath(ovalIn: rect)
        UIColor.init(red: 0, green: 0, blue: 0, alpha: 1).setFill()
        path.fill()

        
//        let pathRange = UIBezierPath(arcCenter: center,
//                                     radius: 34/2,
//                                     startAngle: startAngle,
//                                     endAngle: endAngle,
//                                     clockwise: true)
//        UIColor.init(red: 0, green: 0, blue: 1.0, alpha: 0.3).setFill()
//        pathRange.fill()
//        UIColor.blue.setStroke()
//        pathRange.stroke()
        
        
    }
 
}
