//
//  MLItem.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLItem.h"

@implementation MLItem
-(instancetype)initItemWithId:(int)itemId description:(NSString*)description audioPath:(NSString*)audioFile imagePath:(NSString*)imageFile seperator:(NSString*)seperator
{
    self=[super init];
    if(self)
    {
        self.itemId=itemId;
        self.itemDescription=description;
        self.itemAudioFile=audioFile;
        self.itemImageFile=imageFile;
        self.itemSeparator=seperator;
    }
    return self;
}
@end
