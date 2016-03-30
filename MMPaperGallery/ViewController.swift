//
//  ViewController.swift
//  MMPaperGallery
//
//  Created by Mukesh on 29/03/16.
//  Copyright © 2016 Mad Apps. All rights reserved.
//

import UIKit




class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,ScrollDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var previewArr = NSMutableArray()
     let transition = CustomAnimator()
    let interactor = Interactor()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        previewArr = ["Tower" , "London_Tower_Bridge_Sunset_Cityscape_Panorama"]
        tableView.registerNib(UINib(nibName: "ImageTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clearColor()
        setupHeader()

    }
    
    func setupHeader(){
        
        let header = UIView(frame: CGRectMake(0,0,CGRectGetWidth(view.frame),250))
        let square = UIView(frame: CGRectMake(30 ,20 , 100 , 100))
        square.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        let line1 = UIView(frame: CGRectMake(30 ,140 , CGRectGetWidth(view.frame)-60 , 8))
        line1.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        let line2 = UIView(frame: CGRectMake(30 ,170 , CGRectGetWidth(view.frame)-60 , 8))
        line2.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        let line3 = UIView(frame: CGRectMake(30 ,200 , CGRectGetWidth(view.frame)-60 , 8))
        line3.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        let line4 = UIView(frame: CGRectMake(30 ,230 , CGRectGetWidth(view.frame)-60 , 8))
        line4.backgroundColor =  UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        header.addSubview(square)
        header.addSubview(line1)
        header.addSubview(line2)
        header.addSubview(line3)
        header.addSubview(line4)
        tableView.tableHeaderView = header

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 310
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell:ImageTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as? ImageTableViewCell{
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = .None
            if(indexPath.row % 2 == 0){
                //                 cell.configureForURL(previewArr[0] as! String)
                cell.photoView.image = UIImage(named: previewArr[0] as! String)
            }else{
                //                 cell.configureForURL(previewArr[1] as! String)
                cell.photoView.image = UIImage(named: previewArr[1] as! String)
            }
            

            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //present details view controller
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("detail") as! PreviewImagesController
            detailVC.currentIndexPath = indexPath
            detailVC.preveiewdelegate = self
            detailVC.interactor = self.interactor
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? ImageTableViewCell
            
            let cellframe = tableView.rectForRowAtIndexPath(indexPath)
            let cellframeinwindow = tableView.convertRect(cellframe, toView: tableView.superview)
            let imageframe = CGRectOffset((cell?.photoView.frame)!, cellframeinwindow.origin.x, cellframeinwindow.origin.y)
            
            self.transition.cell = cell
            self.transition.originFrame = imageframe
            self.transition.image = (cell?.photoView.image)!
            detailVC.transitioningDelegate = self

            self.presentViewController(detailVC, animated: true, completion: nil)
        })


    }
    
    //MARK: - Deleagte
    func scrollToIndexPath(indexPath : NSIndexPath){
        
        
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .None, animated: false)

        //Maintain the scroll
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? ImageTableViewCell
        let cellframe = tableView.rectForRowAtIndexPath(indexPath)
        let cellframeinwindow = tableView.convertRect(cellframe, toView: tableView.superview)
        let imageframe = CGRectOffset((cell?.photoView.frame)!, cellframeinwindow.origin.x, cellframeinwindow.origin.y)
        self.transition.originFrame = imageframe
        self.transition.image = (cell?.photoView.image)!
        self.transition.cell.photoView.alpha = 1
        self.transition.cell = cell
        
    }


}

extension ViewController: UIViewControllerTransitioningDelegate  {
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            
//            transition.originFrame = selectedImage!.superview!.convertRect(selectedImage!.frame, toView: nil)
            transition.presenting = true
            
            return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }

}




