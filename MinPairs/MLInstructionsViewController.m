//
//  MLInstructionsViewController.m
//  MinPairs
//
//  Created by Brandon on 2014-05-10.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLInstructionsViewController.h"
#import "MLHelpViewController.h"
#import "MLPQOneViewController.h"
#import "MLPQTwoViewController.h"
#import "MLPQThreeViewController.h"
#import "MLFilterViewController.h"
#import "MLResultsViewController.h"
#import "MLSettingDatabase.h"
#import "MLPlatform.h"
#import "MLTheme.h"

@interface MLInstructionsViewController ()
@property (nonatomic, strong) NSString* filterLabelFmt;
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;
@end

@implementation MLInstructionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (IBAction)onHomeClicked:(UIBarButtonItem *)sender
{
    [[self navigationController] popViewControllerAnimated:true];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [MLTheme updateTheme];
}

- (void)viewDidLoad
{
    UIBarButtonItem* filterBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mFilter.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(onFilterClicked:)];
    
    UIBarButtonItem* helpBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mHelp.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(onHelpClicked:)];
    
    //[filterBtn setTintColor: [MLTheme navButtonColour]];
    self.navigationItem.rightBarButtonItems = @[helpBtn, filterBtn];
    
    [MLTheme setTheme: self];
    [super viewDidLoad];
    
    self.filterLabelFmt = [[self filterLabel] text];
    [self updateFilterLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateFilterLabel
{
    MLSettingDatabase* settingDb = [[MLSettingDatabase alloc] initSettingDatabase];
    MLSettingsData* setting = [settingDb getSetting];
    MLPair* catPair = setting.settingFilterCatPair;
    MLCategory* filterLeft = catPair.first;
    MLCategory* filterRight = catPair.second;
    self.filterLabel.text = [NSString stringWithFormat: [self filterLabelFmt], filterLeft.categoryDescription, filterRight.categoryDescription];
}

- (IBAction)onTouchToStartClicked:(UIButton *)sender
{
    [self pushSequeOnStack: [self mode]];
}

- (IBAction)onFilterClicked:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"goToFilter" sender:self];
}

- (IBAction)onHelpClicked:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"AppHelp" sender:[self mode]];
}

- (IBAction)unwindToInstructionsController:(UIStoryboardSegue *)unwindSegue
{
    /** No need to inspect controller state or set values/variables.. Previous state is preserved on unwind **/
    
    /*UIViewController* callerController = unwindSegue.sourceViewController;
    if ([callerController isKindOfClass:[MLResultsViewController class]])
    {
        //self.mode = [NSNumber numberWithBool: true];
    }*/
}

-(void) pushSequeOnStack:(NSNumber*)mode
{
    unsigned int r = arc4random_uniform(30);
    
    if (r < 10)
    {
        [self performSegueWithIdentifier:@"PQOne" sender: mode];
        
    }
    else if (r < 20)
    {
        [self performSegueWithIdentifier:@"PQTwo" sender: mode];
    }
    else
    {
        [self performSegueWithIdentifier:@"PQThree" sender: mode];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"PQOne"]||[[segue identifier]isEqualToString:@"PQTwo"]||[[segue identifier]isEqualToString:@"PQThree"])
    {
        NSString* typeStr = ([sender boolValue])?ML_TEST_TYPE_PRACTICE:ML_TEST_TYPE_QUIZ;
        NSDate* now = [NSDate date];
        NSDateFormatter* formatter =[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy MMM dd HH:mm:ss"];
        NSString* dateStr = [formatter stringFromDate:now];
        MLTestResult* initialResult= [[MLTestResult alloc]initTestResultWithCorrect:0 wrong:0 type:typeStr date:dateStr timeInSec:0 extraInfo:@"testing"];
        if([[segue identifier]isEqualToString:@"PQOne"])
        {
            MLPQOneViewController* vc = [segue destinationViewController];
            vc.practiceMode = [sender boolValue];
            vc.previousResult=initialResult;
            vc.questionCount=1;
        }
        else if([[segue identifier]isEqualToString:@"PQTwo"])
        {
            MLPQTwoViewController* vc = [segue destinationViewController];
            vc.practiceMode = [sender boolValue];
            vc.previousResult=initialResult;
            vc.questionCount=1;
        }
        else if ([[segue identifier]isEqualToString:@"PQThree"])
        {
            MLPQThreeViewController* vc = [segue destinationViewController];
            vc.practiceMode = [sender boolValue];
            vc.previousResult=initialResult;
            vc.questionCount=1;
        }
    }
    else if ([[segue identifier] isEqualToString:@"goToFilter"])
    {
        MLFilterViewController* vc = [segue destinationViewController];
        vc.listener = self;
    }
    else if ([[segue identifier] isEqualToString: @"AppHelp"])
    {
        MLHelpViewController* vc = [segue destinationViewController];
        vc.pageId = [sender boolValue] ? 4 : 5;
    }
}

-(void)onFilterSelectionChange:(MLPair*)catPair
{
    MLCategory* filterLeft = catPair.first;
    MLCategory* filterRight = catPair.second;
    self.filterLabel.text = [NSString stringWithFormat: [self filterLabelFmt], filterLeft.categoryDescription, filterRight.categoryDescription];
}

@end
