//
//  MLSynchronousFilter.h
//  MinPairs
//
//  Created by Brandon on 2014-04-26.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLMainDataProvider.h"

@interface MLSynchronousFilter : NSObject

+(MLSynchronousFilter*) sharedInstance;

+(NSMutableArray*)getLeft;

+(NSMutableArray*)getCategoriesRight:(MLCategory*) category;

@end
