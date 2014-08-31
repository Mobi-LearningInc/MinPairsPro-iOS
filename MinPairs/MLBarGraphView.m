//
//  MLBarGraphView.m
//  MinPairs
//
//  Created by Brandon on 2014-05-20.
//  Copyright (c) 2014 Brandon. All rights reserved.
//

#import "MLBarGraphView.h"

@interface MLBarGraphView()
@property (nonatomic, strong) CPTXYGraph* graph;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) MLMutableSortedDictionary* graphData;
@end

@implementation MLBarGraphView

- (void) setGraphData:(MLMutableSortedDictionary*)data
{
    _graphData = data;
}

- (void) setGraphTitle:(NSString*)title
{
    _title = [NSString stringWithFormat: @"Avg. Score per Day (%@)", title];
}

- (void) reload
{
    /** Reload graph title & Axis **/
    
    const float xMin = 0.0f;
    const float xMax = 4.0f;
    const float barWidth = 0.70f;
    
    [[self graph] setTitle: [self title]];
    CPTXYAxisSet* axisSet = (CPTXYAxisSet*)[[self graph] axisSet];
    CPTXYAxis* xAxis = [axisSet xAxis];
    
    NSArray* dates = [[self graphData] allKeys];
    
    float xPosition = 0.70f / 2.0f;
    NSMutableArray* xLabels = [NSMutableArray array];
    
    for (NSString* date in dates)
    {
        CPTAxisLabel* xlabel = [[CPTAxisLabel alloc] initWithText: date textStyle: [xAxis labelTextStyle]];
        [xlabel setTickLocation: [[NSNumber numberWithFloat: xPosition] decimalValue]];
        [xlabel setOffset: [xAxis labelOffset] + [xAxis majorTickLength]];
        [xlabel setRotation: M_PI / 4.0f];
        [xLabels addObject: xlabel];
        ++xPosition;
    }
    
    [xAxis setAxisLabels: [NSSet setWithArray: xLabels]];
    
    
    /** Reset plot space to adjust scrolling limitation to the new data range **/
    
    CPTXYPlotSpace* plotSpace = (CPTXYPlotSpace*)[[self graph] plotSpaceAtIndex:0];
    [plotSpace setGlobalXRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat([[self graphData] count] <= xMax ? xMax : [[self graphData] count] - (1.0f - barWidth))]];
    
    [_graph reloadData];
}

