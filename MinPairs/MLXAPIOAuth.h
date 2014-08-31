//
//  MLXAPIOAuth.h
//  MinPairs
//
//  Created by Brandon on 2014-07-30.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLOAuthWebView.h"
#import "RSTinCanConnector.h"


/**
    See MLOAuthWebView.h
    for better documentation of the callbacks!
 **/

@interface MLXAPIOAuth : NSObject


/** Token utilities **/

- (OAToken *)getTokenFromKeychain;

- (void)saveTokenToKeychain:(OAToken *)accessToken;

- (void)removeTokenFromKeychain;

- (void)saveConsumer:(OAConsumer *)consumer;

- (OAConsumer *)getConsumer;

- (void)clearAllCookies;

- (void)clearDomainCookies:(NSString *)domain;



/** Workflow utilities **/

- (MLOAuthWebView *)startWorkflow:(NSString *)URL withKey:(NSString *)consumer_key withSecret:(NSString *)consumer_secret;



/** Statement Utilities **/

- (void)sendStatementManually:(OAConsumer *)consumer withToken:(OAToken *)token withStatement:(TCStatement *)statement withEndpoint:(NSString *)endpoint withVersion:(NSString *)version;

- (void)sendStatement:(OAConsumer *)consumer withToken:(OAToken *)token withStatement:(TCStatement *)statement withEndpoint:(NSString *)endpoint withVersion:(NSString *)version;



/** Callbacks MUST 'ALL' be set! **/

- (void)setOnErrorCallback:(void (^)(NSError *error))onErrorOccurred;

- (void)setOnLoginReadyCallback:(void (^)(MLOAuthWebView *webView))onLoginReady;

- (void)setOnFlowCompleteCallback:(void (^)(OAConsumer *consumer, OAToken *accessToken))onFlowComplete;

- (void)setOnStatementCompleteCallback:(void (^)())onStatementComplete;

@end
