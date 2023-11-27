//
//  RadarChartViewController.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

#if canImport(UIKit)
    import UIKit
#endif
import DGCharts

class RadarChartViewController: UIViewController {

    var chartView = RadarChartView()
    
    let activities = ["抬主轮时空速asdasd", "抬轮空速与VR差值asdasdasdasd", "起飞滚转角asdasd", "抬主轮时pitch值as", "抬主轮时最大俯仰变化率", "抬主轮时俯仰变化率", "抬主轮时地速asdsadsad"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        //创建折线图组件对象
        chartView.backgroundColor = .orange
        chartView.webLineWidth = 1
        chartView.innerWebLineWidth = 1
        chartView.rotationEnabled = false
//        chartView.backgroundColor = .purple
        chartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        if UIDevice.current.userInterfaceIdiom == .pad {
            chartView.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width,
                                     height: 400)
        } else {
            chartView.frame = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width,
                                     height: 250)
        }
        
//        chartView.backgroundColor = .orange.withAlphaComponent(0.4)
        self.view.addSubview(chartView)
        //维度标签文字
        chartView.xAxis.valueFormatter = self
        let legend = chartView.legend
        legend.verticalAlignment = .top
        legend.horizontalAlignment = .right
        legend.xOffset = -40
        legend.formLineWidth = 10
        legend.formSize = 18
        legend.form = .line
//        let marker = RadarMarkerView.viewFromXib()!
//        marker.chartView = chartView
//        chartView.marker = marker
        
        //最小、最大刻度值
//        let yAxis = chartView.yAxis
//        yAxis.drawLabelsEnabled = false //不显示刻度值
//        yAxis.labelFont = .systemFont(ofSize: 10)
//        yAxis.axisMinimum = 0
//        yAxis.axisMaximum = 4
//        yAxis.labelCount = 4
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.labelTextColor = .white

        
        let data1: [Double] = [5, 4, 5, 5, 5, 4, 5]
        let data2: [Double] = [5, 5, 0, 5, 5, 5, 5]
        let entries1 = data1.map({RadarChartDataEntry(value: $0)})
        let entries2 = data2.map({RadarChartDataEntry(value: $0)})
        
        //生成两组数据
        let chartDataSet1 = RadarChartDataSet(entries: entries1, label: "个人")
        chartDataSet1.setColor(UIColor(red: 188/255.0, green: 98/255.0, blue: 88/255.0, alpha: 1))
        chartDataSet1.lineWidth = 1.5
        let chartDataSet2 = RadarChartDataSet(entries: entries2, label: "机队")
        chartDataSet2.setColor(UIColor(red: 55/255.0, green: 68/255.0, blue: 82/255.0, alpha: 1))
        chartDataSet2.lineWidth = 1.5
        //目前雷达图包括2组数据
        let chartData = RadarChartData(dataSets: [chartDataSet1, chartDataSet2])
        chartData.setDrawValues(false) //不显示值标签
        chartDataSet1.drawHighlightCircleEnabled = true //选中后显示圆圈
        chartDataSet1.setDrawHighlightIndicators(false) //选中后不显示十字线
        
        chartDataSet2.drawHighlightCircleEnabled = true //选中后显示圆圈
        chartDataSet2.setDrawHighlightIndicators(false) //选中后不显示十字线
        
        /// 重置y轴最大值和最小值
        chartView.yAxis.resetCustomAxisMax()
        let yAxis = chartView.yAxis
        yAxis.drawLabelsEnabled = false //不显示刻度值
        yAxis.labelFont = .systemFont(ofSize: 10)
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 4
        
        //设置雷达图数据
        chartView.data = chartData
        chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
    }

    
    func listTitle() -> [String] {
        var list: [String] = []
        activities.forEach { str in
            var s = ""
            if str.count > 8 {
                s = "\(str.prefix(8))..."
            } else {
                s = str
            }
            list.append(s)
        }
        return list
    }
    
    
    
    func setChartData() {
        return
        let data1: [Double] = [5, 4, 5, 5, 5, 4, 5]
        let data2: [Double] = [5, 5, 0, 5, 5, 5, 5]
        let entries1 = data1.map({RadarChartDataEntry(value: $0)})
        let entries2 = data2.map({RadarChartDataEntry(value: $0)})
        
        //生成两组数据
        let chartDataSet1 = RadarChartDataSet(entries: entries1, label: "个人")
        chartDataSet1.setColor(UIColor(red: 188/255.0, green: 98/255.0, blue: 88/255.0, alpha: 1))
        chartDataSet1.lineWidth = 1.5
        let chartDataSet2 = RadarChartDataSet(entries: entries2, label: "机队")
        chartDataSet2.setColor(UIColor(red: 55/255.0, green: 68/255.0, blue: 82/255.0, alpha: 1))
        chartDataSet2.lineWidth = 1.5
        //目前雷达图包括2组数据
        let chartData = RadarChartData(dataSets: [chartDataSet1, chartDataSet2])
        chartData.setDrawValues(false) //不显示值标签
        chartDataSet1.drawHighlightCircleEnabled = true //选中后显示圆圈
        chartDataSet1.setDrawHighlightIndicators(false) //选中后不显示十字线
        
        chartDataSet2.drawHighlightCircleEnabled = true //选中后显示圆圈
        chartDataSet2.setDrawHighlightIndicators(false) //选中后不显示十字线
        
        //设置雷达图数据
        chartView.data = chartData
    }
    
    func optionTapped(_ option: Option) {}
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        chartView.center = self.view.center
    }
}

extension RadarChartViewController: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return activities[Int(value) % activities.count]
    }
}

