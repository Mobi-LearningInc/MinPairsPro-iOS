//
//  MLPQBaseViewController.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/30/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLPQBaseViewController.h"
#import "MLPQOneViewController.h"
#import "MLPQTwoViewController.h"
#import "MLPQThreeViewController.h"
#import "MLTestResultDatabase.h"
#import "MLSettingDatabase.h"
#import "MLBasicAudioPlayer.h"
#import "MLPair.h"
#import "MLMainDataProvider.h"
#import "MLDetailsItem.h"
#import "MLResultsViewController.h"
#import "MLTheme.h"
#import "GADInterstitial.h"

@interface MLPQBaseViewController ()
@property NSTimer* timer;
@property MLTestResult* currentResult;
@property (weak,nonatomic)UILabel* selectTimeLabel;
@property (weak,nonatomic)UILabel* readTimeLabel;
@property (weak,nonatomic)UILabel* typeTimeLabel;
@property (strong,nonatomic)MLSettingsData* setting;
@property (copy) void (^onTypeEnd)(void);
@property (copy) void (^onSelectEnd)(void);
@property (copy) void (^onReadEnd)(void);

//ad specific
@property BOOL canShowAd;
@property (strong,nonatomic) GADInterstitial* bigAdd;

@property (strong,nonatomic)MLBasicAudioPlayer* audioPlayer;
@end

@implementation MLPQBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [MLTheme updateTheme];
}

- (void)viewDidLoad
{
    [MLTheme setTheme: self];
    [super viewDidLoad];
    
    self.audioPlayer=[[MLBasicAudioPlayer alloc]init];
    
    self.pauseTimer=false;
    if(self.questionCount==0)//Show instrustion on first msg
    {
    NSString* modeStr = [NSString stringWithFormat: @"You are currently in: %s mode.", [self practiceMode] ? "PracticeMode" : "QuizMode."];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Notice" message:modeStr delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    self.pauseTimer=true;
    }
    if(self.progressBar)
    {
        [self.progressBar setProgress:(float)self.questionCount/(float)ML_MLPQBASE_QUESTION_LIMIT animated:YES];
    }

    UIBarButtonItem *quitBtn = [[UIBarButtonItem alloc] initWithTitle:nil style:UIBarButtonItemStyleBordered target:self action:@selector(onQuitBtn)];
    [quitBtn setImage: [UIImage imageNamed:@"fQuit.png"]];
    [quitBtn setTintColor: [MLTheme navButtonColour]];
    
    self.navigationItem.leftBarButtonItem=quitBtn;
    MLSettingDatabase * settingDB= [[MLSettingDatabase alloc]initSettingDatabase];
    self.setting= [settingDB getSetting];
    MLPair* pair = self.setting.settingFilterCatPair;
    self.filterCatPair=pair;
    self.catFromFilterLeft=pair.first;
    self.catFromFilterRight=pair.second;
    self.previousResult.testExtra=[NSString stringWithFormat:@"%@|%@",[pair.first categoryDescription],[pair.second categoryDescription]];
    NSString* titleStr = [NSString stringWithFormat:@"%@ %@ vs %@", self.practiceMode?@"Practice":@"Quiz", self.catFromFilterLeft.categoryDescription, self.catFromFilterRight.categoryDescription];
    self.title =titleStr;
    self.controllerArray=[NSMutableArray arrayWithObjects:@"PQOne",@"PQTwo",@"PQThree", nil];
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTick) userInfo:nil repeats:YES];
    
    //ad specific
    [self prepAd];
    
}

