//
//  MLXAPIOAuth.m
//  MinPairs
//
//  Created by Brandon on 2014-07-30.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLXAPIOAuth.h"

@interface MLXAPIOAuth()
@property (nonatomic, strong) void (^onErrorOccurred)(NSError* error);
@property (nonatomic, strong) void (^onLoginReady)(MLOAuthWebView* webView);
@property (nonatomic, strong) void (^onFlowComplete)(OAConsumer* consumer, OAToken* accessToken);
@property (nonatomic, strong) void (^onStatementComplete)();
@end

@implementation MLXAPIOAuth

- (void)setOnErrorCallback:(void (^)(NSError *error))onErrorOccurred
{
    _onErrorOccurred = onErrorOccurred;
}

- (void)setOnLoginReadyCallback:(void (^)(MLOAuthWebView *webView))onLoginReady
{
    _onLoginReady = onLoginReady;
}

- (void)setOnFlowCompleteCallback:(void (^)(OAConsumer *consumer, OAToken *accessToken))onFlowComplete
{
    _onFlowComplete = onFlowComplete;
}

- (void)setOnStatementCompleteCallback:(void (^)())onStatementComplete
{
    _onStatementComplete = onStatementComplete;
}

- (OAToken *)getTokenFromKeychain
{
    return [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:@"oauth_access_token" prefix:[[NSBundle mainBundle] bundleIdentifier]];
}

- (void)saveTokenToKeychain:(OAToken *)accessToken
{
    [accessToken storeInUserDefaultsWithServiceProviderName:@"oauth_access_token" prefix:[[NSBundle mainBundle] bundleIdentifier]];
}

- (void)removeTokenFromKeychain
{
    [OAToken removeFromUserDefaultsWithServiceProviderName:@"oauth_access_token" prefix:[[NSBundle mainBundle] bundleIdentifier]];
}

- (void)saveConsumer:(OAConsumer *)consumer
{
    [[NSUserDefaults standardUserDefaults] setObject:[consumer key] forKey:@"oauth_consumer_key"];
    [[NSUserDefaults standardUserDefaults] setObject:[consumer secret] forKey:@"oauth_consumer_secret"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (OAConsumer *)getConsumer
{
    NSString* key = [[NSUserDefaults standardUserDefaults] objectForKey:@"oauth_consumer_key"];
    NSString* secret = [[NSUserDefaults standardUserDefaults] objectForKey:@"oauth_consumer_secret"];
    return key && secret ? [[OAConsumer alloc] initWithKey:key secret:secret] : nil;
}

- (void)clearAllCookies
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearDomainCookies:(NSString *)domain
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies])
    {
        if ([[cookie domain] rangeOfString:domain].location != NSNotFound)
        {
            [storage deleteCookie:cookie];
        }
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (MLOAuthWebView *)startWorkflow:(NSString *)URL withKey:(NSString *)consumer_key withSecret:(NSString *)consumer_secret
{
    OAToken* accessToken = [self getTokenFromKeychain];
    
    if (accessToken && [accessToken isValid])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            OAConsumer* consumer = [[OAConsumer alloc] initWithKey:consumer_key secret:consumer_secret];
            self.onFlowComplete(consumer, accessToken);
        });
        return nil;
    }
    
    
    [self removeTokenFromKeychain];
    MLOAuthWebView* wv = [[MLOAuthWebView alloc] init];
    
    NSString* callback_url = @"minimalpairs://oauth_callback_v1";
    NSURL* initURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/OAuth/initiate", URL]];
    NSURL* authURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/OAuth/authorize", URL]];
    NSURL* tokenURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/OAuth/token", URL]];

    [wv setOnErrorCallback:[self onErrorOccurred]];
    [wv setOnLoginReadyCallback:[self onLoginReady]];
    [wv setOnFlowCompleteCallback:[self onFlowComplete]];
    
    [wv start:initURL withAuthURL:authURL withTokenURL:tokenURL withKey:consumer_key withSecret:consumer_secret withCallback:callback_url];
    return wv;
}

- (void)sendStatementManually:(OAConsumer *)consumer withToken:(OAToken *)token withStatement:(TCStatement *)statement withEndpoint:(NSString *)endpoint withVersion:(NSString *)version
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/statements?statementId=%@", endpoint, [TCUtil GetUUID]]];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url consumer:consumer token:token realm:nil signatureProvider:[[OAPlaintextSignatureProvider alloc] init]];
    [request setHTTPMethod:@"PUT"];
    [request prepare];
    
    NSString *body = [NSString stringWithFormat:@"%@", [statement JSONString], nil];
    [request setValue:version forHTTPHeaderField:@"X-Experience-API-Version"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[statement boundary] ? [NSString stringWithFormat:@"multipart/mixed; boundary=%@", statement.boundary] : @"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBodyWithString:body];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError == nil)
         {
             #ifdef DEBUG
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
             NSLog(@"Response code: %ld.", (long)[httpResponse statusCode]);
             NSLog(@"Response: %@", [data length] ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : @"Success.");
             #endif
             self.onStatementComplete();
         }
         else if ([connectionError code] == NSURLErrorTimedOut)
         {
             #ifdef DEBUG
             NSLog(@"Connection timed out.");
             #endif
             self.onErrorOccurred(connectionError);
         }
         else
         {
             #ifdef DEBUG
             NSLog(@"%@", [connectionError localizedDescription]);
             #endif
             self.onErrorOccurred(connectionError);
         }
     }];
}

- (void)sendStatement:(OAConsumer *)consumer withToken:(OAToken *)token withStatement:(TCStatement *)statement withEndpoint:(NSString *)endpoint withVersion:(NSString *)version
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/statements?statementId=%@", endpoint, [TCUtil GetUUID]]];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url consumer:consumer token:token realm:nil signatureProvider:[[OAPlaintextSignatureProvider alloc] init]];
    [request prepare];
    
    NSDictionary* headers = [request allHTTPHeaderFields];
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *lrs = [[NSMutableDictionary alloc] init];
    
    [lrs setValue:endpoint forKey:@"endpoint"];
    [lrs setValue:[headers valueForKey:@"Authorization"] forKey:@"auth"];
    
    [options setValue:version forKey:@"version"];
    [options setValue:[NSArray arrayWithObject:lrs] forKey:@"recordStore"];
    
    [[[RSTinCanConnector alloc] initWithOptions:options] sendStatement:statement withCompletionBlock:^{
        self.onStatementComplete();
    } withErrorBlock:^(TCError *error) {
        self.onErrorOccurred(error);
    }];
}
@end
