//
//  MLPackageList.m
//  MinPairsPro
//
//  Created by Oleksiy Martynov on 9/2/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLPackageList.h"

@implementation MLPackageList
-(instancetype)initWithList:(NSArray*)packageList detailServletUrl:(NSURL*)url paramName:(NSString*)packageIdParamName
{
    self=[super init];
    if(self)
    {
        self.packageList=packageList;
        self.detailsServletUrl=url;
        self.detailsServletpackageIdParamName=packageIdParamName;
    }
    return self;
}
@end
