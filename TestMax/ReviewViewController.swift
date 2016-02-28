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
    var totalNumber = 0
    var Dictionary : [(Int, Int)] = []
    var currentSelectedCell = 0
    
    @IBOutlet weak var NavigationItem: UINavigationItem!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        //tableView.dataSource = self

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
        
    }

    func abstractData(){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "QandA")
        let sortDescrpitor = NSSortDescriptor(key: "questionID", ascending: true,selector: Selector("localizedStandardCompare:"))
        fetchRequest.sortDescriptors = [sortDescrpitor]
        do{
            let result = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            Dictionary.removeAll()
            for item in result{
                let tmp :(Int, Int) = (item.valueForKey("questionID") as! Int, item.valueForKey("selectedAnswer") as! Int)
                Dictionary.append(tmp)
            }
            
        }catch{
            
        }
        totalNumber = Dictionary.count
        tableView.reloadData()
        print(Dictionary)
        
    }
    
    func setNav(){
        let item = UIBarButtonItem(image: UIImage(named: "CircledLeft"), style: UIBarButtonItemStyle.Plain , target: self, action: "backToPrevious")
        
        NavigationItem.leftBarButtonItem = item;
        NavigationItem.title = "Review"
    }
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
        self.performSegueWithIdentifier("showQuestionSegue", sender: self)
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
            print(currentSelectedCell)
        }
    }

}
