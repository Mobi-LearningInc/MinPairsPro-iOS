//
//  MLPackageDownloader.m
//  MinPairsPro
//
//  Created by Oleksiy Martynov on 9/1/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLPackageDownloader.h"

@implementation MLPackageDownloader
-(NSArray*)getDownloadablePackages
{
    /*
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        SERVER_PACKAGELIST_ADDRESS];
        [self performSelectorOnMainThread:@selector(processData:)
                               withObject:data waitUntilDone:YES];
    });
     */
    NSData* data = [NSData dataWithContentsOfURL:
                    SERVER_PACKAGELIST_ADDRESS];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    NSArray* packages = [json objectForKey:@"packageList"];
    return packages;
}
-(void)processData:(NSData *)responseData
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    NSArray* packages = [json objectForKey:@"packageList"];
    
    //NSLog(@"packages: %@", packages);
}
@end
