//
//  MLPQBaseViewController.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/30/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLTestResult.h"
#import "MLCategory.h"
#import "MLItem.h"
#import "MLPair.h"
#import "GADInterstitialDelegate.h"
#define ML_MLPQBASE_QUESTION_LIMIT 10
/** MLPQBaseViewController is the base class too all Practice/Quiz contollers
 */
@interface MLPQBaseViewController : UIViewController <UIAlertViewDelegate,GADInterstitialDelegate>
@property (nonatomic, assign) bool practiceMode;//set on segue
@property int questionCount;//set on segue
@property (strong,nonatomic) MLTestResult* previousResult;//set on segue
@property (strong,nonatomic) MLPair* filterCatPair;
@property MLCategory* catFromFilterLeft;//set in viewDid load
@property MLCategory* catFromFilterRight;//set in viewDid load
@property NSMutableArray* controllerArray;//set in viewDid load
@property NSString* sequeName;//set in child
@property int timeCount;//set by NSTimer
@property UIProgressView* progressBar;
@property BOOL pauseTimer;
@property (strong, nonatomic) NSMutableArray* detailsArray;//set by children
/** called when quiz or practice controller is ready with the result
 *@param currentResult is a MLTestResult object filled with cumulative data from this test session
 */
-(void)onAnswer:(MLTestResult*)currentResult;
/** plays sound file associated with the MLItem object
 * @param MLItem object
 */
-(void)playItem:(MLItem*)item;


/** used to register timer labels and timer events. events will be triggered based on MLSettings data
 */
-(void)registerQuizTimeLabelsAndEventSelectLabel:(UILabel*)selectTimeLabel event:(void (^)(void))onSelectEnd readLabel: (UILabel*)readTimeLabel event:(void (^)(void))onReadEnd typeLabel: (UILabel*)typeTimeLabel event:(void (^)(void))onTypeEnd;
/** used to get a random category pair that this controller will work with
 *@param MLPair filterCategoryPair is the Category pair thats provided by the SettinsDb and set by the user in the app filter
 */
-(MLPair*)pickRandomItemPairPairForCategory:(MLPair*) filterCatPair;
@end
