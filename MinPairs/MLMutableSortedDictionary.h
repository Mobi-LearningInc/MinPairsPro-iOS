//
//  MLMutableSortedDictionary.h
//  MinPairs
//
//  Created by Brandon on 2014-06-12.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLMutableSortedDictionary : NSObject<NSFastEnumeration>
-(void)setComparator:(NSComparisonResult(^)(id, id))cmp;
-(void)setSortMode:(bool)sortKeys;
-(void) setObject:(id)Obj forKey:(id)Key;
-(id) objectForKey:(id)Key;
-(NSArray*)allKeys;
-(NSArray*)allValues;
-(NSUInteger)count;
@end
