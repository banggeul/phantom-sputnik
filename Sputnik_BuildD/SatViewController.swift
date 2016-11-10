//
//  SatViewController.swift
//  Sputnik_BuildD
//
//  Created by Mini Panton on 11/7/16.
//  Copyright © 2016 Some Feelers. All rights reserved.
//

import UIKit
import MapKit

class SatViewController: UIViewController, MKMapViewDelegate {

    weak var mapView: MKMapView!
    weak var timer: Timer!
    weak var dataBlock: DataBlock?
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        mapView = MKMapView()
        mapView.frame = self.view.bounds
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        
        self.view.insertSubview(mapView, belowSubview:dismissButton)
        
        let center = CLLocationCoordinate2D(latitude:(dataBlock?.GT.earthCoordinates.latitude)!, longitude:(dataBlock?.GT.earthCoordinates.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
        mapView.setRegion(region, animated: true)
        
        mapView.mapType = MKMapType.satellite
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction
    func dismiss() {
        
        //isPresented = false
        self.presentingViewController!.dismiss(animated: true, completion: nil);
    }
    
    func update(){
        
        //print("sat:")
        //print(dataBlock?.GT.earthCoordinates.latitude, dataBlock?.GT.earthCoordinates.longitude)
        
        dataBlock?.update()
        
        let center = CLLocationCoordinate2D(latitude:(dataBlock?.GT.earthCoordinates.latitude)!, longitude:(dataBlock?.GT.earthCoordinates.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
        mapView.setRegion(region, animated: false)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = self.view.bounds
        
    }

    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mapView.removeFromSuperview()
        if let uwTimer = timer {
            if uwTimer.isValid {
                uwTimer.invalidate()
            }
        }
    }
    
    deinit {
        print("deallocate")
        dataBlock = nil
    }

}
