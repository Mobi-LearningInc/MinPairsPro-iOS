//
//  BarGraphViewController.m
//  CPTest
//
//  Created by Brandon on 2014-05-20.
//  Copyright (c) 2014 Brandon. All rights reserved.
//

#import "BarGraphViewController.h"
#import "BarGraphView.h"

@interface BarGraphViewController ()
@property (weak, nonatomic) IBOutlet BarGraphView* hostView;
@end

@implementation BarGraphViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self hostView] createGraph];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
