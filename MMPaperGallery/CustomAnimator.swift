//
//  CustomAnimator.swift
//  MMPaperGallery
//
//  Created by Mukesh on 30/03/16.
//  Copyright © 2016 Mad Apps. All rights reserved.
//

import UIKit

class CustomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration    = 0.5
    var presenting  = true
    var originFrame = CGRect.zero
    var finalFrame = CGRect.zero
    weak var cell : ImageTableViewCell!
    var image = UIImage()
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?)-> NSTimeInterval {
        return duration
    }
    

//    
//    func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
//        let containerView = transitionContext.containerView()!
//        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
//        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey )!
//        
//        if(presenting){
//            let view = VICMAImageView(frame: originFrame)
//            view.contentMode = .ScaleAspectFill
//            view.clipsToBounds = true
//            view.image = image
//            
//            fromView.alpha = 0
//            toView.alpha = 0
//            finalFrame = toView.frame
//            containerView.addSubview(toView)
//            containerView.addSubview(view)
//            
//            UIView.animateWithDuration(0.5, animations: { () -> Void in
//                view.contentMode = .ScaleAspectFit
//                view.frame = self.finalFrame
//                
//                }, completion: { (bool) -> Void in
//                    toView.alpha = 1
//                    UIView.animateWithDuration(0.1, animations: { () -> Void in
//                        
//                        view.removeFromSuperview()
//                    })
//                    transitionContext.finishInteractiveTransition()
//                    transitionContext.completeTransition(true)
//                    
//            })
//            
//        }else{
//            
//            let view = VICMAImageView(frame: finalFrame)
//            view.contentMode = .ScaleAspectFit
//            view.clipsToBounds = true
//            view.image = image
//            containerView.addSubview(view)
//            fromView.alpha = 0
//            UIView.animateWithDuration(0.2, animations: { () -> Void in
//                toView.alpha = 1
//                
//            })
//            UIView.animateWithDuration(0.5, animations: { () -> Void in
//                
//                view.contentMode = .ScaleAspectFill
//                view.frame = self.originFrame
//                
//                
//                }, completion: { (bool) -> Void in
//                    
//                    view.removeFromSuperview()
//                    transitionContext.finishInteractiveTransition()
//                    transitionContext.completeTransition(true)
//                    
//                    
//            })
//            
//        }
//    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning){
        let containerView = transitionContext.containerView()!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey )!

        if(presenting){
            let view = VICMAImageView(frame: originFrame)
            view.contentMode = .ScaleAspectFill
            view.clipsToBounds = true
            view.image = image
            
            
            toView.alpha = 0
            finalFrame = toView.frame
            containerView.addSubview(toView)
            containerView.addSubview(view)
            cell.photoView.alpha = 0
            
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                    fromView.alpha = 0
                    view.contentMode = .ScaleAspectFit
                    view.frame = self.finalFrame
                
                }, completion: { (bool) -> Void in
                    toView.alpha = 1
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        
                        view.removeFromSuperview()
                    })
                    
                    transitionContext.completeTransition(true)
                    fromView.alpha = 1

            })
            
        }else{

            let view = VICMAImageView(frame: finalFrame)
            view.contentMode = .ScaleAspectFit
            view.clipsToBounds = true
            view.image = image
            containerView.addSubview(toView)
            containerView.addSubview(view)
            
            fromView.alpha = 0
            toView.alpha = 0
            UIView.animateWithDuration(0.2, animations: { () -> Void in
               toView.alpha = 1

            })
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                
                view.contentMode = .ScaleAspectFill
                view.frame = self.originFrame
                
                
                }, completion: { (bool) -> Void in
                    
                    view.removeFromSuperview()
                    transitionContext.completeTransition(true)
                     self.cell.photoView.alpha = 1
                    
            })

        }
    }

}
