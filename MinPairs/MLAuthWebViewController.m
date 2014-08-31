//
//  MLAuthWebViewController.m
//  MinPairs
//
//  Created by Brandon on 2014-08-09.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLAuthWebViewController.h"
#import "MLOAuthWebView.h"
#import "MLTheme.h"

@interface MLAuthWebViewController ()
@property (nonatomic, strong) UIActivityIndicatorView* indicator;
@end

@implementation MLAuthWebViewController

- (UIActivityIndicatorView *)indicator
{
    if (!_indicator)
    {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [[self indicator] setHidden: true];
        [[self indicator] setColor: [MLTheme navButtonColour]];
        [[self indicator] setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)];
    }
    return _indicator;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    //TODO: Fix indicator.. It isn't displayed on the webview atm :l ..
    //TODO: Add a button to cancel/exit the webview upon denial or failure to load..
    
    
    MLOAuthWebView* view = (MLOAuthWebView *)[self view];
    
    [view setActivityIndicator:[self indicator]];
    [view addSubview:[self indicator]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[self indicator] removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
