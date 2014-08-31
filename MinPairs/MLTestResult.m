//
//  MLTestResult.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/25/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLTestResult.h"

@implementation MLTestResult
-(instancetype)initTestResultWithCorrect:(int)correct wrong:(int)wrong type:(NSString*)testType date:(NSString*)testDate timeInSec:(int)time extraInfo:(NSString*)extraInfo
{
    self=[super init];
    if(self)
    {
        self.testId=-1;
        self.testQuestionsCorrect=correct;
        self.testQuestionsWrong=wrong;
        self.testType=testType;
        self.testDate=testDate;
        self.testTime=time;
        self.testExtra=extraInfo;
    }
    return self;
}
-(instancetype)initTestResultWithId:(int)testId correct:(int)correct wrong:(int)wrong type:(NSString*)testType date:(NSString*)testDate timeInSec:(int)time extraInfo:(NSString*)extraInfo
{
    self=[super init];
    if(self)
    {
        self.testId=testId;
        self.testQuestionsCorrect=correct;
        self.testQuestionsWrong=wrong;
        self.testType=testType;
        self.testDate=testDate;
        self.testTime=time;
        self.testExtra=extraInfo;
    }
    return self;
}
@end
