//
//  ViewController.swift
//
//  Sputnik_BuildD
//
//  Created by Mini Panton on 11/7/16.
//  Copyright © 2016 Some Feelers. All rights reserved.

import UIKit
import CoreLocation
import AVFoundation
import AudioKit


class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager = CLLocationManager()
    let timeNow = Date();
    let timeSince1970 = Date().timeIntervalSince1970;
    let broadcastRadius = 2500.0 //km
    var timer: Timer!
    var startLocation: CLLocation!
    
    var dataBlock: DataBlock = DataBlock();
    var rightSwipeGestureRecognizer: UISwipeGestureRecognizer?
    var leftSwipeGestureRecognizer:UISwipeGestureRecognizer?
    
    var player: AVPlayer?
    var pL: AVPlayerLayer?
    //audio stuff
    var pink:AKPinkNoise?
    var white:AKWhiteNoise?
    var whitePinkMixer = AKMixer()
    var mixer = AKMixer()
    var audioFilePlayer:AKAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the video from the app bundle.
        let videoURL: URL = Bundle.main.url(forResource: "square_6sec_2", withExtension: "mp4")!
        
        player = AVPlayer(url: videoURL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        
        playerLayer.frame = view.frame
        
        view.layer.addSublayer(playerLayer)
        pL = playerLayer
        
        
        player?.play()
        
        //loop video
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ViewController.loopVideo),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
        
        //set up audio
        AKAudioFile.cleanTempDirectory()
        
        //make the audio file player
        let file = try? AKAudioFile(readFileName: "sputnik_3.aif")
        audioFilePlayer = try? AKAudioPlayer(file: file!)
        audioFilePlayer?.looping = true
        mixer.connect(audioFilePlayer!)
        audioFilePlayer?.volume = 0
        
        //make noise
        white = AKWhiteNoise(amplitude: 0.1)
        pink = AKPinkNoise(amplitude: 0.1)
        whitePinkMixer = AKMixer(white!, pink!)
        mixer.connect(whitePinkMixer)
        
        AudioKit.output = mixer
        AudioKit.start()
        audioFilePlayer?.play()
        pink?.start()
        white?.start()
        
        fadeNoisePlayer(fromVolume: 0, toVolume: 1, overTime: 10)

        // Do any additional setup after loading the view, typically from a nib.
        
        //get the permission for the location
        locationManager.delegate = self
        //locationManager.requestAlwaysAuthorization()
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
//        
//        if(CLLocationManager.locationServicesEnabled())
//        {
//            locationManager.startUpdatingLocation()
//        }else{
//            print("location service is disabled")
//        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        
        self.locationManager.requestWhenInUseAuthorization();
        
        if(CLLocationManager.locationServicesEnabled()){
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            locationManager.requestAlwaysAuthorization();
            locationManager.startUpdatingLocation();
            
        }else{
            print("Location Services Disabled");
        }
