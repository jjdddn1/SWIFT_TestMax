//
//  QuestionContentViewController.swift
//  TestMax
//
//  Created by Huiyuan Ren on 16/2/26.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class QuestionContentViewController: UIViewController,UIPageViewControllerDataSource {
    var pageIndex = 0
    var answerIndex = 0
    {
        didSet{
            if(answerIndex == selectedAnswer){
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.answerBackground.alpha = 0.5
                })
            }else{
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.answerBackground.alpha = 0
                })
            }
        }
    }
    var totalNumber = 4
    var selectedAnswer = -1
        {
        didSet{
            if(answerIndex == selectedAnswer){
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.answerBackground.alpha = 0.5
                })
            }else{
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.answerBackground.alpha = 0
                })
            }
        }
    }
    var pageViewController : UIPageViewController?
    
    
    @IBOutlet weak var QuestionScrollView: UIScrollView!
    @IBOutlet weak var SelectButton: UIButton!
    @IBOutlet weak var AnswerBackgroundView: UIView!
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var A1Button: UIButton!
    @IBOutlet weak var A2Button: UIButton!
    @IBOutlet weak var A3Button: UIButton!
    @IBOutlet weak var A4Button: UIButton!
    
    @IBOutlet weak var answerBackground: UIView!
    @IBOutlet weak var IndicatorBar: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("\(pageIndex) did load")
        setUpUI()

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "QandA")
        do{
            let result = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            
            for item in result {
                if item.valueForKey("questionID") as! Int == pageIndex{
//                    print("Start setting answer")
                    selectedAnswer = item.valueForKey("selectedAnswer") as! Int
                    switch selectedAnswer{
                    case 0:
                        AnswerButtonPressed(A1Button)
                        print("0")
                        break
                    case 1:
                        AnswerButtonPressed(A1Button)
                        AnswerButtonPressed(A2Button)
                        print("1")
                        break
                    case 2:
                        AnswerButtonPressed(A2Button)
                        AnswerButtonPressed(A3Button)
                        print("2")
                        break
                    case 3:
                        AnswerButtonPressed(A3Button)
                        AnswerButtonPressed(A4Button)
                        print("3")
                        break
                    default:
                        break
                    }
                }
            }
        }catch{
            
        }

                // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        DataStruct.questionViewController.updateNavTitle(pageIndex)
