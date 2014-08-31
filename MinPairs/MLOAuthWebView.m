//
//  OAuthWebView.m
//  TestTincan
//
//  Created by Brandon on 2014-07-17.
//  Copyright (c) 2014 Brandon. All rights reserved.
//

#import "MLOAuthWebView.h"

@interface MLOAuthWebView()<UIWebViewDelegate>
@property (nonatomic, strong) OAConsumer* consumer;
@property (nonatomic, strong) OAToken* requestToken;
@property (nonatomic, strong) OAToken* accessToken;
@property (nonatomic, strong) NSURL* authURL;
@property (nonatomic, strong) NSURL* tokenURL;
@property (nonatomic, strong) NSString* callback;
@property (nonatomic, strong) NSString* verifier;
@property (nonatomic, strong) UIActivityIndicatorView* indicator;

@property (nonatomic, assign) bool loaded;
@property (nonatomic, assign) bool loginReady;
@property (nonatomic, assign) bool flowComplete;
@property (nonatomic, strong) void (^onErrorOccurred)(NSError* error);
@property (nonatomic, strong) void (^onLoginReady)(MLOAuthWebView* webView);
@property (nonatomic, strong) void (^onFlowComplete)(OAConsumer* consumer, OAToken* accessToken);
@end

@implementation MLOAuthWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setHidden:true];
    }
    return self;
}

- (void)setActivityIndicator:(UIActivityIndicatorView *)indicator
{
    _indicator = indicator;
}

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

- (void)start:(NSURL *)initURL withAuthURL:(NSURL *)authURL withTokenURL:(NSURL *)tokenURL withKey:(NSString *)consumer_key withSecret:(NSString *)consumer_secret withCallback:(NSString *)callback
{
    _authURL = authURL;
    _tokenURL = tokenURL;
    _callback = callback;
    
    _loginReady = false;
    _flowComplete = false;
    [self stopLoading];
    
    self.consumer = [[OAConsumer alloc] initWithKey:consumer_key secret:consumer_secret];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:initURL consumer:[self consumer] token:nil realm:nil signatureProvider:nil];
    [request setHTTPMethod:@"POST"];
    
    NSArray *params = [NSArray arrayWithObjects: [[OARequestParameter alloc] initWithName:@"oauth_callback" value:callback ? callback : @"oob"], nil];
    
    [request setParameters:params];
    [request prepare];
    
    OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
    [dataFetcher fetchDataWithRequest:request delegate:self didFinishSelector:@selector(onRequestTokenSuccess:withData:) didFailSelector:@selector(onRequestTokenFail:withError:)];
}

- (void)onRequestTokenSuccess:(OAServiceTicket *)ticket withData:(NSData *)data
{
    if (ticket.didSucceed)
    {
        self.requestToken = [[OAToken alloc] initWithHTTPResponseBody:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        
        OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:[self authURL] consumer:[self consumer] token:nil realm:nil signatureProvider:nil];

        NSArray *params = [NSArray arrayWithObject: [[OARequestParameter alloc] initWithName:@"oauth_token" value: [[self requestToken] key]]];
        
        [request setParameters:params];
        [request prepare];
        
        [self setDelegate:self];
        [self loadRequest:request];
    }
    else
    {
        NSDictionary *user_info = [NSDictionary dictionaryWithObjectsAndKeys:@"Failed to retrieved request token.", NSLocalizedDescriptionKey, @"Invalid Credentials.", NSLocalizedFailureReasonErrorKey, @"The operation couldn't be completed.", NSUnderlyingErrorKey, nil, NSURLErrorKey, nil];
        
        NSError *error = [NSError errorWithDomain:@"CustomError" code:-1 userInfo:user_info];
        self.onErrorOccurred(error);
    }
}

- (void)onRequestTokenFail:(OAServiceTicket *)ticket withError:(NSError *)error
{
    self.onErrorOccurred(error);
}

- (void)onAccessTokenSuccess:(OAServiceTicket *)ticket withData:(NSData *)data
{
    if (ticket.didSucceed)
    {
        self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        
        if (![self flowComplete])
        {
            _flowComplete = true;
            [[self accessToken] setVerifier: [self verifier]];
            self.verifier = nil;
            self.onFlowComplete([self consumer], [self accessToken]);
        }
    }
    else
    {
        NSDictionary *user_info = [NSDictionary dictionaryWithObjectsAndKeys:@"Failed to retrieved request token.", NSLocalizedDescriptionKey, @"Invalid Request Token.", NSLocalizedFailureReasonErrorKey, @"The operation couldn't be completed.", NSUnderlyingErrorKey, nil, NSURLErrorKey, nil];
        
        NSError *error = [NSError errorWithDomain:@"CustomError" code:-1 userInfo:user_info];
        self.onErrorOccurred(error);
    }
}

- (void)onAccessTokenFail:(OAServiceTicket *)ticket withError:(NSError *)error
{
    self.onErrorOccurred(error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([self callback] && [[[request URL] absoluteString] rangeOfString:[self callback]].location == 0)
    {
        NSDictionary *params = [self parseQueryString: [[request URL] query]];
        self.verifier = [params objectForKey:@"oauth_verifier"];
        
        if ([self verifier])
        {
            OAMutableURLRequest* access = [[OAMutableURLRequest alloc] initWithURL:[self tokenURL] consumer:[self consumer] token:[self requestToken] realm:nil signatureProvider:nil];
            [access setHTTPMethod:@"POST"];
            
            NSArray *params = [NSArray arrayWithObject: [[OARequestParameter alloc] initWithName:@"oauth_verifier" value: [self verifier]]];
            
            [access setParameters:params];
            [access prepare];
            
            OADataFetcher* dataFetcher = [[OADataFetcher alloc] init];
            [dataFetcher fetchDataWithRequest:access delegate:self didFinishSelector:@selector(onAccessTokenSuccess:withData:) didFailSelector:@selector(onAccessTokenFail:withError:)];
        }
        else
        {
            NSDictionary *user_info = [NSDictionary dictionaryWithObjectsAndKeys:@"Failed to retrieve AccessToken Verifier.", NSLocalizedDescriptionKey, @"Invalid Verifier.", NSLocalizedFailureReasonErrorKey, @"The operation couldn't be completed.", NSUnderlyingErrorKey, nil, NSURLErrorKey, nil];
            
            NSError *error = [NSError errorWithDomain:@"CustomError" code:-1 userInfo:user_info];
            self.onErrorOccurred(error);
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([self indicator])
    {
        [[self indicator] setHidden: false];
        [[self indicator] startAnimating];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self indicator])
    {
        [[self indicator] stopAnimating];
        [[self indicator] setHidden: true];
    }
    
    if (![self loginReady])
    {
        _loginReady = true;
        if (!_loaded)
        {
            _loaded = true;
            [self setHidden:false];
        }
        self.onLoginReady(self);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([self indicator])
    {
        [[self indicator] stopAnimating];
        [[self indicator] setHidden: true];
    }
    
    if (error.code == NSURLErrorCancelled) return;
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) return;
    
    self.onErrorOccurred(error);
}

- (NSDictionary *)parseQueryString:(NSString *)query
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *components = [query componentsSeparatedByString:@"&"];
    
    for (NSString *component in components)
    {
        NSArray *params = [component componentsSeparatedByString:@"="];
        NSString *key = [[params objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[params objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [result setObject:val forKey:key];
    }
    return result;
}
@end
