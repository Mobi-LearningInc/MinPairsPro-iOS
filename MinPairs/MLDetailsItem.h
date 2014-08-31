//
//  MLDetailsItem.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 5/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLItem.h"

#define DETAIL_TYPE_ONE 1
#define DETAIL_TYPE_TWO 2
#define DETAIL_TYPE_THREE 3
@interface MLDetailsItem : NSObject
@property int detailType;
@property int detailNumber;//question number
@property (strong,nonatomic) MLItem* correctItem;
@property (strong,nonatomic) MLItem* userItem;
@property bool detailCorrect;//true if user answered question correctly
-(instancetype)initDetailsItemWithType:(int)type correctItem:(MLItem*)cItem userItem:(MLItem*)uItem status:(bool)correct index:(int)num;
@end
