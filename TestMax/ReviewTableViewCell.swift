//
//  ReviewTableViewCell.swift
//  TestMax
//
//  Created by Huiyuan Ren on 16/2/27.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    var cellIndex = 0{
        didSet{
            QuestionIndex.text = "Q\(cellIndex + 1)"
            QuestionLabel.text = DataStruct.json[cellIndex]["Question"].string!
        }
    }
    
    var selectedAnswer = 0{
        didSet{
            CorrectLabel.text = (selectedAnswer + 1 == DataStruct.json[cellIndex]["CorrectAnswer"].int!) ? "Right" : "Wrong"
            self.backgroundColor = (selectedAnswer + 1 == DataStruct.json[cellIndex]["CorrectAnswer"].int!) ? UIColor(red: 102/255, green: 255/255, blue: 102/255, alpha: 1) : UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1)
        }
    }
    
    @IBOutlet weak var QuestionIndex: UILabel!
    @IBOutlet weak var QuestionLabel: UILabel!
    @IBOutlet weak var CorrectLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
