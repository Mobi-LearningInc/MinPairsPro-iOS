//
//  MLLineGraphViewController.m
//  MinPairs
//
//  Created by Brandon on 2014-05-20.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLLineGraphViewController.h"
#import "MLStatsTabBarViewController.h"

@interface MLLineGraphViewController ()

@end

@implementation MLLineGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MLLineGraphView* hostView = (MLLineGraphView*)[self view];
    MLStatsTabBarViewController* controller = (MLStatsTabBarViewController*)[self tabBarController];
    [hostView setGraphData: [controller lineGraphResults]];
    [hostView setGraphTitle: [controller filterTitle]];
    [hostView createGraph];
}

- (void)reloadData
{
    MLLineGraphView* hostView = (MLLineGraphView*)[self view];
    MLStatsTabBarViewController* controller = (MLStatsTabBarViewController*)[self tabBarController];
    [hostView setGraphData: [controller lineGraphResults]];
    [hostView setGraphTitle: [controller filterTitle]];
    [hostView reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
