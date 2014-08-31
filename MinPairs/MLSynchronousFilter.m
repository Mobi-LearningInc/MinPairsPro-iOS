//
//  MLSynchronousFilter.m
//  MinPairs
//
//  Created by Brandon on 2014-04-26.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLSynchronousFilter.h"
#import "MLPair.h"

@interface MLSynchronousFilter()
@property (nonatomic, strong) NSArray* categories;
@property (nonatomic, strong) NSMutableArray* mappedSounds;
@property (nonatomic, strong) MLMainDataProvider* provider;
@end

@implementation MLSynchronousFilter

+(MLSynchronousFilter*) sharedInstance
{
    static dispatch_once_t onceToken = 0;
    static MLSynchronousFilter* instance = nil;
    
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone: nil] init];
        
        instance->_mappedSounds = nil;
        instance->_provider = [[MLMainDataProvider alloc] initMainProvider];
        NSArray* catPairs = [instance->_provider getCategoryPairs];
        NSMutableArray* catLeft = [NSMutableArray array];
        
        
        int (^find)(MLCategory*, NSMutableArray*) = ^(MLCategory* a, NSMutableArray* b) {
            for (MLCategory* c in b) {
                if ([c categoryId] == [a categoryId])
                    return true;
            }
            return false;
        };
        
        for (int i=0; i<catPairs.count; i++)
        {
            MLPair* p =[catPairs objectAtIndex:i];
            
            if (!find(p.first, catLeft))
            {
                [catLeft addObject: p.first];
            }
        }
        instance->_categories = catLeft;
    });
    
    return instance;
}

+(id) allocWithZone:(NSZone*)zone
{
    return [self sharedInstance];
}

-(id) copyWithZone:(NSZone*)zone
{
    return self;
}

+(NSArray*)getLeft
{
    return [[MLSynchronousFilter sharedInstance] categories];
}

+(NSMutableArray*)getCategoriesRight:(MLCategory*) category
{
    bool found = false;
    MLSynchronousFilter* filter = [MLSynchronousFilter sharedInstance];
    
    NSArray* pairs = [[filter provider] getCategoryPairs];
    filter.mappedSounds = [[NSMutableArray alloc] init];
    
    for (MLPair* pair in pairs)
    {
        MLCategory* cat = [pair first];
        
        if ([cat categoryId] == [category categoryId])
        {
            [[filter mappedSounds] addObject: [pair second]];
            found = true;
        }
    }
    return found ? [filter mappedSounds] : nil;
}

@end
