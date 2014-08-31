//
//  MLPQThreeViewController.m
//  MinPairs
//
//  Created by Brandon on 2014-04-26.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLPQThreeViewController.h"
#import "MLPQTwoViewController.h"
#import "MLPQOneViewController.h"
#import "MLItem.h"
#import "MLCategory.h"
#import "MLPair.h"
#import "MLMainDataProvider.h"
#import "MLBasicAudioPlayer.h"
#import "MLTestResult.h"
#import "MLDetailsItem.h"
#import "MLTheme.h"
#import "MLPlatform.h"


@interface MLPQThreeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *leftPlayBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightPlayBtn;

@property (strong,nonatomic) MLItem* itemLeft;
@property (strong,nonatomic) MLItem* itemRight;
@property (weak, nonatomic) IBOutlet UILabel *itemMainLabel;
@property (weak, nonatomic) IBOutlet UILabel *readTimeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;
@property (weak, nonatomic) IBOutlet UIImageView *leftFingerImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightFingerImg;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@property (strong, nonatomic)MLItem* correctAnswer;
@end

@implementation MLPQThreeViewController

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
    
    [[self leftPlayBtn] setBackgroundColor:[UIColor whiteColor]];
    [[self rightPlayBtn] setBackgroundColor:[UIColor whiteColor]];
    [MLPlatform setButtonRound:[self leftPlayBtn] withRadius:15.0f];
    [MLPlatform setButtonRound:[self rightPlayBtn] withRadius:15.0f];
    [MLPlatform setButtonBorder:[self leftPlayBtn] withBorderWidth:2.0f withColour: [MLTheme navButtonColour] withMask:true];
    [MLPlatform setButtonBorder:[self rightPlayBtn] withBorderWidth:2.0f withColour: [MLTheme navButtonColour] withMask:true];
    
    self.sequeName=@"PQThree";
    int rSwap = arc4random_uniform(2);
    if (rSwap==0)
    {
        MLPair* itemPair =[self pickRandomItemPairPairForCategory:self.filterCatPair];
        self.itemLeft = itemPair.first;
        self.itemRight = itemPair.second;
    }
    else
    {
        MLPair* itemPair =[self pickRandomItemPairPairForCategory:self.filterCatPair];
        self.itemLeft = itemPair.second;
        self.itemRight = itemPair.first;
    }
    int rand = arc4random_uniform(2);
    MLItem* cor= rand==0?self.itemLeft:self.itemRight;
    self.itemMainLabel.text= [cor.itemDescription capitalizedString];
    self.correctAnswer=cor;
    #ifdef DEBUG
    NSLog(@"Correct answer is %@", [self.correctAnswer.itemDescription capitalizedString]);
    #endif
    [self.leftFingerImg setHidden:YES];
    [self.rightFingerImg setHidden:YES];
    [self registerQuizTimeLabelsAndEventSelectLabel:nil event:nil readLabel:self.readTimeLabel event:^(void){
        
        [self onAnswerButton:self.submitBtn];
    } typeLabel:nil event:nil];
}

- (IBAction)onLeftPlayBtnTap:(id)sender
{
    [self playItem:self.itemLeft];
    [self.leftFingerImg setHidden:NO];
    [self.rightFingerImg setHidden:YES];
    #ifdef DEBUG
    NSLog(@"Played sound for %@", [self.itemLeft.itemDescription capitalizedString]);
    #endif
}
- (IBAction)onRightPlayBtnTap:(id)sender
{
    [self playItem:self.itemRight];
    
    [self.leftFingerImg setHidden:YES];
    [self.rightFingerImg setHidden:NO];
    #ifdef DEBUG
    NSLog(@"Played sound for %@", [self.itemRight.itemDescription capitalizedString]);
    #endif
}

- (IBAction)onAnswerButton:(id)sender
{
    self.pauseTimer=YES;
    int corr;
    int wrong;
    MLItem* selected =nil;
    if(!self.leftFingerImg.hidden)
    {
        selected=self.itemLeft;
    }
    else if(!self.rightFingerImg.hidden)
    {
        selected=self.itemRight;
    }
    #ifdef DEBUG
    NSLog(@"User selected %@", [selected.itemDescription capitalizedString]);
    #endif
    MLDetailsItem* dItem;
    if(self.correctAnswer==selected)
    {
        corr=1;
        wrong=0;
        self.statusImg.image=[UIImage imageNamed:@"fCorrect"];
        dItem = [[MLDetailsItem alloc]initDetailsItemWithType:DETAIL_TYPE_THREE correctItem:self.correctAnswer userItem:selected status:true index:self.questionCount];
    }
    else
    {
        corr=0;
        wrong=1;
        self.statusImg.image=[UIImage imageNamed:@"fIncorrect"];
        selected = self.itemRight == self.correctAnswer ? self.itemLeft : self.itemRight;
        dItem = [[MLDetailsItem alloc]initDetailsItemWithType:DETAIL_TYPE_THREE correctItem:self.correctAnswer userItem:selected status:false index:self.questionCount];
    }
    if(!self.detailsArray)
    {
        self.detailsArray = [NSMutableArray array];
    }
    [self.detailsArray addObject:dItem];
    MLTestResult* currentResult =[[MLTestResult alloc]initTestResultWithCorrect:corr+self.previousResult.testQuestionsCorrect wrong:wrong+self.previousResult.testQuestionsWrong type:self.previousResult.testType date:self.previousResult.testDate timeInSec:self.timeCount+self.previousResult.testTime extraInfo:self.previousResult.testExtra];
    [sender setHidden: YES];
    //[self.chekcMarkImg setHidden:YES];
    [self performSelector:@selector(onAnswer:) withObject:currentResult afterDelay:2.0];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
