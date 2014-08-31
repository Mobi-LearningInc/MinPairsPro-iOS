//
//  MLAllvsAllControllerViewController.m
//  MinPairs
//
//  Created by Brandon on 2014-04-26.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLPQOneViewController.h"
#import "MLPQTwoViewController.h"
#import "MLPQThreeViewController.h"
#import "MLDetailsItem.h"
#import "MLTheme.h"
#import "MLPlatform.h"

@interface MLPQOneViewController ()
@property (weak, nonatomic) IBOutlet UIButton *leftImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightImgBtn;
@property (strong,nonatomic) MLItem* itemLeft;
@property (strong,nonatomic) MLItem* itemRight;
@property (strong,nonatomic) MLItem* correctItem;
@property (weak, nonatomic) IBOutlet UILabel *selectTimeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;
@property (weak, nonatomic) IBOutlet UIImageView *leftFingerImg;
@property (weak, nonatomic) IBOutlet UIImageView *rightFingerImg;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;



@end

@implementation MLPQOneViewController

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
    
    [[self leftImgBtn] setBackgroundColor:[UIColor whiteColor]];
    [[self rightImgBtn] setBackgroundColor:[UIColor whiteColor]];
    [MLPlatform setButtonRound:[self leftImgBtn] withRadius:15.0f];
    [MLPlatform setButtonRound:[self rightImgBtn] withRadius:15.0f];
    [MLPlatform setButtonBorder:[self leftImgBtn] withBorderWidth:2.0f withColour: [MLTheme navButtonColour] withMask:true];
    [MLPlatform setButtonBorder:[self rightImgBtn] withBorderWidth:2.0f withColour: [MLTheme navButtonColour] withMask:true];
    
    self.sequeName=@"PQOne";
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
    UIImage* imgLeft =([UIImage imageNamed:self.itemLeft.itemImageFile]==NULL)?[UIImage imageNamed:@"na1.png"]:[UIImage imageNamed:self.itemLeft.itemImageFile];
    UIImage* imgRight=([UIImage imageNamed:self.itemRight.itemImageFile]==NULL)?[UIImage imageNamed:@"na1.png"]:[UIImage imageNamed:self.itemRight.itemImageFile];
    [self.leftImgBtn setImage:imgLeft forState:UIControlStateNormal];
    [self.rightImgBtn setImage:imgRight forState:UIControlStateNormal];
    int rand = arc4random_uniform(2);
    MLItem* cor= rand==0?self.itemLeft:self.itemRight;
    self.correctItem=cor;
    #ifdef DEBUG
    NSLog(@"Correct item is %@", [self.correctItem.itemDescription capitalizedString]);
    #endif
    [self.leftFingerImg setHidden:YES];
    [self.rightFingerImg setHidden:YES];
    [self registerQuizTimeLabelsAndEventSelectLabel:self.selectTimeLabel event:^(void){
        [self onAnswerBtn:self.submitBtn];
    } readLabel:nil event:nil typeLabel:nil event:nil];
}
- (IBAction)onPlayBtn:(id)sender
{
    [self playItem:self.correctItem];
    #ifdef DEBUG
    NSLog(@"Played sound for %@", [self.correctItem.itemDescription capitalizedString]);
    #endif
}
- (IBAction)onLeftImgBtnTap:(id)sender
{
    [self.leftFingerImg setHidden:NO];
    [self.rightFingerImg setHidden:YES];
}
- (IBAction)onRightImgBtnTap:(id)sender
{
    [self.leftFingerImg setHidden:YES];
    [self.rightFingerImg setHidden:NO];
}
- (void)highlightBtn:(UIButton*)btn
{
    [btn setHighlighted:YES];
}
- (void)unHighlightBtn:(UIButton*)btn
{
    [btn setHighlighted:NO];
}
- (IBAction)onAnswerBtn:(id)sender
{
    self.pauseTimer=YES;
    int corr;
    int wrong;
    MLItem* selected=nil;
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
    if(selected==self.correctItem)
    {
        corr=1;
        wrong=0;
        self.statusImg.image=[UIImage imageNamed:@"fCorrect"];
        dItem = [[MLDetailsItem alloc]initDetailsItemWithType:DETAIL_TYPE_ONE correctItem:self.correctItem userItem:selected status:true index:self.questionCount];
    }
    else
    {
        corr=0;
        wrong=1;
        selected = self.itemRight == self.correctItem ? self.itemLeft : self.itemRight;
        self.statusImg.image=[UIImage imageNamed:@"fIncorrect"];
        dItem = [[MLDetailsItem alloc]initDetailsItemWithType:DETAIL_TYPE_ONE correctItem:self.correctItem userItem:selected status:false index:self.questionCount];
    }
    if(!self.detailsArray)
    {
        self.detailsArray = [NSMutableArray array];
    }
    [self.detailsArray addObject:dItem];
    MLTestResult* currentResult =[[MLTestResult alloc]initTestResultWithCorrect:corr+self.previousResult.testQuestionsCorrect wrong:wrong+self.previousResult.testQuestionsWrong type:self.previousResult.testType date:self.previousResult.testDate timeInSec:self.timeCount+self.previousResult.testTime extraInfo:self.previousResult.testExtra];
    [sender setHidden: YES];
    [self performSelector:@selector(onAnswer:) withObject:currentResult afterDelay:2.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
