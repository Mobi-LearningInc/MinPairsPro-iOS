//
//  MLPackageDownloader.h
//  MinPairsPro
//
//  Created by Oleksiy Martynov on 9/1/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLPackageList.h"
#import "MLPackageFileList.h"
@interface MLPackageDownloader : NSObject
#define SERVER_PACKAGELIST_ADDRESS [NSURL URLWithString: @"http://mlpackageserv.appspot.com/packageinfo"]
#define SERVER_ADDRESS [NSURL URLWithString: @"http://mlpackageserv.appspot.com"]

#define PACKAGELIST_SERVLET_NAME  @"packageinfo"
#define PACKAGELIST_JSON_KEY_PACKAGELIST @"packageList"

#define PACKAGELIST_JSON_KEY_DETAIL_SERVLET_NAME @"detailServlet"
#define PACKAGELIST_JSON_KEY_DETAIL_SERVLET_PARAM_NAME_PACKAGE_ID @"detailServletParamName"

#define PACKAGEDETAIL_JSON_KEY_FILELIST @"fileList"
#define PACKAGEDETAIL_JSON_KEY_FILE_SERVLET_NAME @"fileLoaderServlet"
#define PACKAGEDETAIL_JSON_KEY_FILE_SERVLET_PARAM_NAME_PACKAGE_ID @"fileLoaderServletPackageIdParamName"
#define PACKAGEDETAIL_JSON_KEY_FILE_SERVLET_PARAM_NAME_FILE_ID @"fileLoaderServletFileIdParamName"
#define PACKAGEDETAIL_JSON_KEY_FILE_SERVLET_PARAM_NAME_RETINA_SUFFIX @"pngImageSuffix"

-(MLPackageList*)getDownloadablePackages;
-(MLPackageFileList*)getFileUrlForPackage:(MLPackageList*)list packageName:(NSString*)packageId;
-(void)saveFilesToDisk:(MLPackageFileList*)files;
@end
