//
//  MLTinCanConnector.m
//  MinPairs
//
//  Created by MLinc on 2014-05-08.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLTinCanConnector.h"


@interface MLTinCanConnector()
    @property (strong, nonatomic) RSTinCanConnector *tincan;
    @property (strong, nonatomic) MLLsrCredentials *credentials;
@end

@implementation MLTinCanConnector

//MP ACTIVITIES FOR XAPI
NSString* const BASE = @"http://mobilearninginc.com/minimal-pairs/iOS/v1.0";
NSString* const APPLICATION = @"";
NSString* const QUIZ = @"/quiz";
NSString* const PRACTICE = @"hpractice";
NSString* const LEARN = @"/learn";
NSString* const SOUND_CHART = @"/soundChart";

//ACTIVITIES
NSString* const TC_COURSE = @"http://adlnet.gov/expapi/activities/course";
NSString* const TC_INTERACTION = @"http://adlnet.gov/expapi/activities/interaction";
NSString* const TC_ASSESSMENT = @"http://adlnet.gov/expapi/activities/assessment";

//VERBS
NSString* const TC_LAUNCHED = @"http://adlnet.gov/expapi/verbs/launched";
NSString* const TC_LAUNCHED_DISPLAY = @"launched";
NSString* const TC_TERMINATED = @"http://adlnet.gov/expapi/verbs/terminated";
NSString* const TC_TERMINATED_DISPLAY = @"terminated";
NSString* const TC_REGISTERED = @"http://adlnet.gov/expapi/verbs/registered";
NSString* const TC_REGISTERED_DISPLAY = @"registered";
NSString* const TC_COMPLETED = @"http://adlnet.gov/expapi/verbs/completed";
NSString* const TC_COMPLETED_DISPLAY = @"completed";
NSString* const TC_EXPERIENCED = @"http://adlnet.gov/expapi/verbs/experienced";
NSString* const TC_EXPERIENCED_DISPLAY = @"experienced";

-(instancetype)initWithCredentials:(MLLsrCredentials *)credentials{

    self=[super init];
    if(self)
    {
        self.credentials = credentials;
        _tincan = [self setUp:credentials];
    }
    return self;
}

-(RSTinCanConnector*)tincan{
    if(_tincan==nil){
        _tincan = [self setUp:self.credentials];
    }
    return _tincan;
}

- (RSTinCanConnector *)setUp:(MLLsrCredentials*)credentials
{
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *lrs = [[NSMutableDictionary alloc] init];
    
    //dummy LRS - supply your own credentials here to run tests
    //@"https://cloud.scorm.com/tc/I40JG12M9U/"
    //@"Basic UHJ6ZW1lazptb2plbXlzemtp"
    
    
    [lrs setValue:credentials.address forKey:@"endpoint"];
    [lrs setValue:credentials.encodedCredentials forKey:@"auth"];
    [lrs setValue:@"1.0.0"forKey:@"version"];
    // just add one LRS for now
    [options setValue:[NSArray arrayWithObject:lrs] forKey:@"recordStore"];
    [options setValue:@"1.0.0" forKey:@"version"];
    RSTinCanConnector *tincan = [[RSTinCanConnector alloc]initWithOptions:options];
    return tincan;
}


-(void)saveSampleActivity{

    NSMutableDictionary *statementOptions = [[NSMutableDictionary alloc] init];
    [statementOptions setValue:[BASE stringByAppendingString:APPLICATION] forKey:@"activityId"];
    [statementOptions setValue:[[TCVerb alloc] initWithId:TC_LAUNCHED withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:TC_LAUNCHED_DISPLAY]] forKey:@"verb"];
    [statementOptions setValue:TC_COURSE forKey:@"activityType"];
    
    TCStatement *statementToSend = [self createTestStatementWithOptions:statementOptions];
    #ifdef DEBUG
    NSLog(@"%@\n", statementToSend.JSONString);
    #endif
    [self.tincan sendStatement:statementToSend withCompletionBlock:^(){
    }withErrorBlock:^(TCError *error){
        #ifdef DEBUG
        NSLog(@"ERROR: %@", error.localizedDescription);
        #endif
    }];
}

