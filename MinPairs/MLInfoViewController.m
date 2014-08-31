//
//  MLInfoViewController.m
//  MinPairs
//
//  Created by Brandon on 2014-05-10.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLInfoViewController.h"
#import "MLPlatform.h"
#import "MLTheme.h"

@interface MLInfoViewController ()
@property (weak, nonatomic) IBOutlet UITextView* InfoView;
@property (weak, nonatomic) IBOutlet UILabel* CopyrightLabel;
@end

@implementation MLInfoViewController

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
    [MLTheme setTheme: self];
    [super viewDidLoad];
    
    NSString* build = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString* version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:self.InfoView.text, version, build, @" offers simple activities to help you learn, teach, and perfect English pronunciation and phonetics. Practicing minimal pairs is a proven method to improve your English language proficiency. MinimalPairs provides mobile-assisted language learning activities to help you learn, practice and assess your progress in discriminating English sounds.", @"support@mobilearninginc.com"]];
    
    self.InfoView.attributedText = [MLPlatform parseBBCodes:text withFontSize:self.InfoView.font.pointSize];
    self.InfoView.dataDetectorTypes = UIDataDetectorTypeLink;
    
    self.CopyrightLabel.text = @"Copyright © 2014. Mobi-Learning™ Inc.";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
