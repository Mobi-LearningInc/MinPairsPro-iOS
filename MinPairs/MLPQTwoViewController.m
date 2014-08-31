//
//  MLPQTwoViewController.m
//  MinPairs
//
//  Created by Brandon on 2014-04-26.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//
#import "MLPQOneViewController.h"
#import "MLPQTwoViewController.h"
#import "MLPQThreeViewController.h"
#import "MLDetailsItem.h"
@interface MLPQTwoViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textAnswer;
@property (weak, nonatomic) IBOutlet UILabel *typeTimeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;
@property (strong,nonatomic)MLItem* correctItem;
@property (weak, nonatomic) IBOutlet UIButton *answerBtn;
@property (weak, nonatomic) IBOutlet UILabel *correctTextLabel;

@end

@implementation MLPQTwoViewController

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
    self.textAnswer.delegate = self;
    self.sequeName=@"PQTwo";
    self.correctTextLabel.text=@"";
    int rand = arc4random_uniform(2);
    MLPair* itemPair =[self pickRandomItemPairPairForCategory:self.filterCatPair];

    self.correctItem=(rand==0)?itemPair.first:itemPair.second;
    #ifdef DEBUG
    NSLog(@"Correct item is %@", [self.correctItem.itemDescription capitalizedString]);
    #endif
    [self registerQuizTimeLabelsAndEventSelectLabel:nil event:nil readLabel:nil event:nil typeLabel:self.typeTimeLabel event:^(void){
        
        [self onAnswerBtn:self.answerBtn];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self onAnswerBtn:self.answerBtn];
    return NO;
}

- (IBAction)onPlayBtn:(id)sender
{
    [self playItem:self.correctItem];
    #ifdef DEBUG
    NSLog(@"Played sound for %@", [self.correctItem.itemDescription capitalizedString]);
    #endif
}
- (IBAction)onAnswerBtn:(id)sender
{
    self.pauseTimer=YES;
    NSString* raw = self.textAnswer.text;
    NSString* noWS=[raw stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString* cleanStr=[noWS lowercaseString];
    #ifdef DEBUG
    NSLog(@"User typed %@",cleanStr);
    #endif
    int corr;
    int wrong;
    MLDetailsItem* dItem;
    if([cleanStr isEqualToString: [self.correctItem.itemDescription lowercaseString]])
    {
        corr=1;
        wrong=0;
        self.statusImg.image=[UIImage imageNamed:@"fCorrect"];
        dItem=[[MLDetailsItem alloc]initDetailsItemWithType:DETAIL_TYPE_TWO correctItem:self.correctItem userItem:[[MLItem alloc]initItemWithId:-1 description:cleanStr audioPath:NULL imagePath:NULL seperator:NULL] status:true index:self.questionCount];
    }
    else
    {
        corr=0;
        wrong=1;
        self.correctTextLabel.text= [self.correctItem.itemDescription capitalizedString];
        self.statusImg.image=[UIImage imageNamed:@"fIncorrect"];
        dItem=[[MLDetailsItem alloc]initDetailsItemWithType:DETAIL_TYPE_TWO correctItem:self.correctItem userItem:[[MLItem alloc]initItemWithId:-1 description:cleanStr audioPath:NULL imagePath:NULL seperator:NULL] status:false index:self.questionCount];
    }
    if(!self.detailsArray)
    {
        self.detailsArray = [NSMutableArray array];
    }
    [self.detailsArray addObject:dItem];
    MLTestResult* currentResult =[[MLTestResult alloc]initTestResultWithCorrect:corr+self.previousResult.testQuestionsCorrect
        wrong:wrong+self.previousResult.testQuestionsWrong
        type:self.previousResult.testType
        date:self.previousResult.testDate
        timeInSec:self.timeCount+self.previousResult.testTime
        extraInfo:self.previousResult.testExtra];
    [sender setHidden: YES];
    [self performSelector:@selector(onAnswer:) withObject:currentResult afterDelay:2.0];
}
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}





@end
