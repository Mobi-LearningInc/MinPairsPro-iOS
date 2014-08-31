//
//  MLPair.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLPair.h"

@implementation MLPair
-(instancetype)initPairWithFirstObject:(id)firstObject secondObject:(id)secondObject
{
    self=[super init];
    if(self)
    {
        self.first=firstObject;
        self.second=secondObject;
    }
    return self;
}
@end