//ad specific
-(void)prepAd
{
    self.canShowAd=false;
    self.bigAdd=[[GADInterstitial alloc]init];
    self.bigAdd.delegate=self;
    self.bigAdd.adUnitID=@"ca-app-pub-7358405443490326/2547190894";
    [self.bigAdd loadRequest:[GADRequest request]];
}
-(void)registerQuizTimeLabelsAndEventSelectLabel:(UILabel*)selectTimeLabel event:(void (^)(void))onSelectEnd readLabel: (UILabel*)readTimeLabel event:(void (^)(void))onReadEnd typeLabel: (UILabel*)typeTimeLabel event:(void (^)(void))onTypeEnd
{
    self.selectTimeLabel=selectTimeLabel;
    self.readTimeLabel=readTimeLabel;
    self.typeTimeLabel=typeTimeLabel;
    self.onSelectEnd=onSelectEnd;
    self.onReadEnd=onReadEnd;
    self.onTypeEnd=onTypeEnd;
    if (self.practiceMode)
    {
        if(self.selectTimeLabel)[self.selectTimeLabel setHidden:YES];
        if(self.readTimeLabel)[self.readTimeLabel setHidden:YES];
        if(self.typeTimeLabel)[self.typeTimeLabel setHidden:YES];
    }

}
-(void)onTick
{
    if(!self.pauseTimer)
    {
    self.timeCount++;
    if (!self.practiceMode)
    {
        int selectLimit =self.setting.settingTimeSelect;
        int readLimit = self.setting.settingTimeRead;
        int typeLimit=self.setting.settingTimeType;
        int currentSelectTime = (selectLimit-self.timeCount)<0?0:selectLimit-self.timeCount;
        int currentReadTime = (readLimit-self.timeCount)<0?0:readLimit-self.timeCount;
        int currentTypeTime = (typeLimit-self.timeCount)<0?0:typeLimit-self.timeCount;
        if(self.selectTimeLabel)
        {
            if (currentSelectTime>0)
            {
                self.selectTimeLabel.text=[NSString stringWithFormat:@"%i",currentSelectTime];
            }
            else
            {
                self.selectTimeLabel.text=@"";
                if(self.onSelectEnd)//run once
                {
                    self.onSelectEnd();
                    self.onSelectEnd =nil;
                }
            }
        }
        if(self.readTimeLabel)
        {
            if (currentReadTime>0)
            {
                self.readTimeLabel.text=[NSString stringWithFormat:@"%i",currentReadTime];
            }
            else
            {
                self.readTimeLabel.text=@"";
                if(self.onReadEnd)//run once
                {
                    self.onReadEnd();
                    self.onReadEnd=nil;
                }
            }
        }
        if(self.typeTimeLabel)
        {
            if (currentTypeTime>0)
            {
                self.typeTimeLabel.text=[NSString stringWithFormat:@"%i",currentTypeTime];
            }
            else
            {
                self.typeTimeLabel.text=@"";
                if(self.onTypeEnd)//run once
                {
                    self.onTypeEnd();
                    self.onTypeEnd=nil;
                }
                
            }
        }
        
    }
    }
}

