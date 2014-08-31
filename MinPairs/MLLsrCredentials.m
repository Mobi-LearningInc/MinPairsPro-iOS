//
//  MLLsrCredentials.m
//  MinPairs
//
//  Created by MLinc on 2014-05-08.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLLsrCredentials.h"

@implementation MLLsrCredentials
-(instancetype)initCredentialsWithId:(int) credId appName:(NSString*)appName key:(NSString*)key secret:(NSString*)secret address:(NSString *)address appUserName:(NSString *)appUserName email:(NSString *)email
{
    self=[super init];
    if(self)
    {
        self.credentialId = credId;
        self.appName=appName;
        self.key=key;
        self.secret=secret;
        self.address = address;
        self.name = appUserName;
        self.email = email ;
    }
    return self;
}

-(instancetype)initCredentialsWithId:(int) credId appName:(NSString*)appName userName:(NSString*)userName password:(NSString*)password address:(NSString *)address appUserName:(NSString *)appUserName email:(NSString *)email
{
    self=[super init];
    if(self)
    {
        self.credentialId = credId;
        self.appName=appName;
        self.userName =userName;
        self.password=password;
        self.address = address;
        self.name = appUserName;
        self.email = email ;
    }
    return self;
}


-(NSString *)encodedCredentials{
    
    NSString *myText = [NSString stringWithFormat:@"%@:%@", self.userName, self.password];
    return [NSString stringWithFormat:@"Basic %@", [[myText dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0]];
}

@end
