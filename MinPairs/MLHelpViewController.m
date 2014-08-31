//
//  MLHelpViewController.m
//  MinPairs
//
//  Created by Brandon on 2014-05-11.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLHelpViewController.h"
#import "MLPlatform.h"
#import "MLTheme.h"

@interface MLHelpViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSMutableArray *helpFiles;
@end

@implementation MLHelpViewController

- (NSMutableArray*) helpFiles{

    if(!_helpFiles){
        _helpFiles = [[NSMutableArray alloc]initWithArray:@[@"index.html", @"filter.html", @"sound.html", @"learn.html", @"practice.html", @"quizzes.html", @"statistics.html", @"settings.html"]];
    
    }
    return _helpFiles;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (IBAction)onHomeClicked:(UIBarButtonItem *)sender
{
    [[self navigationController] popViewControllerAnimated:true];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:false animated:true];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:true animated:true];
    [MLTheme updateTheme];
}

- (void)viewDidLoad
{
    [MLTheme setTheme: self];
    [super viewDidLoad];
    [self loadRequestFromString:[self.helpFiles objectAtIndex:self.pageId]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)loadRequestFromString:(NSString*)urlString
{
    NSString *filePath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:urlString];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:fileURL];
    [self.webView loadRequest:requestObj];
}

- (IBAction)backBtnClick:(id)sender
{
    [self.webView goBack];
}

- (IBAction)forwardBtnClick:(id)sender
{
    [self.webView goForward];
}

@end