-(void)onQuitBtn
{
    self.pauseTimer=true;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Quit" message:@"Are you sure you want to quit? All progress will be lost." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex])//'cancel' button from quit popup or 'ok' button from stat info popup
    {
        self.pauseTimer=false;
        #ifdef DEBUG
        NSLog(@"btn index %li",(long)buttonIndex );
        #endif
    }
    if(buttonIndex==1)//ok btn from quit popup
    {
        if(self.timer)
        {
            [self.timer invalidate];
            self.timer = nil;
        }
        #ifdef DEBUG
        NSLog(@"btn index %li",(long)buttonIndex);
        #endif
        [self.navigationController popToRootViewControllerAnimated:YES];
    }    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated
{
    if(self.timer)
    {
    [self.timer invalidate];
    self.timer = nil;
    }
    [super viewDidDisappear:animated];
}

-(void)onAnswer:(MLTestResult*)currentResult
{
    if(!self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    #ifdef DEBUG
    NSLog(@"status : correct:%i, wrong:%i, time: %i",currentResult.testQuestionsCorrect,currentResult.testQuestionsWrong,self.timeCount);
    #endif

    self.currentResult=currentResult;

    if (self.questionCount>=ML_MLPQBASE_QUESTION_LIMIT)
    {
        [self saveResultThenShowAd];
    }
    else
    {
        #ifdef DEBUG
        NSLog(@"will start next question");
        #endif
        [self pushSequeOnStack: [NSNumber numberWithBool: [self.previousResult.testType isEqualToString:ML_TEST_TYPE_PRACTICE]?true:false]];
    }

 
}
-(void)playItem:(MLItem*)item
{
    
    [self.audioPlayer loadFileFromResource:item.itemAudioFile withExtension: @"mp3"];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

-(MLPair*)pickRandomItemPairPairForCategory:(MLPair*) filterCatPair
{
    MLCategory* filterCatLeft=filterCatPair.first;
    MLCategory* filterCatRight=filterCatPair.second;
    self.title = [NSString stringWithFormat:@"%@ %@ vs %@", [self practiceMode] ? @"Practice" : @"Quiz",  filterCatLeft.categoryDescription, filterCatRight.categoryDescription];
    MLMainDataProvider* dataPro = [[MLMainDataProvider alloc]initMainProvider];
    NSArray* pairPairArr = [dataPro getPairs];
    NSMutableArray* filteredArr = [NSMutableArray array];
    for (int i=0; i<pairPairArr.count; i++)
    {
        MLPair* p=[pairPairArr objectAtIndex:i];
        MLPair * pl=p.first;
        MLPair* pr = p.second;
        MLCategory * cl = pl.first;
        MLItem* il = pl.second;
        MLCategory * cr=pr.first;
        MLItem* ir=pr.second;
        if (filterCatLeft.categoryId==0)//filter is set to 'all'
        {
            [filteredArr addObject:[[MLPair alloc]initPairWithFirstObject:il secondObject:ir]];
        }
        else
        {
            if ((filterCatLeft.categoryId==cl.categoryId&&filterCatRight.categoryId==cr.categoryId)||(filterCatLeft.categoryId==cr.categoryId&&filterCatRight.categoryId==cl.categoryId))
            {
                [filteredArr addObject:[[MLPair alloc]initPairWithFirstObject:il secondObject:ir]];
            }
        }
        
        
    }
    
    NSUInteger randomIndex = arc4random_uniform((unsigned int)filteredArr.count);
    return [filteredArr objectAtIndex:randomIndex];
}
-(void) pushSequeOnStack:(NSNumber*)mode
{
    NSMutableArray* workArr = [NSMutableArray array];
    for (int i =0; i<self.controllerArray.count; i++)
    {
        if (![[self.controllerArray objectAtIndex:i]isEqualToString:self.sequeName])
        {
            [workArr addObject:[self.controllerArray objectAtIndex:i]];
        }
    }
    unsigned long range=workArr.count;
    unsigned int r = arc4random_uniform((unsigned int)range);
    [self performSegueWithIdentifier:[workArr objectAtIndex:r] sender: mode];
}

-(void)saveResultThenShowAd
{
    MLTestResultDatabase* resultDb = [[MLTestResultDatabase alloc]initTestResultDatabase];
    [resultDb saveTestResult:self.currentResult];
    [self showAd];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if([[segue identifier]isEqualToString:@"PQOne"])
    {
        MLPQOneViewController* vc = [segue destinationViewController];
        vc.practiceMode = [sender boolValue];
        vc.questionCount = ++self.questionCount;;
        vc.previousResult = self.currentResult;
        vc.detailsArray = self.detailsArray;
    }
    else if([[segue identifier]isEqualToString:@"PQTwo"])
    {
        MLPQTwoViewController* vc = [segue destinationViewController];
        vc.practiceMode = [sender boolValue];
        vc.questionCount = ++self.questionCount;
        vc.previousResult = self.currentResult;
        vc.detailsArray = self.detailsArray;
    }
    else if ([[segue identifier]isEqualToString:@"PQThree"])
    {
        MLPQThreeViewController* vc = [segue destinationViewController];
        vc.practiceMode = [sender boolValue];
        vc.questionCount = ++self.questionCount;
        vc.previousResult = self.currentResult;
        vc.detailsArray = self.detailsArray;
    }
    else if ([[segue identifier] isEqualToString:@"PQResults"])
    {
        MLResultsViewController* rvc = [segue destinationViewController];
        
        rvc.mode = [sender boolValue];
        rvc.text = [NSString stringWithFormat: @"%@ Results", self.currentResult.testType];
        rvc.correct = [NSString stringWithFormat: @"%i", self.currentResult.testQuestionsCorrect];
        rvc.wrong = [NSString stringWithFormat: @"%i", self.currentResult.testQuestionsWrong];
        rvc.total = [NSString stringWithFormat: @"%i", self.currentResult.testQuestionsCorrect + self.currentResult.testQuestionsWrong];
        rvc.time = [NSString stringWithFormat: @"%i", self.currentResult.testTime];
        rvc.detailsArray = self.detailsArray;
    }
}
//ad specific
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    self.canShowAd=true;
    #ifdef DEBUG
        NSLog(@"can show ad");
    #endif
}
- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error
{
    self.canShowAd=false;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial
{
    [self showResultsPage];
}
-(void)showAd
{
    self.canShowAd=false;
    if(self.bigAdd.isReady)//check if ready before presenting
    {
        [self.bigAdd presentFromRootViewController:self];
    }
    else
    {
        [self showResultsPage];
    }
}
-(void)showResultsPage
{
    [self performSegueWithIdentifier:@"PQResults" sender: [NSNumber numberWithBool: [self practiceMode]]];
}
@end
