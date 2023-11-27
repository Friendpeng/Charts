//
//  XAxisRendererRadarChart.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

public enum ItemPositionType {
    case center
    case left
    case right
}

open class XAxisRendererRadarChart: XAxisRenderer
{
    @objc open weak var chart: RadarChartView?
    
    @objc public init(viewPortHandler: ViewPortHandler, axis: XAxis, chart: RadarChartView)
    {
        super.init(viewPortHandler: viewPortHandler, axis: axis, transformer: nil)
        
        self.chart = chart
    }
    
//    open override func renderAxisLabels(context: CGContext)
//    {
//        guard
//            let chart = chart,
//            axis.isEnabled,
//            axis.isDrawLabelsEnabled
//            else { return }
//
//        let labelFont = axis.labelFont
//        let labelTextColor = axis.labelTextColor
//        let labelRotationAngleRadians = axis.labelRotationAngle.RAD2DEG
//        let drawLabelAnchor = CGPoint(x: 0.5, y: 0.25)
//
//        let sliceangle = chart.sliceAngle
//
//        // calculate the factor that is needed for transforming the value to pixels
//        let factor = chart.factor
//
//        let center = chart.centerOffsets
//
//        for i in 0..<(chart.data?.maxEntryCountSet?.entryCount ?? 0)
//        {
//            let label = axis.valueFormatter?.stringForValue(Double(i), axis: axis) ?? ""
//            let angle = (sliceangle * CGFloat(i) + chart.rotationAngle).truncatingRemainder(dividingBy: 360.0)
//            let p = center.moving(distance: CGFloat(chart.yRange) * factor + axis.labelRotatedWidth / 2.0, atAngle: angle)
//
//            drawLabel(context: context,
//                      formattedLabel: label,
//                      x: p.x,
//                      y: p.y - axis.labelRotatedHeight / 2.0,
//                      attributes: [.font: labelFont, .foregroundColor: labelTextColor],
//                      anchor: drawLabelAnchor,
//                      angleRadians: labelRotationAngleRadians)
//        }
//    }
    /// 自定义标签到中心点的距离
    open override func renderAxisLabels(context: CGContext)
    {
        guard
            let chart = chart,
            axis.isEnabled,
            axis.isDrawLabelsEnabled
            else { return }

        let labelFont = axis.labelFont
        let labelTextColor = axis.labelTextColor
        let labelRotationAngleRadians = axis.labelRotationAngle.RAD2DEG
        let drawLabelAnchor = CGPoint(x: 0.5, y: 0.25)
        
        let sliceangle = chart.sliceAngle
        
        // calculate the factor that is needed for transforming the value to pixels
        let factor = chart.factor
        
        let center = chart.centerOffsets
        let isEvenNumber = ((chart.data?.maxEntryCountSet?.entryCount ?? 0) % 2 == 0) ? true : false
        let oneHalf = (chart.data?.maxEntryCountSet?.entryCount ?? 0) / 2
        for i in 0..<(chart.data?.maxEntryCountSet?.entryCount ?? 0)
        {
            let label = axis.valueFormatter?.stringForValue(Double(i), axis: axis) ?? ""
            let attributes: [NSAttributedString.Key: Any] = [.font: labelFont, .foregroundColor: labelTextColor]
            let size = label.size(withAttributes: attributes)
            let angle = (sliceangle * CGFloat(i) + chart.rotationAngle).truncatingRemainder(dividingBy: 360.0)
            // 原始代码
            var distance = CGFloat(chart.yRange) * factor + axis.labelRotatedWidth / 2.0
            // 自定义半径
            distance = CGFloat(chart.yRange) * factor + 14
            let p = center.moving(distance: distance, atAngle: angle)
            var px: CGFloat = 0
            var x: CGFloat = 0
            var positionType = ItemPositionType.center
            // 偶数时有两个在中间
            if isEvenNumber {
                if i == 0 || i == oneHalf {
                    px = 0 //中间
                } else if i < oneHalf {
                    px = size.width / 2 // 左边
                } else {
                    px = -(size.width / 2) // 右边
                }
            } else {
                if i == 0 {
                    px = 0 //中间
                } else if i <= oneHalf {
                    px = size.width / 2 // 左边
                } else {
                    px = -(size.width / 2) // 右边
                }
            }
            if px == 0 {
                positionType = .center
            } else if px > 0 {
                positionType = .right
            } else {
                positionType = .left
            }
            x = p.x + px
            drawLabel(context: context,
                      formattedLabel: label,
                      x: x,
                      y: p.y - axis.labelRotatedHeight / 2.0,
                      attributes: attributes,
                      anchor: drawLabelAnchor,
                      angleRadians: labelRotationAngleRadians,
                      chartPoint: p,
                      chartWidth: chart.viewPortHandler.chartWidth,
                      positionType: positionType)
        }
    }
    
    open func drawLabel(
        context: CGContext,
        formattedLabel: String,
        x: CGFloat,
        y: CGFloat,
        attributes: [NSAttributedString.Key : Any],
        anchor: CGPoint,
        angleRadians: CGFloat,
        chartPoint: CGPoint,
        chartWidth: CGFloat,
        positionType: ItemPositionType)
    {
        context.drawText(formattedLabel,
                         at: CGPoint(x: x, y: y),
                         anchor: anchor,
                         angleRadians: angleRadians,
                         attributes: attributes,
                         chartPoint: chartPoint,
                         chartWidth: chartWidth,
                         positionType: positionType)
    }
    
    open override func renderLimitLines(context: CGContext)
    {
        /// XAxis LimitLines on RadarChart not yet supported.
    }
}
