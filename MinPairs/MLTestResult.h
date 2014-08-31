//
//  MLTestResult.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/25/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * MLTestResult is a class that is used to keep test results. Quiz, or Practice, are both tests types.
 */
@interface MLTestResult : NSObject
#define ML_TEST_TYPE_QUIZ @"quiz"
#define ML_TEST_TYPE_PRACTICE @"practice"
@property int testId;
@property int testQuestionsCorrect;
@property int testQuestionsWrong;
@property (strong,nonatomic) NSString* testType;
@property (strong,nonatomic)NSString* testDate;
@property int testTime;//in seconds
@property (strong,nonatomic) NSString* testExtra;
/*! Constructs instance of MLTestResult class
 * \param correct is a count of correct questions
 * \param wrong is a count of wrong answers
  * \param type is either quiz or practice
  * \param date is the date when test was taken
  * \param time is time in seconds how long it took the user to complete the test
  * \param extra can be used to store any extra information
 * \returns instance of MLTestResult
 */
-(instancetype)initTestResultWithCorrect:(int)correct wrong:(int)wrong type:(NSString*)testType date:(NSString*)testDate timeInSec:(int)time extraInfo:(NSString*)extraInfo;
/*! Constructs instance of MLTestResult class. Usualy used by database class.
 *\param id of the test
 * \param correct is a count of correct questions
 * \param wrong is a count of wrong answers
 * \param type is either quiz or practice
 * \param date is the date when test was taken
 * \param time is time in seconds how long it took the user to complete the test
 * \param extra can be used to store any extra information
 * \returns instance of MLTestResult
 */
-(instancetype)initTestResultWithId:(int)testId correct:(int)correct wrong:(int)wrong type:(NSString*)testType date:(NSString*)testDate timeInSec:(int)time extraInfo:(NSString*)extraInfo;
@end
