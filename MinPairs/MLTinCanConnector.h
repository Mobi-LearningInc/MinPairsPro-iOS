//
//  MLTinCanConnector.h
//  MinPairs
//
//  Created by MLinc on 2014-05-08.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLLsrCredentials.h"
#import "RSTinCanConnector.h"
/*
#import "TCLocalizedValues.h"
#import "TCActivity.h"
#import "TCActivityDefinition.h"
#import "TCQueryOptions.h"
#import "TCState.h"
#import "TCStatementCollection.h"
*/

@interface MLTinCanConnector : NSObject

-(instancetype)initWithCredentials:(MLLsrCredentials *)credentials;
-(void)saveSampleActivity;
-(void)saveQuizResults:(NSNumber*)percentage points:(NSNumber*)points max:(NSNumber*)maxPoints time:(NSString*)time;

@end