- (TCStatement *)createTestStatementWithOptions:(NSDictionary *)options
{
    TCAgent *actor = [[TCAgent alloc] initWithName:self.credentials.name /*@"Agnieszka"*/ withMbox:[NSString stringWithFormat:@"mailto:%@", self.credentials.email]/*@"mailto:agaizabella@rogers.com"*/ withAccount:nil];
    //   TCAgent *actor = [[TCAgent alloc] initWithName:@"Przemek" withMbox:@"mailto:pawluk@gmail.com" withAccount:nil];
    
    TCActivityDefinition *actDef = [[TCActivityDefinition alloc] initWithName:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"http://mobilearninginc.com/minpairs"]
                                                              withDescription:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"Description for test statement"]
                                                                     withType:[options valueForKey:@"activityType"]
                                                               withExtensions:nil
                                                          withInteractionType:nil
                                                  withCorrectResponsesPattern:nil
                                                                  withChoices:nil
                                                                    withScale:nil
                                                                   withTarget:nil
                                                                    withSteps:nil];
    
    TCActivity *activity = [[TCActivity alloc] initWithId:[options valueForKey:@"activityId"] withActivityDefinition:actDef];
    
    TCVerb *verb = [options valueForKey:@"verb"];
    
    TCStatement *statementToSend = [[TCStatement alloc] initWithId:[TCUtil GetUUID] withActor:actor withTarget:activity withVerb:verb withResult:nil withContext:nil];
    
    return statementToSend;
}


-(void)saveQuizResults:(NSNumber*)percentage points:(NSNumber*)points max:(NSNumber*)maxPoints time:(NSString*)time{
    //if([self.credentials ])
    NSMutableDictionary *statementOptions = [[NSMutableDictionary alloc] init];
    [statementOptions setValue:@"https://cloud.scorm.com/tc/I40JG12M9U" forKey:@"activityId"];
    [statementOptions setValue:[[TCVerb alloc] initWithId:@"http://adlnet.gov/expapi/verbs/scored" withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"scored"]] forKey:@"verb"];
    [statementOptions setValue:@"http://adlnet.gov/expapi/activities/assessment" forKey:@"activityType"];
    
    TCStatement *statementToSend = [self createTestStatementWithOptions:statementOptions];
    NSMutableDictionary *score = [[NSMutableDictionary alloc]init];
    [score setValue:percentage forKey:@"scaled"];
    [score setValue:points forKey:@"raw"];
    [score setValue:[NSNumber numberWithInt:0] forKey:@"min"];
    [score setValue:maxPoints forKey:@"max"];

    
    TCResult *result = [[TCResult alloc]initWithResponse:[ NSString stringWithFormat: @"Quiz completed with score: %.2f", [percentage floatValue]]
                                        withScore:score
                                        withSuccess:[NSNumber numberWithBool:YES]
                                        withCompletion:[NSNumber numberWithBool:YES]
                                        withDuration:time
                                          withExtensions:nil];
    statementToSend.result = result;
    #ifdef DEBUG
    NSLog(@"%@\n", statementToSend.JSONString);
    #endif
    [self.tincan sendStatement:statementToSend withCompletionBlock:^(){
    }withErrorBlock:^(TCError *error){
        #ifdef DEBUG
        NSLog(@"ERROR: %@", error.localizedDescription);
        #endif
    }];
}