//        print("\(pageIndex) did appear")
        

    }
    
    
    func setUpUI(){
        QuestionLabel.text = DataStruct.json[pageIndex]["Question"].string!
        
        var contentHeight : CGFloat = 0;
        for subView in self.QuestionScrollView.subviews {
            
            contentHeight += subView.bounds.height
        }
        QuestionScrollView.contentSize.height = contentHeight + 50
        QuestionScrollView.layer.borderWidth = 1
        QuestionScrollView.layer.borderColor = UIColor.blackColor().CGColor
        SelectButton.layer.cornerRadius = 3
        
        answerBackground.layer.borderColor = UIColor.orangeColor().CGColor
        answerBackground.layer.borderWidth = 1
        answerBackground.alpha = 0
        createPageViewController()
        
    }
    
    
    func createPageViewController(){
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
        
        self.pageViewController!.dataSource = self

        self.pageViewController!.view.frame = CGRectMake(0, self.view.bounds.size.height / 2 - 15, self.view.bounds.size.width, self.view.bounds.size.height / 2 - 45)
        let initialContenViewController = viewControllerAtIndex(0) as AnswerContentViewController
        
        let viewControllers = NSArray(object: initialContenViewController)
        
        self.pageViewController!.setViewControllers((viewControllers as! [AnswerContentViewController]), direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController!.didMoveToParentViewController(self)
    }
    
    @IBAction func AnswerButtonPressed(sender: UIButton) {
        cleanUpFont()
        sender.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15)
        sender.setTitleColor(UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1) , forState: UIControlState.Normal)
        
        setSelectedAnswerColor()
        let i = Int(sender.restorationIdentifier!)
        indicatorBarGoToPosition(i!)
        
        
        if(answerIndex < i! - 1 ){
            let viewControllers = NSArray(object: viewControllerAtIndex(i! - 1))
            
            self.pageViewController!.setViewControllers((viewControllers as! [AnswerContentViewController]), direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        }else if (answerIndex > i! - 1){
            let viewControllers = NSArray(object: viewControllerAtIndex(i! - 1))
            
            self.pageViewController!.setViewControllers((viewControllers as! [AnswerContentViewController]), direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
        }else{
            let viewControllers = NSArray(object: viewControllerAtIndex(i! - 1))
            
            self.pageViewController!.setViewControllers((viewControllers as! [AnswerContentViewController]), direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
    
    }
    
    func changeToSpecificAnswer(sender: UIButton) {
        cleanUpFont()
        sender.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 15)
        sender.setTitleColor(UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1) , forState: UIControlState.Normal)
        let i = Int(sender.restorationIdentifier!)
        indicatorBarGoToPosition(i!)
        setSelectedAnswerColor()

    }
    

    func indicatorBarGoToPosition(index : Int){
        let width = self.IndicatorBar.frame.width
        UIView.animateWithDuration(0.4, animations:{ () -> Void in
            self.IndicatorBar.transform = CGAffineTransformMakeTranslation(width * CGFloat(index - 1), 0)
            }, completion : nil)
    }
    
    func cleanUpFont(){
        A1Button.titleLabel?.font = UIFont(name:"HelveticaNeue", size: 15)
        A1Button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        A2Button.titleLabel?.font = UIFont(name:"HelveticaNeue", size: 15)
        A2Button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        A3Button.titleLabel?.font = UIFont(name:"HelveticaNeue", size: 15)
        A3Button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        A4Button.titleLabel?.font = UIFont(name:"HelveticaNeue", size: 15)
        A4Button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)

    }
    
    func setSelectedAnswerColor(){
        A1Button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        A2Button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        A3Button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        A4Button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)

        switch selectedAnswer {
        case 0:
            A1Button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            break;
        case 1:
            A2Button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            break;
        case 2:
            A3Button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            break;
        case 3:
            A4Button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
            break;
        default:
            break;
        }
    }
    
    @IBAction func selectButtonPressed(sender: UIButton) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("QandA", inManagedObjectContext: managedContext)
        if let item = checkQuestionExist() {
            managedContext.deleteObject(item)
        }
        
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        item.setValue(pageIndex, forKey: "questionID")
        item.setValue(answerIndex, forKey: "selectedAnswer")
        selectedAnswer = answerIndex
        setSelectedAnswerColor()
        print("Select Answer: \(answerIndex)")
        do{
            try managedContext.save()
            if countAnswerdQuestions() == DataStruct.json.count{
                DataStruct.questionViewController.SubmitButton.enabled = true
            }
        }catch{
            print("Error")
        }
    }
    
    /**
     check if the current question is answered from the database
     */
    func checkQuestionExist() -> NSManagedObject? {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let fetchRequest = NSFetchRequest(entityName: "QandA")
            do{
                let result = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]

                for item in result {
                    if item.valueForKey("questionID") as! Int == pageIndex{
                        return item
                    }
                }
            }catch{
                
            }
        return nil
    }
    
    
    /**
     check if the current question is answered from the database
     */
    func countAnswerdQuestions() -> Int {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "QandA")
        do{
            let result = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            return result.count
            
        }catch{
            return 0
        }
    }

    func viewControllerAtIndex(index : Int ) -> AnswerContentViewController {
        if(totalNumber == 0 || index >= totalNumber){
            return AnswerContentViewController()
        }else{
            let vc: AnswerContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AnswerContentViewController") as! AnswerContentViewController
            vc.pageIndex = index
            
            vc.questionIndex = pageIndex
            vc.beforeViewController = self
       
            return vc
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?{
        
        let vc = viewController as! AnswerContentViewController
        var index = vc.pageIndex as Int
        print("current Index before:" ,index)
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
        let vc = viewController as! AnswerContentViewController
        var index = vc.pageIndex as Int
        print("current Index after:" ,index)

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
