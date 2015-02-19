//
//  ViewController.swift
//  SwiftEstimoteBeacons
//
//  Created by Michael Kane on 2/18/15.
//  Copyright (c) 2015 ArilogicApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ESTBeaconManagerDelegate {
    
    @IBOutlet var beaconLabel: UILabel!
    
    let webView = UIWebView()
    var buttonWeb = UIBarButtonItem()
    let beaconManager : ESTBeaconManager = ESTBeaconManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set beacon manager delegate
        beaconManager.delegate = self;
        
        //create the beacon region
        var beaconRegion : ESTBeaconRegion = ESTBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"), major: 37470, minor: 56023, identifier: "regionName")
        
        //Opt in to be notified upon entering and exiting region
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        
        //beacon manager asks permission from user
        beaconManager.startRangingBeaconsInRegion(beaconRegion)
        beaconManager.startMonitoringForRegion(beaconRegion)
        beaconManager.requestAlwaysAuthorization()
    }
    
    func beaconManager(manager: ESTBeaconManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: ESTBeaconRegion!) {
        
        if beacons.count > 0 {
            var firstBeacon : ESTBeacon = beacons.first! as ESTBeacon
            
            self.beaconLabel.text = ("\(textForPromimity(firstBeacon.proximity))")
            
        }
    }
    
    func textForPromimity(proximity:CLProximity) -> (NSString)
    {
        var distance : NSString!
        
        switch(proximity)
        {
        case .Far:
            println("Far")
            distance = "far"
            beaconLabel.textColor = UIColor.redColor()
            return distance
        case .Near:
            println("Near")
            distance = "Near"
            beaconLabel.textColor = UIColor.purpleColor()
            return distance
        case .Immediate:
            println("Immediate")
            distance = "Immediate"
            beaconLabel.textColor = UIColor.greenColor()
            return distance
        case .Unknown:
            println("Unknown")
            distance = "Unknown"
            return distance
        default:
            break;
        }
        return distance
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //check for region failure
    func beaconManager(manager: ESTBeaconManager!, monitoringDidFailForRegion region: ESTBeaconRegion!, withError error: NSError!) {
        println("Region did fail: \(manager) \(region) \(error)")
    }
    
    //checks permission status
    func beaconManager(manager: ESTBeaconManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("Status: \(status)")
    }
    
    //beacon entered region
    func beaconManager(manager: ESTBeaconManager!, didEnterRegion region: ESTBeaconRegion!) {
        
        var notification : UILocalNotification = UILocalNotification()
        notification.alertBody = "Youve done it!"
        notification.soundName = "Default.mp3"
        println("Youve entered")
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    //beacon exited region
    func beaconManager(manager: ESTBeaconManager!, didExitRegion region: ESTBeaconRegion!) {
        
        var notification : UILocalNotification = UILocalNotification()
        notification.alertBody = "Youve exited!"
        notification.soundName = "Default.mp3"
        println("Youve exited")
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    @IBAction func getConnected(sender: AnyObject) {
        
        webView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        view.addSubview(webView)
        
        let url = NSURL(string: "http://www.estimote.com")
        let request = NSURLRequest(URL:url!)
        webView.loadRequest(request)
        
        buttonWeb = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "finished")
        navigationItem.setRightBarButtonItem(buttonWeb, animated: true)
        
    }
    
    func finished()
    {
        webView.removeFromSuperview()
        var b = UIBarButtonItem()
        navigationItem.setRightBarButtonItem(b, animated: true)
    }
    
}

