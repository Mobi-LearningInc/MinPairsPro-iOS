//
//  LineGraphViewController.m
//  CPTest
//
//  Created by Brandon on 2014-05-20.
//  Copyright (c) 2014 Brandon. All rights reserved.
//

#import "LineGraphViewController.h"
#import "LineGraphView.h"

@interface LineGraphViewController ()
@property (strong, nonatomic) IBOutlet LineGraphView* hostView;
@end

@implementation LineGraphViewController

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
    
    [[self hostView] createGraph];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
