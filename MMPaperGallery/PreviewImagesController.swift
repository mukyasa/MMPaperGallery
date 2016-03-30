//
//  PreviewImagesController.swift
//  MMPaperGallery
//
//  Created by Mukesh on 29/03/16.
//  Copyright © 2016 Mad Apps. All rights reserved.
//

import UIKit
import CoreMotion

@objc protocol ScrollDelegate{
    
    //Refrshing the Particular Controller
    func scrollToIndexPath(indexPath : NSIndexPath)   // Called when the main Scrollview...scrolls
}


class PreviewImagesController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var previewCollectionView : PanoramaCollectionView!
    let kCellIdentifierGallery = "preview"
    var previewArr = NSMutableArray()
    weak var preveiewdelegate : ScrollDelegate!
    var currentIndexPath = NSIndexPath()
    
    @IBOutlet weak var likeBut: UIButton!
    
    @IBOutlet weak var commentBut: UIButton!
    
    @IBOutlet weak var shareBut: UIButton!
    
    @IBOutlet weak var descLbl: UILabel!
    
    @IBOutlet weak var dismissBut: UIButton!
     var interactor:Interactor? = nil
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.clearColor()
        
        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSizeMake(CGRectGetWidth(view.frame), CGRectGetHeight(view.frame) )
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .Horizontal
        
        previewCollectionView = PanoramaCollectionView(frame: CGRectMake(0, 0, CGRectGetWidth(view.frame), CGRectGetHeight(view.frame)) , collectionViewLayout: flowLayout)

        previewCollectionView.registerClass(DemoCollectionViewCell.self, forCellWithReuseIdentifier: kCellIdentifierGallery)
        
        previewCollectionView.dataSource = self
        previewCollectionView.backgroundColor = UIColor.clearColor()
        previewCollectionView.pagingEnabled = true
        
        previewArr = ["bat.jpg" , "civil.jpg" , "ironman"]
        //        previewArr  = ["http://groups-tap.s3.amazonaws.com/14586455588900.jpg" , "http://groups-tap.s3.amazonaws.com/14586477414997.jpg"]
        view.insertSubview(previewCollectionView, atIndex: 0)
        
        
        likeBut.setImage(IonIcons.imageWithIcon("\u{f251}", size: 30, color: UIColor.whiteColor()), forState: .Normal)
        shareBut.setImage(IonIcons.imageWithIcon("\u{f2f8}", size: 30, color: UIColor.whiteColor()), forState: .Normal)
        commentBut.setImage(IonIcons.imageWithIcon("\u{f3b2}", size: 30, color: UIColor.whiteColor()), forState: .Normal)
        dismissBut.setImage(IonIcons.imageWithIcon("\u{f2d7}", size: 35, color: UIColor.whiteColor()), forState: .Normal)
        dismissBut.addTarget(self, action: "closeAction", forControlEvents: .TouchUpInside)

        //Custom
        previewCollectionView.minimumXOffset = 0
        previewCollectionView.scrollToItemAtIndexPath(currentIndexPath, atScrollPosition: .None, animated: false)
        
        previewCollectionView.backgroundColor = UIColor.clearColor()
//        let pan = UIPanGestureRecognizer(target: self, action: "handleGesture:")
//        previewCollectionView.addGestureRecognizer(pan)
        
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    //MARK:- Actions
    

    func closeAction(){
        let currentPage = self.previewCollectionView.contentOffset.x / self.view.frame.size.width
//        if let cell = self.previewCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: Int(currentPage), inSection: 0)) as? DemoCollectionViewCell{
//            if(!cell.toggle){
//                cell.tappedPhoto()
//            }
//        }
        if(currentIndexPath == NSIndexPath(forItem: Int(currentPage), inSection: 0)){
            
        }else{
            self.preveiewdelegate.scrollToIndexPath(NSIndexPath(forItem: Int(currentPage), inSection: 0))
 
        }
        self.dismissViewControllerAnimated(true) { () -> Void in

        }
    }
    
    //MARK:- Datasource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return 10;
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        if let cell:DemoCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifierGallery, forIndexPath: indexPath) as? DemoCollectionViewCell{
            
            
            if(indexPath.row == 0){
              cell.photo = UIImage(named: previewArr[0] as! String)
            }else{
                if(indexPath.row % 2 == 0){
                    //                 cell.configureForURL(previewArr[0] as! String)
                    cell.photo = UIImage(named: previewArr[1] as! String)
                }else{
                    //                 cell.configureForURL(previewArr[1] as! String)
                    cell.photo = UIImage(named: previewArr[2] as! String)
                }
            }
            

            
            cell.configureCell()
            
            cell.relatedCollectionView = previewCollectionView
            self.previewCollectionView.stopMonitoring()
            return cell
            
        }
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.view.bounds.size
    }
    
    
    func handleGesture(sender: UIPanGestureRecognizer) {
        
        let percentThreshold:CGFloat = 0.3
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translationInView(view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .Began:
            interactor.hasStarted = true
            dismissViewControllerAnimated(true, completion: nil)
        case .Changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.updateInteractiveTransition(progress)
        case .Cancelled:
            interactor.hasStarted = false
            interactor.cancelInteractiveTransition()
        case .Ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finishInteractiveTransition()
                : interactor.cancelInteractiveTransition()
        default:
            break
        }
    }

    
    
}

class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}

