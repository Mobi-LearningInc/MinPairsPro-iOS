//
//  MLSettingsViewController.m
//  MinPairs
//
//  Created by Brandon on 2014-04-26.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLSettingsViewController.h"
#import "MLHelpViewController.h"
#import "MLSettingDatabase.h"
#import "MLPlatform.h"
#import "MLTheme.h"

@interface MLSettingsViewController ()
@property (weak, nonatomic) IBOutlet UIStepper* listenAndSelectStepper;
@property (weak, nonatomic) IBOutlet UIStepper* listenAndReadStepper;
@property (weak, nonatomic) IBOutlet UIStepper* listenAndTypeStepper;
@property (weak, nonatomic) IBOutlet UILabel *listenAndSelectLabel;
@property (weak, nonatomic) IBOutlet UILabel *listenAndReadLabel;
@property (weak, nonatomic) IBOutlet UILabel *listenAndTypeLabel;
@end

@implementation MLSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
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
    [MLTheme setTheme: self];
    [super viewDidLoad];
    [self updateControls];
}

-(void)updateControls
{
    MLSettingDatabase * settingsDb=[[MLSettingDatabase alloc]initSettingDatabase];
    MLSettingsData* data = [settingsDb getSetting];
    
    [[self listenAndSelectStepper] setValue: data.settingTimeSelect];
    [[self listenAndReadStepper] setValue: data.settingTimeRead];
    [[self listenAndTypeStepper] setValue: data.settingTimeType];
    
    [[self listenAndSelectLabel] setText: [NSString stringWithFormat:@"%d s", data.settingTimeSelect]];
    [[self listenAndReadLabel] setText: [NSString stringWithFormat:@"%d s", data.settingTimeRead]];
    [[self listenAndTypeLabel] setText: [NSString stringWithFormat:@"%d s", data.settingTimeType]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSaveClicked:(UIButton*)sender
{
    int selectTime = [[self listenAndSelectStepper] value];
    int readTime = [[self listenAndReadStepper] value];
    int typeTime = [[self listenAndTypeStepper] value];
    MLSettingDatabase * settingsDb=[[MLSettingDatabase alloc]initSettingDatabase];
    MLSettingsData* currentSetting =[settingsDb getSetting];
    MLSettingsData* data = [[MLSettingsData alloc]initSettingWithTimeSelect:selectTime timeRead:readTime timeType:typeTime filterSelection:currentSetting.settingFilterCatPair];
    
    [settingsDb saveSetting:data];
}

- (IBAction)onResetClicked:(UIButton*)sender
{
    MLSettingDatabase * settingsDb=[[MLSettingDatabase alloc]initSettingDatabase];
    [settingsDb saveDefaultSetting];
    [self updateControls];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    //hides keyboard
    [self.view endEditing:YES];
}

- (IBAction)onStepperChanged:(UIStepper *)sender
{
    if (sender == [self listenAndSelectStepper])
    {
        [[self listenAndSelectLabel] setText: [NSString stringWithFormat:@"%lu s", (unsigned long)[sender value]]];
    }
    else if (sender == [self listenAndReadStepper])
    {
        [[self listenAndReadLabel] setText: [NSString stringWithFormat:@"%lu s", (unsigned long)[sender value]]];
    }
    else
    {
        [[self listenAndTypeLabel] setText: [NSString stringWithFormat:@"%lu s", (unsigned long)[sender value]]];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"AppHelp"])
    {
        MLHelpViewController* vc = [segue destinationViewController];
        vc.pageId = 7;
    }
}

@end
