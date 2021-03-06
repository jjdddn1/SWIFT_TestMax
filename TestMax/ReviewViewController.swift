//
//  ReviewViewController.swift
//  TestMax
//
//  Created by Huiyuan Ren on 16/2/27.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import CoreData

class ReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var totalNumber = 0 // Total number of answered questions
    var correctNumber = 0 // Number of answers that are correct
    var Dictionary : [(Int, Int)] = [] // a dictionary to store the user's answer
    var currentSelectedCell = 0 // The index of the cell that user clicked
    var cells : [UITableViewCell]!
    
    @IBOutlet weak var NavigationItem: UINavigationItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {

        super.viewDidLoad()

        setNav()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        abstractData()
        setTableBegining()
    }

    override func viewDidAppear(animated: Bool) {
        tableViewAnimationStart()
    }
    func setTableBegining() {
        cells = tableView.visibleCells as [UITableViewCell]
        for cell in cells{
            cell.alpha = 0
        }
    }
    
    /* Perfrom the animation loading the table */
    func tableViewAnimationStart(){
        let diff = 0.05
        cells = tableView.visibleCells as [UITableViewCell]
        var tableHeight : CGFloat = 0
        for cell in cells{
            tableHeight += cell.frame.size.height
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        for i in 0..<cells.count{
            
            let cell = cells[i] as UITableViewCell
            cell.layer.hidden = false
            
            let delay = diff * Double(i - 1)
            UIView.animateWithDuration(0.3, delay: delay, options: UIViewAnimationOptions.CurveEaseInOut, animations:{ () -> Void in
                cell.transform = CGAffineTransformMakeTranslation(0, 0)
                cell.alpha = 1
                }, completion : nil)
            
        }
    }
    
    /* zoom out the cell */
    func cellAnimationBegin(indexPath: NSIndexPath){
        let cell  = tableView.cellForRowAtIndexPath(indexPath)
        let originState = cell!.transform
        UIView.animateWithDuration(10, animations:{ () -> Void in
            
            cell!.transform = CGAffineTransformScale(cell!.transform, 1, 2)
            cell!.alpha = 0
            }) { (Bool) -> Void in
                cell!.transform = CGAffineTransformScale(originState, 1, 1)
                cell!.alpha = 1
        }
    }
    

    /* Check the database for the user's answer and count the correct ones */
    func abstractData(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "QandA")
        
        // sort the database first
        let sortDescrpitor = NSSortDescriptor(key: "questionID", ascending: true,selector: Selector("localizedStandardCompare:"))
        fetchRequest.sortDescriptors = [sortDescrpitor]
        do{
            let result = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            Dictionary.removeAll()
            correctNumber = 0
            for item in result{
                let tmp :(Int, Int) = (item.valueForKey("questionID") as! Int, item.valueForKey("selectedAnswer") as! Int)
                Dictionary.append(tmp) // store the answer's information in the dictionary
                
                if(tmp.1 + 1 == DataStruct.json[tmp.0]["CorrectAnswer"].int!){
                    correctNumber++
                }
            }
            
        }catch{
            
        }
        totalNumber = Dictionary.count
        tableView.reloadData()
//        print(Dictionary)
        
    }
    
    /* Set up the navigation bar */
    func setNav(){
        let item = UIBarButtonItem(image: UIImage(named: "CircledLeft"), style: UIBarButtonItemStyle.Plain , target: self, action: "backToPrevious")
        
        NavigationItem.leftBarButtonItem = item;
        NavigationItem.title = "Review"
    }
    
    /* go back to previous page */
    func backToPrevious(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return totalNumber
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ReviewTableViewCell
        cell.cellIndex = Dictionary[indexPath.row].0 as Int
        print("Cell Index:", cell.cellIndex )
        cell.selectedAnswer = Dictionary[indexPath.row].1 as Int
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell  = tableView.cellForRowAtIndexPath(indexPath)
        cell!.contentView.backgroundColor = UIColor.lightGrayColor()
        
    }
    
    func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell  = tableView.cellForRowAtIndexPath(indexPath)
        cell!.contentView.backgroundColor = .clearColor()
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentSelectedCell = Dictionary[indexPath.row].0
//        cellAnimationBegin(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.beginUpdates()
        tableView.endUpdates()
//        self.performSegueWithIdentifier("showQuestionSegue", sender: self)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.indexPathForSelectedRow == indexPath{
            return 1000
        }
        return 60
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "showQuestionSegue"){
            let des = segue.destinationViewController as! QuestionViewController
            des.currentQuestionNumber = currentSelectedCell
            des.BeforeViewControllerType = .Review
            des.BeforeViewController = self
            print(currentSelectedCell)
        }else if segue.identifier == "chartSegue"{
            let des = segue.destinationViewController as! PieChartViewController
            des.correct = Double(correctNumber)
            des.wrong = Double(totalNumber - correctNumber)
        }
    }

}
