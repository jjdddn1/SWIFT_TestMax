//
//  AnswerViewController.swift
//  TestMax
//
//  Created by Huiyuan Ren on 16/2/26.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import SwiftyJSON

class AnswerContentViewController: UIViewController {
    
    var questionIndex = 0 // current displaying questions's index
    var pageIndex = 0 // current displaying answer's index
    
    var beforeViewController : QuestionContentViewController!
    
    @IBOutlet weak var scrollViewController: UIScrollView!
    
    @IBOutlet weak var AnswerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AnswerLabel.text = DataStruct.json[questionIndex]["Answer\(pageIndex + 1)"].string! // get the context of the answer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        beforeViewController.answerIndex = pageIndex
        
        switch pageIndex{
            case 0:
                beforeViewController.changeToSpecificAnswer(beforeViewController.A1Button)
            break
            case 1:
                beforeViewController.changeToSpecificAnswer(beforeViewController.A2Button)
            break
            case 2:
                beforeViewController.changeToSpecificAnswer(beforeViewController.A3Button)
            break
            case 3:
                beforeViewController.changeToSpecificAnswer(beforeViewController.A4Button)
            break
            default:
            break
            
            
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
