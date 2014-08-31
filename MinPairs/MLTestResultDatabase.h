//
//  MLMinPairDatabase.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/25/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLDatabase.h"
#import "MLTestResult.h"
/**
 * MLTestResultDatabase class stores/reads quiz or practice results in sqlite database. Inherits from MLDatabase class.
 */
@interface MLTestResultDatabase : MLDatabase
#define ML_DB_TEST_TABLE_NAME @"test_table"
#define ML_DB_TEST_TABLE_COL_ID @"test_ID"
#define ML_DB_TEST_TABLE_COL_QUESTIONS_CORRECT @"test_questions_correct"
#define ML_DB_TEST_TABLE_COL_QUESTIONS_WRONG @"test_questions_wrong"
#define ML_DB_TEST_TABLE_COL_QUESTIONS_TYPE @"test_type"
#define ML_DB_TEST_TABLE_COL_QUESTIONS_DATE @"test_date"
#define ML_DB_TEST_TABLE_COL_QUESTIONS_TIME @"test_time"
#define ML_DB_TEST_TABLE_COL_QUESTIONS_EXTRA @"test_extra"
/*! Constructs instance of MLTestResultDatabase class
 * \returns instance of MLTestResultDatabase class
 */
-(instancetype)initTestResultDatabase;
/*! stores MlTestResult object in database
 * \param MLTestResult object
 * \returns BOOL if representing success
 */
-(BOOL)saveTestResult:(MLTestResult*)test;
/*! gets Test results from the sqlite database
 * \returns NSArray of MLTestResultObjects
 */
-(NSArray*)getTestResults;

-(NSUInteger) getCount;
@end
/*
 USAGE EXAMPLE
 
 MLTestResultDatabase* db = [[MLTestResultDatabase alloc]initTestResultDatabase];
 NSDate* now = [NSDate date];
 NSDateFormatter* formatter =[[NSDateFormatter alloc]init];
 [formatter setDateFormat:@"yyyy MMM dd HH:mm:ss"];
 NSString* dateStr = [formatter stringFromDate:now];
 MLTestResult* rOne=[[MLTestResult alloc]initTestResultWithCorrect:5 wrong:5 type:ML_TEST_TYPE_PRACTICE date:dateStr timeInSec:30 extraInfo:@""];
 [db saveTestResult: rOne];
 NSArray* arr = [db getTestResults];
 for(int i =0; i<[arr count]; i++)
 {
 MLTestResult* tr = [arr objectAtIndex:i];
 NSLog(@"test result in db : id: %i date: %@",tr.testId,tr.testDate);
 }
 
 */
