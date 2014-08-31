//
//  MLCategory.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLCategory.h"

@implementation MLCategory
-(instancetype)initCategoryWithId:(int)catId description:(NSString*)description audioPath:(NSString*)audioFile imagePath:(NSString*)imageFile seperator:(NSString*)seperator
{
    self=[super init];
    if(self)
    {
        self.categoryId=catId;
        self.categoryDescription=description;
        self.categoryAudioFile=audioFile;
        self.categoryImageFile=imageFile;
        self.categorySeparator=seperator;
    }
    return self;
}
@end
