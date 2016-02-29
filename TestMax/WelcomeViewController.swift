//
//  ViewController.swift
//  TestMax
//
//  Created by Huiyuan Ren on 16/2/26.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import Alamofire

class WelcomeViewController: UIViewController {
    var completeNumber = 0 // number of completed questions

    @IBOutlet weak var TotalQuestionLabel: UILabel!
    @IBOutlet weak var CompleteQuestionLabel: UILabel!
    
    @IBOutlet weak var ReviewButton: UIButton!
    @IBOutlet weak var StartButton: UIButton!
    @IBOutlet weak var ResetButton: UIButton!
    
    @IBOutlet weak var LogoImage: UIImageView!
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var BackgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the image
        loadingImage.image = UIImage.gifWithName("loading2")
        BackgroundImage.image = UIImage.gifWithName("Beans")

// For local test purpose
//      DataStruct.json = JSON(data: NSData(contentsOfURL: url)! )
//      DataStruct.json = JSON(data: NSData(contentsOfFile: "/Users/huiyuanren/Code/TestMax/TestMax/Questions.json")! )
//        print(DataStruct.json.count)
//      DataStruct.json = JSON(data: data!)

        
        self.setOriginState()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // request for the questions' JSON file
        let url = NSURL(string: "http://cs-server.usc.edu:32962/Questions.json")!
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                DataStruct.json = JSON(response.result.value!)
                self.loadingImage.hidden = true
                self.checkSavedData()

                // Handle the short cut item
                switch DataStruct.shortcutDirection{
                    
                case 1:
                    DataStruct.shortcutDirection = 0
                    self.startButtonPressed(self.StartButton)
                case 2:
                    DataStruct.shortcutDirection = 0
                    self.reviewButtonPressed(self.ReviewButton)
                default:
                    break
                    
                }
                DataStruct.loaded = true
                self.launchAnimation()
                break
            case .Failure(_):
                NSLog("Failure")
                break
            }
        }

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }

    // clean up the answered questions and start a new round
    func cleanUpSavedData(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "QandA")
        do{
            let result = try managedContext.executeFetchRequest(fetchRequest)
            for  item in result {
                managedContext.deleteObject(item as! NSManagedObject)
            }
        }catch{
            print("Clean Saved Data Error")
        }
        startButtonPressed(StartButton)
    }
    
    // Check how many questions have been answered, set review button outlook
    func checkSavedData(){
        TotalQuestionLabel.text = "Total: \(DataStruct.json.count)"

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "QandA")
        do{
            let result = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            CompleteQuestionLabel.text = "Completed: \(result.count)"
            completeNumber = result.count
            if(result.count == 0){
                ReviewButton.enabled = false
                ReviewButton.layer.backgroundColor = UIColor.lightGrayColor().CGColor
                ResetButton.hidden = true
                StartButton.setTitle("Start", forState: .Normal)
            }else{
                ReviewButton.enabled = true
                ReviewButton.layer.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 0.8).CGColor
                ResetButton.hidden = false
                StartButton.setTitle("Resume", forState: .Normal)

            }
        }catch{
            print("Check Saved Data Error")
        }
    }
    
    /**
     The animation after launching
     */
    func launchAnimation() {
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.LogoImage.transform = CGAffineTransformMakeTranslation(0, 0)
                self.ReviewButton.transform = CGAffineTransformMakeTranslation(0, 0)
                self.StartButton.transform = CGAffineTransformMakeTranslation(0, 0)
                self.ResetButton.transform = CGAffineTransformMakeTranslation(0, 0)
            
                self.LogoImage.alpha = 1
                self.TotalQuestionLabel.alpha = 1
                self.CompleteQuestionLabel.alpha = 1
                self.ReviewButton.alpha = 1
                self.StartButton.alpha = 1
                self.ResetButton.alpha = 1
            }, completion:  nil)
    }
    
    /* Perform the animation when leaving the welcome page, then navigate to the specific page */
    func quitAnimation(index : Int){
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            // move button away
            self.LogoImage.transform = CGAffineTransformMakeTranslation(0, -50)
            self.ReviewButton.transform = CGAffineTransformMakeTranslation(0, 50)
            self.StartButton.transform = CGAffineTransformMakeTranslation(0, 50)
            self.ResetButton.transform = CGAffineTransformMakeTranslation(0, 50)
            
            self.LogoImage.alpha = 0
            self.TotalQuestionLabel.alpha = 0
            self.CompleteQuestionLabel.alpha = 0
            self.ReviewButton.alpha = 0
            self.StartButton.alpha = 0
            self.ResetButton.alpha = 0
            
            }){ (Bool) -> Void in
                
                // navigate to the questions page
                if(index == 1){
                    self.performSegueWithIdentifier("startSegue", sender: self)
                }
                // navigate to the review page
                else{
                    self.performSegueWithIdentifier("reviewSegue", sender: self)
                }
            }
    }
    
    /**
     set the orgin outlook of all the label & buttons
     */
    func setOriginState(){
        ReviewButton.layer.borderColor = UIColor.whiteColor().CGColor
        StartButton.layer.borderColor = UIColor.whiteColor().CGColor
        ResetButton.layer.borderColor = UIColor.whiteColor().CGColor
        ReviewButton.layer.borderWidth = 0.5
        StartButton.layer.borderWidth = 0.5
        ReviewButton.layer.cornerRadius = 5
        StartButton.layer.cornerRadius = 5
        ResetButton.layer.borderWidth = 0.5
        ResetButton.layer.cornerRadius = 5
        
        
        LogoImage.transform = CGAffineTransformMakeTranslation(0, -50)
        ReviewButton.transform = CGAffineTransformMakeTranslation(0, 50)
        StartButton.transform = CGAffineTransformMakeTranslation(0, 50)
        ResetButton.transform = CGAffineTransformMakeTranslation(0, 50)
        
        LogoImage.alpha = 0
        TotalQuestionLabel.alpha = 0
        CompleteQuestionLabel.alpha = 0
        ReviewButton.alpha = 0
        StartButton.alpha = 0
        ResetButton.alpha = 0
    }

    @IBAction func resetButtonPressed(sender: UIButton) {
        showAlert()
    }
    
    @IBAction func startButtonPressed(sender: UIButton) {
        quitAnimation(1)
    }
    
    @IBAction func reviewButtonPressed(sender: UIButton) {
        quitAnimation(2)

    }
    
    /*Alert the user the consequence to start a new test and start it*/
    func showAlert(){
        let alertController = UIAlertController(title: "Start a new round", message: "Start a new test will clean up everything you've answered, continue?", preferredStyle: .Alert)
        let confirm = UIAlertAction(title: "Continue", style: .Default) { (_) -> Void in
            self.cleanUpSavedData()

        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(cancel)
        alertController.addAction(confirm)

        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "reviewSegue"){
            let des = segue.destinationViewController as! ReviewViewController
            des.totalNumber = completeNumber
        }else if segue.identifier == "startSegue"{
            let des = segue.destinationViewController as! QuestionViewController
            des.BeforeViewControllerType = .Welcome
        }
    }
}

