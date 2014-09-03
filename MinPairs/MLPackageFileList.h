//
//  MLPackageFileList.h
//  MinPairsPro
//
//  Created by Oleksiy Martynov on 9/2/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLPackageFileList : NSObject
@property (strong, nonatomic) NSArray* list;
@property (strong,nonatomic) NSURL* fileServletUrl;
@property (strong,nonatomic) NSString* fileServletPackageIdParamName;
@property (strong,nonatomic) NSString* fileServletPackageIdValue;
@property (strong,nonatomic) NSString* fileServletFileIdParamName;
@property (strong,nonatomic) NSString* retinaImageNameSuffix;


-(instancetype) initPackageFileList: (NSArray*)list packageName:(NSString*)packageId fileServletAddress:(NSURL*)url paramNamePackageId: (NSString*) fileServletPackageId paramNameFileId:(NSString*)fileServletFileId retinaSuffix:(NSString*)retinaImageSuffix;
@end
