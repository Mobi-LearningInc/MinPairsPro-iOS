//
//  MLPackageDownloader.h
//  MinPairsPro
//
//  Created by Oleksiy Martynov on 9/1/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLPackageDownloader : NSObject
#define SERVER_PACKAGELIST_ADDRESS [NSURL URLWithString: @"http://mlpackageserv.appspot.com/packageinfo"]
#define SERVER_ADDRESS [NSURL URLWithString: @"http://mlpackageserv.appspot.com"]
#define SERVLET_PACKAGELIST [NSURL URLWithString: @"packageinfo"]

-(NSArray*)getDownloadablePackages;
@end
