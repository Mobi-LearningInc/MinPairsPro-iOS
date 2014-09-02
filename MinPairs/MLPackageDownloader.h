//
//  MLPackageDownloader.h
//  MinPairsPro
//
//  Created by Oleksiy Martynov on 9/1/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLPackageList.h"
@interface MLPackageDownloader : NSObject
#define SERVER_PACKAGELIST_ADDRESS [NSURL URLWithString: @"http://mlpackageserv.appspot.com/packageinfo"]
#define SERVER_ADDRESS [NSURL URLWithString: @"http://mlpackageserv.appspot.com"]
#define PACKAGELIST_SERVLET_NAME  @"packageinfo"
#define PACKAGELIST_JSON_KEY_PACKAGELIST @"packageList"
#define PACKAGELIST_JSON_KEY_DETAIL_SERVLET_NAME @"detailServlet"
#define PACKAGELIST_JSON_KEY_DETAIL_SERVLET_PARAM_NAME_PACKAGE_ID @"detailServletParamName"
#define PACKAGEDETAIL_JSON_KEY_FILELIST @"fileList"

-(MLPackageList*)getDownloadablePackages;
-(NSArray*)getFileUrlForPackage:(MLPackageList*)list packageName:(NSString*)packageId;
@end
