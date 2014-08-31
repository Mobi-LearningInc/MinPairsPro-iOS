//
//  MLTinCanSettingsViewController.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 5/29/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLTinCanSettingsViewController.h"
#import "MLLrsCredentialsDatabase.h"
#import "MLTheme.h"
#import "MLPlatform.h" //needed for manually setting the round buttons since MLTheme isn't being applied due to nested views.

@interface MLTinCanSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextBox;
@property (weak, nonatomic) IBOutlet UITextField *emailTextBox;

@property (weak, nonatomic) IBOutlet UITextField *lrsAuthTextBox;
@property (weak, nonatomic) IBOutlet UITextField *lrsPasswordTextBox;
@property (weak, nonatomic) IBOutlet UITextField *lrsUrlTextBox;
@property (weak, nonatomic) IBOutlet UISegmentedControl *toggleBtn;

@end

@implementation MLTinCanSettingsViewController

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
    [MLTheme setTheme: self];
    UIView* view = [[[self view] subviews] objectAtIndex:0];
    [MLPlatform setButtonsRound:view withRadius:10.0f];
    
    [super viewDidLoad];
    self.userNameTextBox.delegate=self;
    self.emailTextBox.delegate=self;
    self.lrsAuthTextBox.delegate=self;
    self.lrsPasswordTextBox.delegate=self;
    self.lrsUrlTextBox.delegate=self;
    [self loadAndFillPage];
    
    self.toggleBtn.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] boolForKey:@"TinCanSwitch"] ? 0 : 1;
    [self performSelector:@selector(tinCanToggleBtnTap:) withObject: [self toggleBtn]];
}
- (IBAction)onHomeClicked:(UIBarButtonItem *)sender
{
    [[self navigationController] popViewControllerAnimated:true];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadAndFillPage
{
    MLLrsCredentialsDatabase* credDb =[[MLLrsCredentialsDatabase alloc]initLmsCredentialsDatabase];
    MLLsrCredentials* loadedCreds = [credDb getLmsCredentials];
    self.userNameTextBox.text = loadedCreds.name;
    self.emailTextBox.text = loadedCreds.email;
    self.lrsAuthTextBox.text=loadedCreds.userName;
    self.lrsPasswordTextBox.text=loadedCreds.password;
    self.lrsUrlTextBox.text=loadedCreds.address;

    //todo create ways of enabling/disabling tincan
    self.toggleBtn.selectedSegmentIndex=0;
}
- (IBAction)tinCanToggleBtnTap:(id)sender
{
    if([sender selectedSegmentIndex]==0)
    {
        #ifdef DEBUG
        NSLog(@"TinCan Enabled.");
        #endif
        [self.userNameTextBox setEnabled:YES];
        [self.emailTextBox setEnabled:YES];
        [self.lrsAuthTextBox setEnabled:YES];
        [self.lrsPasswordTextBox setEnabled:YES];
        [self.lrsUrlTextBox setEnabled:YES];
        
        [self.userNameTextBox setAlpha:1.0f];
        [self.emailTextBox setAlpha:1.0f];
        [self.lrsAuthTextBox setAlpha:1.0f];
        [self.lrsPasswordTextBox setAlpha:1.0f];
        [self.lrsUrlTextBox setAlpha:1.0f];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TinCanSwitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if([sender selectedSegmentIndex]==1)
    {
        #ifdef DEBUG
        NSLog(@"TinCan Disabled.");
        #endif
        [self.userNameTextBox setEnabled:NO];
        [self.emailTextBox setEnabled:NO];
        [self.lrsAuthTextBox setEnabled:NO];
        [self.lrsPasswordTextBox setEnabled:NO];
        [self.lrsUrlTextBox setEnabled:NO];
        
        [self.userNameTextBox setAlpha:0.5f];
        [self.emailTextBox setAlpha:0.5f];
        [self.lrsAuthTextBox setAlpha:0.5f];
        [self.lrsPasswordTextBox setAlpha:0.5f];
        [self.lrsUrlTextBox setAlpha:0.5f];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"TinCanSwitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)onResetBtnTap:(id)sender
{
    [self resetTinCanSettingsToDefaults];
}
- (IBAction)onSaveBtnTap:(id)sender
{
    #ifdef DEBUG
    NSLog(@"USERNAME and EMAIL are not saved. Everything else is saved.");
    #endif
    
    //todo save username and email
    //todo validate LRS credentials before saving
    MLLsrCredentials* newCreds = [[MLLsrCredentials alloc]initCredentialsWithId:1 appName:ML_DB_CREDENTIALS_DEFAULT_APPNAME userName:self.lrsAuthTextBox.text password:self.lrsPasswordTextBox.text address:self.lrsUrlTextBox.text appUserName:self.userNameTextBox.text email:self.emailTextBox.text];
    [self saveTinCanSettingsData:newCreds];
    
    [[self navigationController] popViewControllerAnimated:true];
}
-(void)saveTinCanSettingsData:(MLLsrCredentials*)creds
{
    MLLrsCredentialsDatabase* credDb = [[MLLrsCredentialsDatabase alloc]initLmsCredentialsDatabase];
    [credDb saveLmsCredentials:creds];
}
-(void)resetTinCanSettingsToDefaults
{
    MLLrsCredentialsDatabase* credDb = [[MLLrsCredentialsDatabase alloc]initLmsCredentialsDatabase];
    [credDb saveDefaultCredentials];
    [self loadAndFillPage];
}
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
