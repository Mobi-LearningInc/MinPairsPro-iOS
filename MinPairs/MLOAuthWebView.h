//
//  OAuthWebView.h
//  TestTincan
//
//  Created by Brandon on 2014-07-17.
//  Copyright (c) 2014 Brandon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"

@interface MLOAuthWebView : UIWebView

/**
    OPTIONALLY set an indicator for the WebView to indicate when a request is showing.
 **/
- (void)setActivityIndicator:(UIActivityIndicatorView *)indicator;

/**
    This callback MUST be set BEFORE calling "start".
    The callback function is called when any error occurs during the authentication workflow.
 
    Use this function's "error" parameter to display to the user and to terminate the connection.
 **/
- (void)setOnErrorCallback:(void (^)(NSError *error))onErrorOccurred;

/**
    This callback MUST be set BEFORE calling "start".
    The callback function is called when the webpage has loaded and is ready for the user to log in.
 
    Use this function's "webView" parameter to display on a controller.
 **/
- (void)setOnLoginReadyCallback:(void (^)(MLOAuthWebView *webView))onLoginReady;


/**
    This callback MUST be set BEFORE calling "start".
    The callback function is called when the OAuth work flow has completed SUCCESSFULLY.
    
    Use this function's "consumer" parameter to do further server communication.
    Use this function's "accessToken" parameter to do further server communication and to save in the key-chain.
 **/
- (void)setOnFlowCompleteCallback:(void (^)(OAConsumer *consumer, OAToken *accessToken))onFlowComplete;


/**
    This function MUST be called ONLY in the "onLoginReady" callback.
    This function initiates the 3 legged OAuth workflow.
    
    Start:  /OAuth/initiate
    Middle: /OAuth/authorize
    End:    /OAuth/token
 
 
    Phases:
    -------
 
          1a:   During the start phase, this function will 'POST' consumer_key & consumer_secret to /OAuth/initiate.
                This POST is encrypted using HMAC-Sha1.
 
          1b:   Along with "Phase 1a.", oauth_callback is set to a URL callback scheme set within this application.
 
    -
 
          2a:   During the middle phase, AFTER the above phase is complete, the callback is called,
                the request token is retrieved and the flow is continued when the token is 'POST' to /OAuth/authorize.
 
          2b:   Along with "Phase 2b.", oauth_token is set to the RequestToken. When the server verifies the request,
                it sends a response with: "oauth_token" & "oauth_verifier".
 
    -
 
          3a:   During the end phase, AFTER the above phase is complete, a 'POST' is sent to /OAuth/token with
                the verifier as a parameter.
 
          3b:   Once the server responsed with the access token, it can be stored in the user's keychain and
                never expires unless revoked or a duration is set.
 
    -
 
          4a:   Tokens CAN be saved using:
 
                    [[self accessToken] storeInUserDefaultsWithServiceProviderName:@"oauth_access_token" prefix:@"com.test.TestTincan"];
 
          4b:   Tokens CAN be retrieved using:
 
                    self.accessToken = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:@"oauth_access_token" prefix:@"com.test.TestTincan"];
 
 */
- (void)start:(NSURL *)initURL withAuthURL:(NSURL *)authURL withTokenURL:(NSURL *)tokenURL withKey:(NSString *)consumer_key withSecret:(NSString *)consumer_secret withCallback:(NSString *)callback;
@end