//        rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe))
//        rightSwipeGestureRecognizer?.direction = UISwipeGestureRecognizerDirection.right
//        view.addGestureRecognizer(rightSwipeGestureRecognizer!)
//
        leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
        leftSwipeGestureRecognizer?.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(leftSwipeGestureRecognizer!)
        
        
        update()
        
        
        
    }
    
    func loopVideo() {
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        print("View Controller - viewDidAppear: \(animated)");
        timer = Timer.scheduledTimer(timeInterval: 2, target:self, selector: #selector(ViewController.update), userInfo: nil, repeats: true);
        update()
        
    }
    
    func handleLeftSwipe()
    {
        performSegue(withIdentifier: "GroundTrack", sender: nil)
    }
    
    
     func update(){
        //        while(timeNow < timeSince1970){
        //            update();   m 
        //        }
        
        //        print("timesince70:",timeSince1970);
        //        print("time now:", timeNow);
        
        dataBlock.update();
        //dataBlock.user.printInfo()
        
        if(dataBlock.sputnikIsWithin(broadcastRadius*1000)){
            print("shouldBeep");
            if(audioFilePlayer?.volume == 0)
            {
                fadeAudioFilePlayer(fromVolume: 0, toVolume: 1, overTime: 4.0)
                fadeNoisePlayer(fromVolume: 1, toVolume: 0, overTime: 4.0)
            }
            //            if(!oscillator.isPlaying){
            //                oscillator.amplitude = 0.5
            //                oscillator.frequency = 600
            //                oscillator.start()
            //            }else{
            //                let delta = broadcastRadius*1000/2 - dataBlock.sputnikIs()
            //                //print("delta", delta*0.000001)
            //                oscillator.amplitude = delta*0.000001;
            //            }
            //            if(!audioPlayer.playing){
            //                audioPlayer.play();
            //            }
        }else{
            
            if(audioFilePlayer?.volume == 1)
            {
                fadeAudioFilePlayer(fromVolume: 1, toVolume: 0, overTime: 4.0)
                fadeNoisePlayer(fromVolume: 0, toVolume: 1, overTime: 4.0)
            }
            //            if(oscillator.isPlaying){
            //                oscillator.stop()
            //            }
        }
    }

    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "about" {
            
        } else if segue.identifier == "GroundTrack"{
            let DestController: SecondViewController = segue.destination as! SecondViewController;
            DestController.dataBlock = self.dataBlock;
        } else {
            let DestController:SatViewController = segue.destination as! SatViewController;
            DestController.dataBlock = self.dataBlock;
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        mapView.showsUserLocation = (status == .AuthorizedAlways)
        print(status)
        if(status == .authorizedAlways)
        {
            print(manager.location?.coordinate)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        // let locValue: CLLocationCoordinate2D = manager.location.coordinate;
        var locValue:CLLocationCoordinate2D;
        locValue = manager.location!.coordinate;
        dataBlock.user.coordinate.latitude = locValue.latitude;
        dataBlock.user.coordinate.longitude = locValue.longitude;
        let d2r = M_PI/180.0;
        dataBlock.user.coordinate.latRad = locValue.latitude*d2r
        dataBlock.user.coordinate.longRad = locValue.longitude*d2r
        
        //print("Latitude: \(locValue.latitude) Longitude: \(locValue.longitude) -USER");
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error while updating location: " + error.localizedDescription);
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager){
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.pL?.frame = self.view.bounds
        //self.pL?.position
        
    }
    
    func fadeAudioFilePlayer(fromVolume startVolume : Float,
                             toVolume endVolume : Float,
                             overTime time : Float) {
        
        // Update the volume every 1/100 of a second
        let fadeSteps : Int = Int(time) * 100
        // Work out how much time each step will take
        let timePerStep : Float = 1 / 100.0
        
        //        self.whitePinkMixer.volume = Double(startVolume);
        self.audioFilePlayer?.volume = Double(startVolume)
        //
        // print(fadeSteps)
        
        // Schedule a number of volume changes
        for step in 0...fadeSteps {
            
            let delayInSeconds : Float = Float(step) * timePerStep
            
            //            let popTime = dispatch_time(DISPATCH_TIME_NOW,Int64(delayInSeconds * Float(NSEC_PER_SEC)));
            //
            //            dispatch_after(popTime, dispatch_get_main_queue()) {
            //
            //                let fraction = (Float(step) / Float(fadeSteps))
            //
            //                volumeNode.gain = Double(startVolume +
            //                    (endVolume - startVolume) * fraction)
            //
            //            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(delayInSeconds)) {
                // your function here
                let fraction = (Float(step) / Float(fadeSteps))
                
                self.audioFilePlayer?.volume = Double(startVolume + (endVolume - startVolume) * fraction)
                
                //self.audioFilePlayer?.volume = Double(endVolume + (startVolume - endVolume) * fraction)
                // self.noiseButton.alpha = CGFloat(1-self.whitePinkMixer.volume)
                // self.musicButton.alpha = CGFloat(1-(self.audioFilePlayer!.volume))
                //print(self.beepVolume?.gain)
                //                if(self.whitePinkMixer.volume == Double(endVolume)){
                //                    if(self.whitePinkMixer.volume > 0.1)
                //                    {
                //                        self.noiseButton.isEnabled = false
                //                        self.musicButton.isEnabled = true
                //                    }else{
                //                        self.noiseButton.isEnabled = true
                //                        self.musicButton.isEnabled = false
                //                    }
                //
                //
                //                }
            }
        }
    }
    
    func fadeNoisePlayer(fromVolume startVolume : Float,
                         toVolume endVolume : Float,
                         overTime time : Float) {
        
        // Update the volume every 1/100 of a second
        let fadeSteps : Int = Int(time) * 100
        // Work out how much time each step will take
        let timePerStep : Float = 1 / 100.0
        
        self.whitePinkMixer.volume = Double(startVolume);
        // Schedule a number of volume changes
        for step in 0...fadeSteps {
            
            let delayInSeconds : Float = Float(step) * timePerStep
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(delayInSeconds)) {
                // your function here
                let fraction = (Float(step) / Float(fadeSteps))
                
                self.whitePinkMixer.volume = Double(startVolume + (endVolume - startVolume) * fraction)
                
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
         if let uwTimer = timer {
            if uwTimer.isValid {
                uwTimer.invalidate()
            }
         }
    }
    


}

