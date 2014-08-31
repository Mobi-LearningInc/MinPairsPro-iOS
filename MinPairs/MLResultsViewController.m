//
//  MLResultsViewController.m
//  MinPairs
//
//  Created by Brandon on 2014-05-09.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLResultsViewController.h"
#import "MLPlatform.h"
#import "MLShareViewController.h"
#import "MLTinCanConnector.h"
#import "MLLrsCredentialsDatabase.h"
#import "MLTheme.h"
#import "MLDetailTableViewController.h"
#import "MLInstructionsViewController.h"

@interface MLResultsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *tryDoneButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *viewToShare;

@end

@implementation MLResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.hidesBackButton = true;
    
    if ([self mode] && ([self.correct intValue] < [self.total intValue])) //if the user does not score perfect, allow them to try again..
    {
        UIBarButtonItem *homeBtn = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(onHomeBtn:)];
        [homeBtn setImage: [UIImage imageNamed:@"mHome.png"]];
        [homeBtn setTintColor: [MLTheme navButtonColour]];
        self.navigationItem.leftBarButtonItem = homeBtn;
        
        [[self tryDoneButton] setTitle:@"Try Again" forState:UIControlStateNormal];
        [[self tryDoneButton] setTag: 0xFF];
    }
    
    [MLTheme setTheme: self];
    [super viewDidLoad];
    
    self.titleLabel.text = [[self text] capitalizedString];
    self.scoreInfoLabel.text = [NSString stringWithFormat:@"%@ / %@", [self correct], [self total]];
    self.timeLabel.text = [NSString stringWithFormat:@"Time taken: %@ s", [self time]];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TinCanSwitch"])
    {
        NSNumber *c = [NSNumber numberWithInt:[[self correct] intValue]];
        NSNumber *t = [NSNumber numberWithInt:[[self total] intValue]];
        NSNumber *p = [NSNumber numberWithFloat:([c floatValue]/[t floatValue])];
        
        MLTinCanConnector *tincan = [[MLTinCanConnector alloc]initWithCredentials:[[[MLLrsCredentialsDatabase alloc]initLmsCredentialsDatabase] getLmsCredentials]];
        [tincan saveQuizResults:p points:c max:t time:[NSString stringWithFormat:@"PT%@.00S", [self time]]];
    }

    
}

- (IBAction)onHomeBtn:(id)sender
{
    self.navigationItem.hidesBackButton = false;
    [[self navigationController] popToRootViewControllerAnimated: YES];
}

- (IBAction)onTryDoneClicked:(UIButton *)sender
{
    if ([sender tag] == 0xFF) //loop practice.. show more questions..
    {
        [self performSegueWithIdentifier:@"unwindToInstructions" sender: self];
    }
    else
    {
        [self onHomeBtn:nil];
    }
}

- (IBAction)onDetailsBtn:(id)sender
{
    MLDetailTableViewController* dtvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsTableViewController"];
    dtvc.array=self.detailsArray;
    [self presentViewController:dtvc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onShareClicked:(id)sender
{
    MLShareViewController* msvc=[self.storyboard instantiateViewControllerWithIdentifier: @"ShareViewController"];
    msvc.socialMessage=[NSString stringWithFormat:@"I am using the MinimalPairs application to improve my English."];
    msvc.isModal=true;
    msvc.socialImage = [self captureScreen:self.viewToShare];
    [self presentViewController:msvc animated:YES completion:nil];
}
-(UIImage*)captureScreen:(UIView*) viewToCapture
{
    UIGraphicsBeginImageContext(viewToCapture.bounds.size);
    [viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"TestInstructions"]) //No need for this since unwind segue is used instead.
    {
        MLInstructionsViewController* vc = [segue destinationViewController];
        vc.mode = sender;
    }
}*/

@end
