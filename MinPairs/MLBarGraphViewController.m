//
//  MLBarGraphViewController.m
//  MinPairs
//
//  Created by Brandon on 2014-05-20.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLBarGraphViewController.h"
#import "MLStatsTabBarViewController.h"

@interface MLBarGraphViewController ()

@end

@implementation MLBarGraphViewController

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
    
    MLBarGraphView* hostView = (MLBarGraphView*)[self view];
    MLStatsTabBarViewController* controller = (MLStatsTabBarViewController*)[self tabBarController];
    [hostView setGraphData: [controller barGraphResults]];
    [hostView setGraphTitle: [controller filterTitle]];
    [hostView createGraph];
}

- (void)reloadData
{
    MLBarGraphView* hostView = (MLBarGraphView*)[self view];
    MLStatsTabBarViewController* controller = (MLStatsTabBarViewController*)[self tabBarController];
    [hostView setGraphData: [controller barGraphResults]];
    [hostView setGraphTitle: [controller filterTitle]];
    [hostView reload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
