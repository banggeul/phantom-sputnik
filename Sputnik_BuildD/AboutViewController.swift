//
//  AboutViewController.swift
//  Sputnik_BuildD
//
//  Created by Mini Panton on 10/8/16.
//  Copyright © 2016 Some Feelers. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
     //var leftSwipeGestureRecognizer:UISwipeGestureRecognizer?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe))
        //leftSwipeGestureRecognizer?.direction = UISwipeGestureRecognizerDirection.left
        //view.addGestureRecognizer(leftSwipeGestureRecognizer!)

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
    
    func handleLeftSwipe()
    {
        performSegue(withIdentifier: "aboutToRadio", sender: nil)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
