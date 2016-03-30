//
//  PanoramaCollectionView.swift
//  MMPaperGallery
//
//  Created by Mukesh on 29/03/16.
//  Copyright © 2016 Mad Apps. All rights reserved.
//

import UIKit
import CoreMotion

class PanoramaCollectionView: UICollectionView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
    
    //Managing Motion
    var motionRate:CGFloat!
    var minimumXOffset:CGFloat!
    var maximumXOffset:CGFloat!
    var motionManager: CMMotionManager = CMMotionManager()
    var motionBool = false
    //Constatnts
    let CRMotionViewRotationMinimumThreshold:CGFloat = 0.1
    let CRMotionGyroUpdateInterval:NSTimeInterval = 1 / 100
    let CRMotionViewRotationFactor:CGFloat = 4.0
    
    
    // MARK: - Core Motion
    /*
    start monitoring the updates of the gyro to rotate the scrollview accoring the device motion rotation rate.
    */
    func startMonitoring(){
        
        
        self.motionManager.gyroUpdateInterval = CRMotionGyroUpdateInterval
        if !self.motionManager.gyroActive && self.motionManager.gyroAvailable{
            
            self.motionManager.startGyroUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: { (CMGyroData, NSError) -> Void in
                self.motionBool = true
                self.rotateAccordingToDeviceMotionRotationRate(CMGyroData!)
            })
            
            
        }
            
        else{
            
            print("No Availabel gyro")
        }
    }
    
    /*
    this function calculate the rotation of UIScrollview accoring to the device motion rotation rate.
    */
    func rotateAccordingToDeviceMotionRotationRate(gyroData:CMGyroData){
        // Why the y value not x or z.
        /*
        *    y:
        *      Y-axis rotation rate in radians/second. The sign follows the right hand
        *      rule (i.e. if the right hand is wrapped around the Y axis such that the
        *      tip of the thumb points toward positive Y, a positive rotation is one
        *      toward the tips of the other 4 fingers).
        */
        let rotationRate = CGFloat(gyroData.rotationRate.y)
        if abs(rotationRate) >= CRMotionViewRotationMinimumThreshold{
            
            let currentPage = self.contentOffset.x / self.frame.size.width
            if let cell = self.cellForItemAtIndexPath(NSIndexPath(forItem: Int(currentPage), inSection: 0)) as? DemoCollectionViewCell{
                self.motionRate = (cell.photo!.size.width) / self.frame.size.width * CRMotionViewRotationFactor
                self.maximumXOffset = (cell.scroll.contentSize.width) - (cell.scroll.frame.size.width)
                
                var offsetX = (cell.scroll.contentOffset.x) - rotationRate * self.motionRate
                if offsetX > self.maximumXOffset{
                    
                    offsetX = self.maximumXOffset
                }
                else if offsetX < self.minimumXOffset{
                    
                    offsetX = self.minimumXOffset
                }
                
                
                UIView.animateWithDuration(0.3, delay: 0.0, options: [.BeginFromCurrentState, .AllowUserInteraction, .CurveEaseOut], animations: { () -> Void in
                    cell.scroll.setContentOffset(CGPointMake(offsetX, 0), animated: false)
                    }, completion: nil)
            }

        }
        
        
    }
    
    /*
    Stop gyro updates if reciever set motionEnabled = false
    */
    func stopMonitoring(){
        if(self.motionBool){
            self.motionBool = false
            self.motionManager.stopGyroUpdates()

        }
    }
}
