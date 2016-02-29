//
//  PieChartViewController.swift
//  TestMax
//
//  Created by Huiyuan Ren on 16/2/29.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import Charts
import Spring

class PieChartViewController: UIViewController {

    var correct : Double = 0.0
    var wrong : Double = 0.0


    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var springBackGroundView: SpringView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChartView.layer.shadowColor = UIColor.blackColor().CGColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        let correctness = ["Wrong", "Correct"]
        let numbers = [wrong , correct]
        setChart(correctness, values: numbers)
    }
    
    /* Create a pie chart and start the animation */
    func setChart(dataPoints: [String], values: [Double]) {
        pieChartView.descriptionText = "Test Result"
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        var colors: [UIColor] = []
        
        colors.append(UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1) )
        colors.append(UIColor(red: 102/255, green: 255/255, blue: 102/255, alpha: 1) )
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Numbers")
        pieChartDataSet.colors = colors
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        
        // set number format
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.NoStyle
        formatter.maximumFractionDigits = 0
        pieChartData.setValueFormatter(formatter)
        
        pieChartView.data = pieChartData
        pieChartView.animate(xAxisDuration: 1, easingOption: ChartEasingOption.EaseOutBack)
    }

    /* Dismiss the chart */
    @IBAction func ButtonPressed(sender: UIButton) {
        springBackGroundView.animation = "zoomOut"
        pieChartView.animate(yAxisDuration: 0.5, easingOption: .EaseOutBack)
        springBackGroundView.animate()
        self.dismissViewControllerAnimated(true, completion: nil)
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
