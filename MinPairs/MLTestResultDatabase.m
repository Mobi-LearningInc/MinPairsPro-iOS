//
//  MLMinPairDatabase.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/25/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLTestResultDatabase.h"

@implementation MLTestResultDatabase
-(instancetype)initTestResultDatabase
{
    //NOTE! if createStr is modified then the database must be deleted and created again
    NSString* createStr =[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ INTEGER, %@ INTEGER, %@ TEXT, %@ TEXT, %@ INTEGER, %@ TEXT);",ML_DB_TEST_TABLE_NAME,ML_DB_TEST_TABLE_COL_ID,ML_DB_TEST_TABLE_COL_QUESTIONS_CORRECT,ML_DB_TEST_TABLE_COL_QUESTIONS_WRONG,ML_DB_TEST_TABLE_COL_QUESTIONS_TYPE,ML_DB_TEST_TABLE_COL_QUESTIONS_DATE,ML_DB_TEST_TABLE_COL_QUESTIONS_TIME,ML_DB_TEST_TABLE_COL_QUESTIONS_EXTRA];
    self=[super initDatabaseWithCreateQuery:createStr];
    return self;
}
-(BOOL)saveTestResult:(MLTestResult*)test
{
    NSString* query =[NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@,%@,%@,%@) VALUES(%i,%i,'%@','%@',%i,'%@');",ML_DB_TEST_TABLE_NAME,ML_DB_TEST_TABLE_COL_QUESTIONS_CORRECT,ML_DB_TEST_TABLE_COL_QUESTIONS_WRONG,ML_DB_TEST_TABLE_COL_QUESTIONS_TYPE,ML_DB_TEST_TABLE_COL_QUESTIONS_DATE,ML_DB_TEST_TABLE_COL_QUESTIONS_TIME,ML_DB_TEST_TABLE_COL_QUESTIONS_EXTRA,test.testQuestionsCorrect,test.testQuestionsWrong,test.testType,test.testDate,test.testTime,test.testExtra];
    NSString* errorStr;
    if(![self runQuery:query errorString:&errorStr])
    {
        #ifdef DEBUG
        NSLog(@"%@",errorStr);
        #endif
        return NO;
    }
    return YES;
}
-(NSArray*)getTestResults
{
    NSString* query=[NSString stringWithFormat:@"SELECT * FROM %@ ;",ML_DB_TEST_TABLE_NAME];
    NSString* errorStr =@"";
    NSMutableArray* dataArr = [NSMutableArray array];
    if ([self runQuery:query errorString:&errorStr returnArray:&dataArr])
    {
        NSMutableArray* result = [NSMutableArray array];
        for(int i =0; i<[dataArr count];i++)
        {
            NSMutableArray* rowDataArr = [dataArr objectAtIndex:i];
            MLTestResult* dataItem = [[MLTestResult alloc]initTestResultWithId:[[rowDataArr objectAtIndex:0]intValue] correct:[[rowDataArr objectAtIndex:1]intValue] wrong:[[rowDataArr objectAtIndex:2]intValue] type:[rowDataArr objectAtIndex:3] date:[rowDataArr objectAtIndex:4] timeInSec:[[rowDataArr objectAtIndex:5]intValue] extraInfo:[rowDataArr objectAtIndex:6]];
            [result addObject:dataItem];
        }
        return result;
    }
    return nil;
}

-(NSUInteger) getCount
{
    NSString* query = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ ;", ML_DB_TEST_TABLE_NAME];
    
    NSString* err = nil;
    NSMutableArray* arr = [NSMutableArray array];
    
    if ([self runQuery:query errorString: &err returnArray: &arr])
    {
        if ([arr count])
        {
            NSMutableArray* rowDataArr = [arr objectAtIndex: 0];
            return [[rowDataArr objectAtIndex:0]intValue];
        }
    }
    return 0;
}
@end
