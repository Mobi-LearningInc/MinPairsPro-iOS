//
//  LineGraphView.h
//  MinPairs
//
//  Created by Brandon on 2014-05-20.
//  Copyright (c) 2014 Brandon. All rights reserved.
//

#import "CPTGraphHostingView.h"
#import "CorePlot-CocoaTouch.h"
#import "MLMutableSortedDictionary.h"

@interface MLLineGraphView : CPTGraphHostingView<CPTPlotDataSource, CPTPlotSpaceDelegate>
- (void)createGraph;
- (void) setGraphData:(MLMutableSortedDictionary*)data;
- (void) setGraphTitle:(NSString*)title;
- (void) reload;
@end
