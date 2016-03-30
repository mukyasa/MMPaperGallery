//
//  DemoCollectionViewCell.swift
//  MMPaperGallery
//
//  Created by Mukesh on 29/03/16.
//  Copyright © 2016 Mad Apps. All rights reserved.
//

import UIKit

class DemoCollectionViewCell: UICollectionViewCell,UIScrollViewDelegate  {
    @IBOutlet weak var paraImageView: UIImageView!
    var scroll : UIScrollView!
    var imageView : UIImageView!
    weak var relatedCollectionView : PanoramaCollectionView!
    var photo : UIImage?  {
        
        set{
            self.imageView.image = newValue
        }
        get{
            if(self.imageView != nil){
                return self.imageView.image
            }
            return nil
        }
    }
    
    var toggle = false
    var indicator : UIActivityIndicatorView!
    var imgtask : NSURLSessionDataTask!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.scroll = UIScrollView(frame: CGRectZero)
        self.scroll.clipsToBounds = true
        
        imageView = UIImageView(frame: CGRectZero)
        imageView.userInteractionEnabled = true
        imageView.contentMode = .ScaleAspectFit
        self.imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        self.scroll.delegate = self
        self.scroll.addSubview(self.imageView)
        
        self.contentView.addSubview(self.scroll)
        
        //Indicator
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.contentView.addSubview(indicator)
        
        let tap = UITapGestureRecognizer(target: self, action: "tappedPhoto")
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func tappedPhoto(){
        
        //Panorama
        
        if(toggle){
            self.scroll.userInteractionEnabled = true
            UIView.animateWithDuration(0.3, delay: 0.0, options: [.BeginFromCurrentState, .AllowUserInteraction, .CurveEaseOut], animations: { () -> Void in
                self.layoutTheComponents()
                }, completion: { (bool) -> Void in
                    self.toggle = false
                    self.relatedCollectionView.stopMonitoring()
                    
            })
        }else{
            UIView.animateWithDuration(0.3, delay: 0.0, options: [.BeginFromCurrentState, .AllowUserInteraction, .CurveEaseOut], animations: { () -> Void in
                self.scroll.userInteractionEnabled = false
                self.scroll.zoomScale = 1
                self.scroll.maximumZoomScale = 1
                self.scroll.minimumZoomScale = 1
                let width = self.frame.size.height / self.photo!.size.height * self.photo!.size.width
                self.imageView.frame = CGRectMake(0, 0, width, self.frame.height)
                self.scroll.contentSize = CGSizeMake(self.imageView.frame.size.width, self.scroll.frame.size.height)
                self.scroll.contentOffset = CGPointMake((self.scroll.contentSize.width - self.scroll.frame.size.width) / 2, 0)
                
                
                }, completion: { (bool) -> Void in
                    self.toggle = true
                    self.relatedCollectionView.startMonitoring()
                    
                    
                    
            })
        }
        
        
        //        //Zoom
        //        if(toggle){
        //
        //            UIView.animateWithDuration(0.3, animations: { () -> Void in
        //                self.scroll.zoomScale = 1.0
        //
        //            })
        //            toggle = false
        //
        //        }else{
        //            zooomToPoint(sender.locationInView(self.imageView), scale: self.scroll.maximumZoomScale)
        //            toggle = true
        //
        //        }
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTheComponents()
    }
    
    func layoutTheComponents(){
        self.imageView.frame = self.bounds  //very imp line
        self.scroll.frame = self.imageView.frame
        
        self.scroll.contentSize = self.imageView.frame.size
        let minimumScale = scroll.frame.size.width / self.imageView.frame.size.width
        self.scroll.maximumZoomScale = 2.5
        self.scroll.minimumZoomScale = minimumScale
        self.scroll.zoomScale = minimumScale
        
        indicator.center = self.center
        
        
    }
    
    func zooomToPoint(point : CGPoint , scale : CGFloat ){
        
        
        print(point)
        let w = self.scroll.bounds.size.width / scale
        let h = self.scroll.bounds.size.height / scale
        let x = point.x - (w / 2.0)
        let y = point.y - (h / 2.0)
        
        self.scroll.zoomToRect(CGRectMake(x, y, w, h), animated: true)
        
        
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    
    func configureCell(){
        
        let minimumScale = scroll.frame.size.width / self.imageView.frame.size.width
        self.scroll.zoomScale = minimumScale
        self.imageView.frame = self.bounds  //very imp line
        self.scroll.frame = self.imageView.frame
        self.scroll.contentSize = self.imageView.frame.size
        self.scroll.userInteractionEnabled = true
        
    }
    
    func configureForURL(url : String){
        self.imageView.image = UIImage()
        if((self.imgtask) != nil){
            self.imgtask.cancel()
        }
        let posturl : NSURL = NSURL(string: url)!
        self.indicator.startAnimating()
        self.imgtask = self.appDelegate.imageSession?.dataTaskWithURL(posturl, completionHandler: { (data, reponse, error) -> Void in
            
            
            if((error) != nil){
                self.imageView.image = UIImage()
            }
            else{
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    UIView.transitionWithView(self.imageView, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                        self.imageView.image=UIImage(data: data!);
                        self.photo = UIImage(data: data!)
                        }, completion: { (Bool) -> Void in
                            self.indicator.stopAnimating()
                            
                            
                    })
                })
                
            }
            
            
        })
        
        self.imgtask.resume()
    }
    
    
}
