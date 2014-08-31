//
//  MLDetailsItem.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 5/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLDetailsItem.h"

@implementation MLDetailsItem
-(instancetype)initDetailsItemWithType:(int)type correctItem:(MLItem*)cItem userItem:(MLItem*)uItem status:(bool)correct index:(int)num
{
    self=[super init];
    if(self)
    {
        self.detailType=type;
        self.correctItem=cItem;
        self.userItem=uItem;
        self.detailCorrect=correct;
        self.detailNumber=num;
    }
    return self;
}
@end