- (TCStatement *)createQuizStatementWithOptions:(NSDictionary *)options
{
    TCAgent *actor = [[TCAgent alloc] initWithName:self.credentials.name /*@"Agnieszka"*/ withMbox:[NSString stringWithFormat:@"mailto:%@", self.credentials.email] withAccount:nil];
    
    TCActivityDefinition *actDef = [[TCActivityDefinition alloc] initWithName:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"https://cloud.scorm.com/tc/I40JG12M9U"]
                                                              withDescription:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"MinPairs quzi taken"]
                                                                     withType:[options valueForKey:@"activityType"]
                                                               withExtensions:nil
                                                          withInteractionType:nil
                                                  withCorrectResponsesPattern:nil
                                                                  withChoices:nil
                                                                    withScale:nil
                                                                   withTarget:nil
                                                                    withSteps:nil];
    
    TCActivity *activity = [[TCActivity alloc] initWithId:[options valueForKey:@"activityId"] withActivityDefinition:actDef];
    
    TCVerb *verb = [options valueForKey:@"verb"];
    
    TCStatement *statementToSend = [[TCStatement alloc] initWithId:[TCUtil GetUUID] withActor:actor withTarget:activity withVerb:verb withResult:nil withContext:nil];
    
    return statementToSend;
}

/*****************************************************************************/

-(void)saveLearnExperience{
    
    NSMutableDictionary *statementOptions = [[NSMutableDictionary alloc] init];
    [statementOptions setValue:[BASE stringByAppendingString:LEARN] forKey:@"activityId"];
    [statementOptions setValue:[[TCVerb alloc] initWithId:TC_EXPERIENCED withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:TC_EXPERIENCED_DISPLAY]] forKey:@"verb"];
    [statementOptions setValue:TC_INTERACTION forKey:@"activityType"];
    
    TCStatement *statementToSend = [self createLearnStatementWithOptions:statementOptions];
#ifdef DEBUG
    NSLog(@"%@\n", statementToSend.JSONString);
#endif
    [self.tincan sendStatement:statementToSend withCompletionBlock:^(){
    }withErrorBlock:^(TCError *error){
#ifdef DEBUG
        NSLog(@"ERROR: %@", error.localizedDescription);
#endif
    }];
}

- (TCStatement *)createLearnStatementWithOptions:(NSDictionary *)options
{
    TCAgent *actor = [[TCAgent alloc] initWithName:self.credentials.name  withMbox:[NSString stringWithFormat:@"mailto:%@", self.credentials.email] withAccount:nil];
    
    
    TCActivityDefinition *actDef = [[TCActivityDefinition alloc] initWithName:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:[BASE stringByAppendingString:LEARN]]
                                                              withDescription:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"Description for test statement"]
                                                                     withType:[options valueForKey:@"activityType"]
                                                               withExtensions:nil
                                                          withInteractionType:nil
                                                  withCorrectResponsesPattern:nil
                                                                  withChoices:nil
                                                                    withScale:nil
                                                                   withTarget:nil
                                                                    withSteps:nil];
    
    TCActivity *activity = [[TCActivity alloc] initWithId:[options valueForKey:@"activityId"] withActivityDefinition:actDef];
    
    TCVerb *verb = [options valueForKey:@"verb"];
    
    TCStatement *statementToSend = [[TCStatement alloc] initWithId:[TCUtil GetUUID] withActor:actor withTarget:activity withVerb:verb withResult:nil withContext:nil];
    
    return statementToSend;
}

/*****************************************************************************/
-(void)saveSoundChartExperience{
    
    NSMutableDictionary *statementOptions = [[NSMutableDictionary alloc] init];
    [statementOptions setValue:[BASE stringByAppendingString:SOUND_CHART] forKey:@"activityId"];
    [statementOptions setValue:[[TCVerb alloc] initWithId:TC_EXPERIENCED withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:TC_EXPERIENCED_DISPLAY]] forKey:@"verb"];
    [statementOptions setValue:TC_INTERACTION forKey:@"activityType"];
    
    TCStatement *statementToSend = [self createSoundChartStatementWithOptions:statementOptions];
#ifdef DEBUG
    NSLog(@"%@\n", statementToSend.JSONString);
#endif
    [self.tincan sendStatement:statementToSend withCompletionBlock:^(){
    }withErrorBlock:^(TCError *error){
#ifdef DEBUG
        NSLog(@"ERROR: %@", error.localizedDescription);
#endif
    }];
}

