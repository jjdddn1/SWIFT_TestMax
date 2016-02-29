//
//  QuestionViewController.swift
//  TestMax
//
//  Created by Huiyuan Ren on 16/2/26.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import SwiftyJSON


class QuestionViewController: UIViewController, UIPageViewControllerDataSource {
    

    var totalNumber = 100
    var currentQuestionNumber = 0{
        didSet{
            if(currentQuestionNumber < 0){
                currentQuestionNumber = totalNumber - 1
            }else if(currentQuestionNumber >= totalNumber){
                currentQuestionNumber = 0
            }
            print("CurrentNumber Set : \(currentQuestionNumber)")
        }
    }
    var pageViewController : UIPageViewController?
    
    enum ViewControllerType {
        case Welcome
        case Review
    }
    
    var BeforeViewControllerType : ViewControllerType = .Welcome
    var BeforeViewController: ReviewViewController!
    
    @IBOutlet weak var NavigationItem: UINavigationItem!
    
    @IBOutlet weak var GoLeftButton: UIButton!
    
    @IBOutlet weak var GoRightButton: UIButton!
    
    @IBOutlet weak var SubmitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch BeforeViewControllerType {
            case .Welcome:
            break
            case .Review:
                SubmitButton.hidden = true
            break
        }
        totalNumber = DataStruct.json.count
        
        DataStruct.questionViewController = self
        
        GoLeftButton.layer.borderColor = UIColor(red: 128/255, green: 0, blue: 255/255, alpha: 1).CGColor
        GoLeftButton.layer.borderWidth = 1
        GoRightButton .layer.borderColor = UIColor(red: 128/255, green: 0, blue: 255/255, alpha: 1).CGColor

        GoRightButton.layer.borderWidth = 1
        setNav()
        createPageViewController()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func setNav(){
        let item = UIBarButtonItem(image: UIImage(named: "CircledLeft"), style: UIBarButtonItemStyle.Plain , target: self, action: "backToPrevious")
        
        NavigationItem.leftBarButtonItem = item;
        NavigationItem.title = "\(currentQuestionNumber + 1) / 22"
        NavigationItem.rightBarButtonItem?.enabled = false
    }
    
    func backToPrevious(){
        switch (BeforeViewControllerType){
        case .Review:
            BeforeViewController.abstractData()
        case .Welcome:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func GoLeftButtonPressed(sender: UIButton) {
        --currentQuestionNumber
        let initialContenViewController = viewControllerAtIndex(currentQuestionNumber) as QuestionContentViewController
        
        let viewControllers = NSArray(object: initialContenViewController)
        self.pageViewController!.setViewControllers((viewControllers as! [QuestionContentViewController]), direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
    }

    @IBAction func GoRightButtonPressed(sender: UIButton) {
        ++currentQuestionNumber
        let initialContenViewController = viewControllerAtIndex(currentQuestionNumber) as QuestionContentViewController
        
        let viewControllers = NSArray(object: initialContenViewController)
        self.pageViewController!.setViewControllers((viewControllers as! [QuestionContentViewController]), direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonPressed(sender: UIButton) {
        let alertController = UIAlertController(title: "Submit", message: "Submit successfully! Please check the result in \"Review\" section", preferredStyle: .Alert)
        
        let cancel = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Cancel, handler: {
            (_) in
            self.dismissViewControllerAnimated(true, completion:  nil)

            }
        )
        
        alertController.addAction(cancel)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    
    func createPageViewController(){
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
        
        self.pageViewController!.dataSource = self
        let initialContenViewController = viewControllerAtIndex(currentQuestionNumber) as QuestionContentViewController
        
        let viewControllers = NSArray(object: initialContenViewController)
        
        
        self.pageViewController!.setViewControllers((viewControllers as! [QuestionContentViewController]), direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)

        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.didMoveToParentViewController(self)
        self.pageViewController!.view.frame = CGRectMake(0, 80, self.view.frame.maxX, self.view.frame.maxY - 120)
    }
    
    func updateNavTitle(index: Int){
        NavigationItem.title = "\(index + 1) / \(totalNumber)"
        currentQuestionNumber = index
    }
    
    func viewControllerAtIndex(index : Int ) -> QuestionContentViewController {
        if(totalNumber == 0 || index >= totalNumber){
            return QuestionContentViewController()
        }else{
            let vc: QuestionContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("QuestionContentViewController") as! QuestionContentViewController
            vc.pageIndex = index
            return vc
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?{
        
        let vc = viewController as! QuestionContentViewController
        var index = vc.pageIndex as Int
        if( index == NSNotFound){
            return nil
        }else if(index == 0){
            return self.viewControllerAtIndex(totalNumber - 1)
        }
            
        else{
            return self.viewControllerAtIndex(--index)
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
//        return self.pageImages.count
        return totalNumber
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?{
        let vc = viewController as! QuestionContentViewController
        var index = vc.pageIndex as Int
        if(  index == NSNotFound){
            return nil
        }else if (index >= (totalNumber - 1)){
            return self.viewControllerAtIndex(0)
            
        }else{
            return self.viewControllerAtIndex(++index)
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
