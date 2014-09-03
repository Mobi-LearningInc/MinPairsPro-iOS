//
//  MLPackageFileList.m
//  MinPairsPro
//
//  Created by Oleksiy Martynov on 9/2/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLPackageFileList.h"

@implementation MLPackageFileList
-(instancetype) initPackageFileList: (NSArray*)list packageName:(NSString*)packageId fileServletAddress:(NSURL*)url paramNamePackageId: (NSString*) fileServletPackageId paramNameFileId:(NSString*)fileServletFileId retinaSuffix:(NSString*)retinaImageSuffix
{
    self=[super init];
    if(self)
    {
        self.list=list;
        self.fileServletUrl=url;
        self.fileServletFileIdParamName=fileServletFileId;
        self.fileServletPackageIdParamName=fileServletPackageId;
        self.retinaImageNameSuffix=retinaImageSuffix;
        self.fileServletPackageIdValue =packageId;
    }
    return self;
}
@end
