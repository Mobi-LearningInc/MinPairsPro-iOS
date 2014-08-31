//
//  MLStatsTabBarViewController.m
//  MinPairs
//
//  Created by Brandon on 2014-05-25.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLStatsTabBarViewController.h"
#import "MLBarGraphViewController.h"
#import "MLLineGraphViewController.h"
#import "MLFilterViewController.h"
#import "MLHelpViewController.h"
#import "MLTestResultDatabase.h"
#import "MLSettingDatabase.h"
#import "MLCategory.h"
#import "MLTheme.h"

@interface MLStatsTabBarViewController ()
@property (nonatomic, strong) NSDateFormatter* dateFormatter;
@property (nonatomic, strong) NSArray* testResults;
@property (nonatomic, strong) NSString* filterDesc;
@end

@implementation MLStatsTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)onHomeClicked:(UIBarButtonItem *)sender
{
    [[self navigationController] popViewControllerAnimated:true];
}

- (IBAction)onFilterClicked:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"goToFilter" sender:self];
}

- (IBAction)onHelpClicked:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"AppHelp" sender:self];
}

- (bool)filterResultsExist
{
    for (MLTestResult* res in [self testResults])
    {
        if ([[res testExtra] isEqualToString: [self filterDesc]])
        {
            return true;
        }
    }
    return false;
}

- (void)loadLineGraphStats:(MLMutableSortedDictionary*)duplicates
{
    _lineGraphResults = [[MLMutableSortedDictionary alloc] init];
    
    [_lineGraphResults setSortMode:true];
    [_lineGraphResults setComparator:^NSComparisonResult(NSDate* lhs, NSDate* rhs) {
        return [lhs compare: rhs];
    }];
    
    for (MLTestResult* res in [self testResults])
    {
        if (([[res testExtra] isEqualToString: [self filterDesc]]) || [[self filterDesc] isEqualToString:@"All|All"])
        {
            NSDate* date = [[self dateFormatter] dateFromString: [res testDate]];
            NSString* str = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
            
            int score = [res testQuestionsCorrect];
            
            NSArray* data = [duplicates objectForKey: str];
            if (data)
            {
                NSNumber* added_score = data[0];
                added_score = @([added_score intValue] + score);
                
                NSNumber* dup_count = data[1];
                dup_count = @([dup_count intValue] + 1);
                
                data = @[added_score, dup_count];
                [duplicates setObject: data forKey: str];
            }
            else
            {
                data = @[[NSNumber numberWithInt: score], [NSNumber numberWithInt: 1]];
                [duplicates setObject: data forKey: str];
            }
            
            [_lineGraphResults setObject:[NSNumber numberWithInt:score] forKey: date];
        }
    }
}

- (void)loadBarGraphStats:(MLMutableSortedDictionary*)duplicates
{
    _barGraphResults = [[MLMutableSortedDictionary alloc] init];
    [_barGraphResults setSortMode:true];
    [_barGraphResults setComparator:^NSComparisonResult(NSString* lhs, NSString* rhs) {
        return [lhs compare: rhs];
    }];
    
    for (NSString* key in duplicates)
    {
        NSArray* arr = [duplicates objectForKey: key];
        int dup_count = [((NSNumber*)arr[1]) intValue];
        
        if (dup_count > 1)
        {
            float val = [((NSNumber*)arr[0]) floatValue];
            val /= dup_count;
            [_barGraphResults setObject:[NSNumber numberWithFloat:val] forKey:key];
        }
        else
        {
            [_barGraphResults setObject:[NSNumber numberWithFloat:[((NSNumber*)arr[0]) floatValue]] forKey:key];
        }
    }
}

- (void)viewDidLoad
{
    UIBarButtonItem* filterBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mFilter.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(onFilterClicked:)];
    
    UIBarButtonItem* helpBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mHelp.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(onHelpClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[helpBtn, filterBtn];
    
    [MLTheme setTheme: self];
    [super viewDidLoad];

    MLTestResultDatabase* db = [[MLTestResultDatabase alloc] initTestResultDatabase];
    MLMutableSortedDictionary* duplicates = [[MLMutableSortedDictionary alloc] init];
    _dateFormatter = [[NSDateFormatter alloc] init];
    
    _testResults = [db getTestResults];
    [_dateFormatter setDateFormat: @"yyyy MMM dd HH:mm:ss"];
    
    _filterDesc = @"All|All";
    _filterTitle = @"All vs. All";

    [self loadLineGraphStats: duplicates];
    [self loadBarGraphStats: duplicates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"AppHelp"])
    {
        MLHelpViewController* vc = [segue destinationViewController];
        vc.pageId = 6;
    }
    else if ([[segue identifier] isEqualToString:@"goToFilter"])
    {
        MLFilterViewController* vc = [segue destinationViewController];
        vc.listener = self;
    }
}

-(void)onFilterSelectionChange:(MLPair*)catPair
{
    MLCategory* filterLeft = catPair.first;
    MLCategory* filterRight = catPair.second;
    NSString* newFilterDesc = [NSString stringWithFormat:@"%@|%@", filterLeft.categoryDescription, filterRight.categoryDescription];
    
    if ([_filterDesc isEqualToString: newFilterDesc])
    {
        return;
    }
    
    _filterDesc = newFilterDesc;
    _filterTitle = [NSString stringWithFormat:@"%@ vs. %@", filterLeft.categoryDescription, filterRight.categoryDescription];
    
    
    if (![self filterResultsExist])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Statistics" message:@"There are currently no statistics to display that matches that filter.\n\nGraphs left unchanged." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    MLMutableSortedDictionary* duplicates = [[MLMutableSortedDictionary alloc] init];
    [self loadLineGraphStats: duplicates];
    [self loadBarGraphStats: duplicates];
    
    MLBarGraphViewController* bvc = (MLBarGraphViewController*)[[self viewControllers] objectAtIndex: 0];
    [bvc reloadData];

    MLLineGraphViewController* lvc = (MLLineGraphViewController*)[[self viewControllers] objectAtIndex: 1];
    [lvc reloadData];
    
    [[self view] setNeedsDisplay];
}

@end