- (TCStatement *)createSoundChartStatementWithOptions:(NSDictionary *)options
{
    TCAgent *actor = [[TCAgent alloc] initWithName:self.credentials.name  withMbox:[NSString stringWithFormat:@"mailto:%@", self.credentials.email] withAccount:nil];
    
    
    TCActivityDefinition *actDef = [[TCActivityDefinition alloc] initWithName:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:[BASE stringByAppendingString:SOUND_CHART]]
                                                              withDescription:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"Description for test statement"]
                                                                     withType:[options valueForKey:@"activityType"]
                                                               withExtensions:nil
                                                          withInteractionType:nil
                                                  withCorrectResponsesPattern:nil
                                                                  withChoices:nil
                                                                    withScale:nil
                                                                   withTarget:nil
                                                                    withSteps:nil];
    
    TCActivity *activity = [[TCActivity alloc] initWithId:[options valueForKey:@"activityId"] withActivityDefinition:actDef];
    
    TCVerb *verb = [options valueForKey:@"verb"];
    
    TCStatement *statementToSend = [[TCStatement alloc] initWithId:[TCUtil GetUUID] withActor:actor withTarget:activity withVerb:verb withResult:nil withContext:nil];
    
    return statementToSend;
}
/*****************************************************************************/

-(void)saveTerminate{
    
    NSMutableDictionary *statementOptions = [[NSMutableDictionary alloc] init];
    [statementOptions setValue:BASE forKey:@"activityId"];
    [statementOptions setValue:[[TCVerb alloc] initWithId:TC_TERMINATED withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:TC_TERMINATED_DISPLAY]] forKey:@"verb"];
    [statementOptions setValue:TC_COURSE forKey:@"activityType"];
    
    TCStatement *statementToSend = [self createTerminatStatementWithOptions:statementOptions];
#ifdef DEBUG
    NSLog(@"%@\n", statementToSend.JSONString);
#endif
    [self.tincan sendStatement:statementToSend withCompletionBlock:^(){
    }withErrorBlock:^(TCError *error){
#ifdef DEBUG
        NSLog(@"ERROR: %@", error.localizedDescription);
#endif
    }];
}

- (TCStatement *)createTerminatStatementWithOptions:(NSDictionary *)options
{
    TCAgent *actor = [[TCAgent alloc] initWithName:self.credentials.name  withMbox:[NSString stringWithFormat:@"mailto:%@", self.credentials.email] withAccount:nil];
    
    
    TCActivityDefinition *actDef = [[TCActivityDefinition alloc] initWithName:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:[BASE stringByAppendingString:APPLICATION]]
                                                              withDescription:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"Description for test statement"]
                                                                     withType:[options valueForKey:@"activityType"]
                                                               withExtensions:nil
                                                          withInteractionType:nil
                                                  withCorrectResponsesPattern:nil
                                                                  withChoices:nil
                                                                    withScale:nil
                                                                   withTarget:nil
                                                                    withSteps:nil];
    
    TCActivity *activity = [[TCActivity alloc] initWithId:[options valueForKey:@"activityId"] withActivityDefinition:actDef];
    
    TCVerb *verb = [options valueForKey:@"verb"];
    
    TCStatement *statementToSend = [[TCStatement alloc] initWithId:[TCUtil GetUUID] withActor:actor withTarget:activity withVerb:verb withResult:nil withContext:nil];
    
    return statementToSend;
}
/*****************************************************************************/

-(void)saveLaunch{
    
    NSMutableDictionary *statementOptions = [[NSMutableDictionary alloc] init];
    [statementOptions setValue:BASE forKey:@"activityId"];
    [statementOptions setValue:[[TCVerb alloc] initWithId:TC_LAUNCHED withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:TC_LAUNCHED_DISPLAY]] forKey:@"verb"];
    [statementOptions setValue:TC_COURSE forKey:@"activityType"];
    
    TCStatement *statementToSend = [self createLaunchStatementWithOptions:statementOptions];
