//
//  SecondViewController.swift
//  LandscapeController_Swift
//
//  Created by olxios on 20/06/16.
//  Copyright © 2016 olxios. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    
    var isPresented = true
    var Convert = ConvertLatLongToXY()
    var map_width:CGFloat = 0
    var map_height:CGFloat = 0
    var dot_size:CGFloat = 0
    //var dataBlock: DataBlock = DataBlock();
    weak var dataBlock: DataBlock?

    weak var timer: Timer!
    
    //@IBOutlet weak var sputnikView:SputnikView!
    @IBOutlet weak var meView:MeView!
    @IBOutlet weak var mapView:UIImageView!
    @IBOutlet weak var equatorView: CenterView!
    
    var rightSwipeGestureRecognizer: UISwipeGestureRecognizer?
    
    
    @IBOutlet weak var sputnikAnimView: UIImageView!
    @IBAction
    func dismiss() {
        
        isPresented = false
        self.presentingViewController!.dismiss(animated: true, completion: nil);
    }
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
        rightSwipeGestureRecognizer?.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(rightSwipeGestureRecognizer!)
        
        //get the bounds of mapView //flip the width and height
        if(self.view.frame.width > self.view.frame.height)
        {
            print("it's landscape")
            map_width = self.view.frame.width
            map_height = self.view.frame.height
        }else {
            print("it's portrait")
            map_height = self.view.frame.width
            map_width = self.view.frame.height
        }
        
//        map_height = 750
//        map_width = 1334.0
        dot_size = meView.frame.width
        
        sputnikAnimView.animationImages = [UIImage]();

        for index in 0 ..< 25 {
            let frameName = String(format: "wave_%02d", index) // Frame%03d means AssetName/AmountOfZeros/Increment
            print(frameName)
            sputnikAnimView.animationImages?.append(UIImage(named: frameName)!)
        }

        
        //print(dataBlock?.user.coordinate.latitude, dataBlock?.user.coordinate.longitude)
        
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        print("View Controller - viewDidAppear: \(animated)");
        timer = Timer.scheduledTimer(timeInterval: 2, target:self, selector: #selector(SecondViewController.update), userInfo: nil, repeats: true);
        
        update()
        
        dataBlock?.GT.calcGTrackPath()
        
        if((dataBlock?.GT.Lats.count)! > 0)
        {
            let numPoints = (dataBlock?.GT.Lats.count)!
            for index in 0 ..< numPoints {
                let lat = dataBlock?.GT.Lats[index]
                let long = dataBlock?.GT.Longs[index]
                let point = Convert.PlotPoint(lat as! Double, long: long as! Double, dot_size: 2, longitude_shift: 0, x_pos: 0, y_pos: 0, map_width: Double(map_width), map_height: Double(map_height))
                var dView = SputnikView(frame:CGRect(x: point.x, y: point.y, width: 2, height: 2))
                
                dView.backgroundColor = UIColor.clear
                dView.alpha = CGFloat(1 - CGFloat(index)/CGFloat(numPoints))
                dView.tag = 99
                //print("alpha: ", dView.alpha)
                self.view.addSubview(dView)
            }
        }
        
    }
    
    func handleRightSwipe()
    {
        self.dismiss();
    }

    
    func update(){
        
        dataBlock?.update()
        let point3 = Convert.PlotPoint((dataBlock?.GT.earthCoordinates.latitude)!, long: (dataBlock?.GT.earthCoordinates.longitude)!, dot_size: 100, longitude_shift: 0, x_pos: 0, y_pos: 0, map_width: Double(map_width), map_height: Double(map_height))
        sputnikAnimView.center = CGPoint(x: CGFloat(point3.x), y: CGFloat(point3.y))
        sputnikAnimView.setX(CGFloat(point3.x))
        sputnikAnimView.setY(CGFloat(point3.y))
        
    }
    
    override func viewDidLayoutSubviews() {
        
        //let map_width =
        
        
        // Do any additional setup after loading the view, typically from a nib.
        //let point = Convert.PlotPoint(25.7617, long: -80.1918)
//        print("user:")
//        print(dataBlock?.user.coordinate.latitude)
        let point = Convert.PlotPoint((dataBlock?.user.coordinate.latitude)!, long: (dataBlock?.user.coordinate.longitude)!, dot_size: Double(dot_size), longitude_shift: 0, x_pos: 0, y_pos: 0, map_width: Double(map_width), map_height: Double(map_height))
//        let point2 = Convert.PlotPoint(34.0522, long: -118.2437, dot_size: Double(dot_size), longitude_shift: 0, x_pos: 0, y_pos: 0, map_width: Double(map_width), map_height: Double(map_height))
        let point3 = Convert.PlotPoint((dataBlock?.GT.earthCoordinates.latitude)!, long: (dataBlock?.GT.earthCoordinates.longitude)!, dot_size: 100, longitude_shift: 0, x_pos: 0, y_pos: 0, map_width: Double(map_width), map_height: Double(map_height))
        let point4 = Convert.PlotPoint(0.00, long: 0.00, dot_size: Double(dot_size), longitude_shift: 0, x_pos: 0, y_pos: 0, map_width: Double(map_width), map_height: Double(map_height))
        
//        let point3 = Convert.PlotPoint(0.0000, long: 0.0000)
//        print(point.y)
//        print(point2.y)
//        print(point3.y)
        //print(point4.y)
        
        meView.center = CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))
        meView.setX(CGFloat(point.x))
        meView.setY(CGFloat(point.y) - CGFloat(meView.frame.height/2))
//        meView2.center = CGPointMake(CGFloat(point2.x), CGFloat(point2.y))
//        meView2.setX(CGFloat(point2.x))
//        meView2.setY(CGFloat(point2.y))
//        sputnikView.center = CGPoint(x: CGFloat(point3.x), y: CGFloat(point3.y))
//        sputnikView.setX(CGFloat(point3.x))
//        sputnikView.setY(CGFloat(point3.y))
        equatorView.center = CGPoint(x:CGFloat(-100), y:CGFloat(-100))
        
        
        
        //print(sputnikView.imageView?.animationImages!)
        
        sputnikAnimView.animationDuration = 2 // Seconds
        sputnikAnimView.startAnimating()
        sputnikAnimView.center = CGPoint(x: CGFloat(point3.x), y: CGFloat(point3.y))
        sputnikAnimView.setX(CGFloat(point3.x))
        sputnikAnimView.setY(CGFloat(point3.y))

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("map view disappeared clean up the path")
        
        for subUIView in self.view.subviews as [UIView] {
            
            if(subUIView.isKind(of: SputnikView.self)){
                subUIView.removeFromSuperview()
            }
        }
        
        if let uwTimer = timer {
            if uwTimer.isValid {
                uwTimer.invalidate()
            }
        }

        
        //self.dataBlock? = nil
        
        
    }
    
    deinit {
        print("deallocate")
        dataBlock = nil
    }

}
