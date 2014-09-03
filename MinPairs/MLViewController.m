//
//  MLViewController.m
//  MinPairs
//
//  Created by ituser on 4/23/2014.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLViewController.h"
#import "MLInstructionsViewController.h"
#import "MLCategory.h"
#import "MLSettingDatabase.h"
#import "MLTestResultDatabase.h"
#import "MLTheme.h"
#import "MLPlatform.h"
#import "MLTinCanConnector.h"
#import "MLLsrCredentials.h"
#import "MLLrsCredentialsDatabase.h"
#import "MLPackageDownloader.h"
#import "MLPackageList.h"
#import "MLPackageFileList.h"

@interface MLViewController ()
@property (nonatomic, strong) MLLrsCredentialsDatabase* lrsDatabase;
@property (nonatomic, strong) MLTinCanConnector* tincan;
@end

@implementation MLViewController

- (MLLrsCredentialsDatabase *)lrsDatabase{
    if(!_lrsDatabase){
        
        ///todo 
        _lrsDatabase = [[MLLrsCredentialsDatabase alloc]initLmsCredentialsDatabase];
        MLLsrCredentials *cred = [_lrsDatabase getLmsCredentials];
        if(!cred || [cred.name isEqualToString:@""])
            [_lrsDatabase saveDefaultCredentials];
    }
    
    return _lrsDatabase;
}

- (MLTinCanConnector *)tincan{

    if (!_tincan) {
        _tincan = [[MLTinCanConnector alloc] initWithCredentials:[self.lrsDatabase getLmsCredentials]];
    }
    return _tincan;
}

-(void) viewWillAppear:(BOOL)animated
{    
    UIBarButtonItem* info = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(onInfoClicked:)];
    
    UIBarButtonItem* help = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(onHelpClicked:)];
    
    UIBarButtonItem* filter = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(onFilterClicked:)];
    
    UIColor* barButtonColor = [MLTheme navButtonColour];
    
    [info setImage: [UIImage imageNamed:@"mAbout.png"]];
    [help setImage: [UIImage imageNamed:@"mHelp.png"]];
    [filter setImage: [UIImage imageNamed:@"mFilter.png"]];
    
    
    [info setTintColor:barButtonColor];
    [help setTintColor:barButtonColor];
    [filter setTintColor:barButtonColor];
    
    self.navigationItem.rightBarButtonItems = @[help, filter];
    self.navigationItem.leftBarButtonItems = @[info];
}

- (void)viewDidLoad
{
    [MLTheme setTheme: self];
    [super viewDidLoad];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"TinCanSwitch"] || [[NSUserDefaults standardUserDefaults] boolForKey:@"TinCanSwitch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TinCanSwitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tincan saveSampleActivity];
    }
    //todo:check if default package is installed
    
    //testing downloader classes and server
    #ifdef DEBUG
        NSLog(@"Downloading data...");
    #endif
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    MLPackageDownloader* packDown = [[MLPackageDownloader alloc]init];
    MLPackageList* packages=[packDown getDownloadablePackages];
        if(packages)
        {
    #ifdef DEBUG
        NSLog(@"Downloadable packages:%@ \n DetailServlet:%@ \n DetailServletParam:%@", packages.packageList,[packages.detailsServletUrl absoluteString],packages.detailsServletpackageIdParamName);
    #endif
        MLPackageFileList* fileServletData=[packDown getFileUrlForPackage:packages packageName:[packages.packageList objectAtIndex:0]];
            if(fileServletData)
            {
    #ifdef DEBUG
           NSLog(@"Files for %@ package :\n %@ \n file servlet name:%@ \n file servlet param names : %@,%@",[packages.packageList objectAtIndex:0],fileServletData.list,fileServletData.fileServletUrl.absoluteString,fileServletData.fileServletPackageIdParamName,fileServletData.fileServletFileIdParamName);
    #endif
                [packDown saveFilesToDisk:fileServletData];
            }
        }
    });
#ifdef DEBUG
    NSLog(@"main viewDidLoad finished...");
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPracticeClicked:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"TestInstructions" sender: [NSNumber numberWithBool: true]];
}

- (IBAction)onQuizzesClicked:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"TestInstructions" sender: [NSNumber numberWithBool: false]];
}

-(IBAction)onInfoClicked:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"AppInfo" sender: @"Info"];
}

-(IBAction)onHelpClicked:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"AppHelp" sender: @"Help"];
}

-(IBAction)onFilterClicked:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"AppFilter" sender: @"Filter"];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"StatisticsSegue"] &&  ![[[MLTestResultDatabase alloc] initTestResultDatabase] getCount])
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Statistics" message:@"There are currently no statistics to display." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        [self.navigationController popToRootViewControllerAnimated:TRUE];
        return false;
    }
    return true;
}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString: @"TestInstructions"])
    {
        MLInstructionsViewController* vc = [segue destinationViewController];
        vc.mode = sender;
    }
}

@end