- (void)createGraph
{
    /** Create graph with theme and padding **/
    
    [self setGraph: [[CPTXYGraph alloc] initWithFrame: CGRectZero]];
    self.hostedGraph = [self graph];
    [[self graph] setTitle: [self title]];
    
    
    CPTColor* bgColour = [CPTColor colorWithComponentRed:220.0f/0xFF green:240.0f/0xFF blue:231.0f/0xFF alpha:1.0f];
    
    [[self graph] setFill: [CPTFill fillWithColor: bgColour]];
    [[[self graph] plotAreaFrame] setPaddingTop: 20.0f];
    [[[self graph] plotAreaFrame] setPaddingBottom: 65.0f];
    [[[self graph] plotAreaFrame] setPaddingLeft: 57.0f];
    [[[self graph] plotAreaFrame] setPaddingRight: 5.0f];
   
    
    /** Set graph plot space **/
    
    const float xMin = 0.0f;
    const float yMin = 0.0f;
    const float xMax = 4.0f;
    const float yMax = 10.0f;
    
    const float barWidth = 0.70f;
    const float barOffset = barWidth / 2.0f;
    
    CPTXYPlotSpace* plotSpace = (CPTXYPlotSpace*)[[self graph] defaultPlotSpace];
    
    [plotSpace setDelegate: self];
    [plotSpace setAllowsUserInteraction: true];
    [plotSpace setAllowsMomentumX:true];
    
    [plotSpace setXRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax - xMin)]];
    
    [plotSpace setYRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax - yMin)]];
    
    [plotSpace setGlobalXRange: [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat([[self graphData] count] <= xMax ? xMax : [[self graphData] count] - (1.0f - barWidth))]];
    
    
    /** Set grid lines **/
    
    CPTMutableLineStyle* majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    CPTMutableLineStyle* minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    [majorGridLineStyle setLineWidth: 0.5f];
    [minorGridLineStyle setLineWidth: 0.25f];
    [majorGridLineStyle setLineColor: [CPTColor blackColor]];
    [minorGridLineStyle setLineColor: [[CPTColor blackColor] colorWithAlphaComponent: 0.5]];
    
    
    /** Setup axises **/
    
    CPTMutableTextStyle* xAxisTextStyle = [CPTMutableTextStyle textStyle];
    [xAxisTextStyle setFontName: @"Avenir"];
    [xAxisTextStyle setFontSize: 11.0f];
    [xAxisTextStyle setColor: [CPTColor blackColor]];
    
    CPTMutableTextStyle* yAxisTextStyle = [CPTMutableTextStyle textStyle];
    [xAxisTextStyle setFontName: @"Avenir"];
    [xAxisTextStyle setFontSize: 12.0f];
    [xAxisTextStyle setColor: [CPTColor blackColor]];
    
    CPTMutableLineStyle* axisLineStyle = [CPTMutableLineStyle lineStyle];
    [axisLineStyle setLineColor: [CPTColor blackColor]];
    [axisLineStyle setLineWidth: 2.0f];
    
    [[self graph] setTitleTextStyle: yAxisTextStyle];
    [[self graph] setTitleDisplacement: CGPointMake(20, 0)];
    CPTXYAxisSet* axisSet = (CPTXYAxisSet*)[[self graph] axisSet];
    CPTXYAxis* xAxis = [axisSet xAxis];
    CPTXYAxis* yAxis = [axisSet yAxis];
    [xAxis setTitleOffset: 30.0f];
    [xAxis setLabelOffset: 3.0f];
    [xAxis setTitleTextStyle: xAxisTextStyle];
    [xAxis setLabelTextStyle: xAxisTextStyle];
    [xAxis setLabelingPolicy: CPTAxisLabelingPolicyNone];
    [xAxis setOrthogonalCoordinateDecimal: CPTDecimalFromInt(0)];
    [xAxis setMajorIntervalLength: CPTDecimalFromFloat(1.0f)];
    [xAxis setMinorTicksPerInterval: 1.0f];
    [xAxis setMajorGridLineStyle: nil];
    [xAxis setMinorGridLineStyle: nil];
    [xAxis setAxisConstraints: [CPTConstraints constraintWithLowerOffset: 0.0f]];
    
    [yAxis setTitle: @"Score"];
    [yAxis setTitleOffset: 40.0f];
    [yAxis setLabelOffset: 3.0f];
    [yAxis setTitleTextStyle: yAxisTextStyle];
    [yAxis setLabelTextStyle: yAxisTextStyle];
    [yAxis setOrthogonalCoordinateDecimal: CPTDecimalFromInt(0)];
    [yAxis setMajorIntervalLength: CPTDecimalFromFloat(1.0f)];
    [yAxis setMinorTicksPerInterval: 0.0f];
    [yAxis setMajorGridLineStyle: majorGridLineStyle];
    [yAxis setMinorGridLineStyle: nil];
    [yAxis setAxisConstraints: [CPTConstraints constraintWithLowerOffset: 0.0f]];
    
    
    /** Setup dates on X-Axis **/
    
    float xPosition = barOffset;
    NSArray* dates = [[self graphData] allKeys];
    NSMutableArray* xLabels = [NSMutableArray array];
    
    for (NSString* date in dates)
    {
        CPTAxisLabel* xlabel = [[CPTAxisLabel alloc] initWithText: date textStyle: [xAxis labelTextStyle]];
        [xlabel setTickLocation: [[NSNumber numberWithFloat: xPosition] decimalValue]];
        [xlabel setOffset: [xAxis labelOffset] + [xAxis majorTickLength]];
        [xlabel setRotation: M_PI / 4.0f];
        [xLabels addObject: xlabel];
        ++xPosition;
    }
    
    [xAxis setAxisLabels: [NSSet setWithArray: xLabels]];


    /** Setup plot **/
    
    CPTBarPlot* plot = [[CPTBarPlot alloc] init];
    [plot setDataSource: self];
    [plot setDelegate: self];
    [plot setBarCornerRadius: 5.0f];
    [plot setBarWidth: CPTDecimalFromCGFloat(barWidth)];
    [plot setBarOffset: CPTDecimalFromCGFloat(barOffset)];

    CPTMutableLineStyle* barBorderLineStyle = [CPTMutableLineStyle lineStyle];
    [barBorderLineStyle setLineWidth: 2.0f];
    
    CPTColor* barBordercolour = [CPTColor colorWithComponentRed:21.0f/0xFF green:142.0f/0xFF blue:141.0f/0xFF alpha:1.0f];
    [barBorderLineStyle setLineColor: barBordercolour];
    [plot setLineStyle: barBorderLineStyle];
    [plot setIdentifier: @"main"];
    
    [[self graph] addPlot: plot];
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [[self graphData] count];
}

- (NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    if ([[plot identifier] isEqual: @"main"])
    {
        NSNumber* num = [[[self graphData] allValues] objectAtIndex: index];
        
        if (fieldEnum == CPTBarPlotFieldBarLocation) //X-Axis
        {
            return [NSNumber numberWithFloat:index];
        }
        else if (fieldEnum == CPTBarPlotFieldBarTip) //Y-Axis
        {
            return num;
        }
    }
    
    return [NSNumber numberWithInteger: 0];
}

- (CPTFill*)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index
{
    if ([[barPlot identifier] isEqual: @"main"])
    {
        CPTColor* colour = [CPTColor colorWithComponentRed:21.0f/0xFF green:142.0f/0xFF blue:141.0f/0xFF alpha:0.5f];
        
        return [CPTFill fillWithColor: colour];
        
    }
    return [CPTFill fillWithColor: [CPTColor whiteColor]];
}

- (CPTPlotRange *)plotSpace:(CPTPlotSpace *)space willChangePlotRangeTo:(CPTPlotRange *)newRange forCoordinate:(CPTCoordinate)coordinate
{
    
    if (coordinate == CPTCoordinateX)
    {
        if (newRange.locationDouble < 0.0f)
            return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:newRange.length];
        
        return [CPTPlotRange plotRangeWithLocation:newRange.location length:newRange.length];
    }
    
    return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(10.0f)];
}

- (CGPoint)plotSpace:(CPTPlotSpace *)space willDisplaceBy:(CGPoint)displacement
{
    return CGPointMake(displacement.x, 0);
}
@end