#ifdef DEBUG
    NSLog(@"%@\n", statementToSend.JSONString);
#endif
    [self.tincan sendStatement:statementToSend withCompletionBlock:^(){
    }withErrorBlock:^(TCError *error){
#ifdef DEBUG
        NSLog(@"ERROR: %@", error.localizedDescription);
#endif
    }];
}

- (TCStatement *)createLaunchStatementWithOptions:(NSDictionary *)options
{
    TCAgent *actor = [[TCAgent alloc] initWithName:self.credentials.name  withMbox:[NSString stringWithFormat:@"mailto:%@", self.credentials.email] withAccount:nil];
    
    
    TCActivityDefinition *actDef = [[TCActivityDefinition alloc] initWithName:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:[BASE stringByAppendingString:APPLICATION]]
                                                              withDescription:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"Description for test statement"]
                                                                     withType:[options valueForKey:@"activityType"]
                                                               withExtensions:nil
                                                          withInteractionType:nil
                                                  withCorrectResponsesPattern:nil
                                                                  withChoices:nil
                                                                    withScale:nil
                                                                   withTarget:nil
                                                                    withSteps:nil];
    
    TCActivity *activity = [[TCActivity alloc] initWithId:[options valueForKey:@"activityId"] withActivityDefinition:actDef];
    
    TCVerb *verb = [options valueForKey:@"verb"];
    
    TCStatement *statementToSend = [[TCStatement alloc] initWithId:[TCUtil GetUUID] withActor:actor withTarget:activity withVerb:verb withResult:nil withContext:nil];
    
    return statementToSend;
}
/*****************************************************************************/


-(void)saveRegistered{
    
    NSMutableDictionary *statementOptions = [[NSMutableDictionary alloc] init];
    [statementOptions setValue:BASE forKey:@"activityId"];
    [statementOptions setValue:[[TCVerb alloc] initWithId:TC_REGISTERED withVerbDisplay:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:TC_REGISTERED_DISPLAY]] forKey:@"verb"];
    [statementOptions setValue:TC_COURSE forKey:@"activityType"];
    
    TCStatement *statementToSend = [self createRegisteredStatementWithOptions:statementOptions];
#ifdef DEBUG
    NSLog(@"%@\n", statementToSend.JSONString);
#endif
    [self.tincan sendStatement:statementToSend withCompletionBlock:^(){
    }withErrorBlock:^(TCError *error){
#ifdef DEBUG
        NSLog(@"ERROR: %@", error.localizedDescription);
#endif
    }];
}

- (TCStatement *)createRegisteredStatementWithOptions:(NSDictionary *)options
{
    TCAgent *actor = [[TCAgent alloc] initWithName:self.credentials.name  withMbox:[NSString stringWithFormat:@"mailto:%@", self.credentials.email] withAccount:nil];
    
    
    TCActivityDefinition *actDef = [[TCActivityDefinition alloc] initWithName:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:[BASE stringByAppendingString:APPLICATION]]
                                                              withDescription:[[TCLocalizedValues alloc] initWithLanguageCode:@"en-US" withValue:@"Description for test statement"]
                                                                     withType:[options valueForKey:@"activityType"]
                                                               withExtensions:nil
                                                          withInteractionType:nil
                                                  withCorrectResponsesPattern:nil
                                                                  withChoices:nil
                                                                    withScale:nil
                                                                   withTarget:nil
                                                                    withSteps:nil];
    
    TCActivity *activity = [[TCActivity alloc] initWithId:[options valueForKey:@"activityId"] withActivityDefinition:actDef];
    
    TCVerb *verb = [options valueForKey:@"verb"];
    
    TCStatement *statementToSend = [[TCStatement alloc] initWithId:[TCUtil GetUUID] withActor:actor withTarget:activity withVerb:verb withResult:nil withContext:nil];
    
    return statementToSend;
}
/*****************************************************************************/

@end
