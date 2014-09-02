//
//  MLPackageList.h
//  MinPairsPro
//
//  Created by Oleksiy Martynov on 9/2/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLPackageList : NSObject
@property (strong,nonatomic) NSArray* packageList;
@property (strong,nonatomic) NSURL* detailsServletUrl;
@property (strong,nonatomic) NSString* detailsServletpackageIdParamName;
-(instancetype)initWithList:(NSArray*)packageList detailServletUrl:(NSURL*)url paramName:(NSString*)packageIdParamName;
@end
