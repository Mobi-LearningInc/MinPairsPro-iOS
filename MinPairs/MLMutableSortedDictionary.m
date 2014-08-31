//
//  MLMutableSortedDictionary.m
//  MinPairs
//
//  Created by Brandon on 2014-06-12.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLMutableSortedDictionary.h"

@interface MLMutableSortedDictionary()
@property (nonatomic, assign) bool sortMode;
@property (nonatomic, strong) NSMutableArray* Keys;
@property (nonatomic, strong) NSMutableArray* Values;
@property (nonatomic, strong) NSComparisonResult (^comparator)(id, id);
@end

@implementation MLMutableSortedDictionary

- (instancetype)init
{
    self = [super init];
    if (self) {
        _comparator = nil;
        _sortMode = false;
        _Keys = [NSMutableArray array];
        _Values = [NSMutableArray array];
    }
    return self;
}

-(void)setComparator:(NSComparisonResult(^)(id, id))cmp
{
    _comparator = cmp;
}

-(void)setSortMode:(bool)sortKeys
{
    _sortMode = sortKeys;
}

-(NSArray*)allKeys
{
    return _Keys;
}

-(NSArray*)allValues
{
    return _Values;
}

-(NSUInteger)count
{
    return [_Keys count];
}

-(NSUInteger)insertionPosition:(id)Obj
{
    if (!_comparator)
    {
        return [_Values count];
    }
    
    if (_sortMode)
    {
        return [_Keys indexOfObject:Obj inSortedRange:NSMakeRange(0, [_Keys count]) options: NSBinarySearchingInsertionIndex usingComparator: _comparator];
    }
    
    return [_Values indexOfObject:Obj inSortedRange:NSMakeRange(0, [_Values count]) options: NSBinarySearchingInsertionIndex usingComparator: _comparator];
}

-(void) setObject:(id)Obj forKey:(id)Key
{
    NSUInteger index = [_Keys indexOfObject: Key];
    
    if (index != NSNotFound)
    {
        [_Values replaceObjectAtIndex:index withObject:Obj];
    }
    else
    {
        NSUInteger pos = _sortMode ? [self insertionPosition:Key] : [self insertionPosition:Obj];
        [_Keys insertObject:Key atIndex: pos];
        [_Values insertObject:Obj atIndex: pos];
    }
}

-(id) objectForKey:(id)Key
{
    NSUInteger index = [_Keys indexOfObject:Key];
    return index != NSNotFound ? [_Values objectAtIndex:index] : nil;
}

-(NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [_Keys countByEnumeratingWithState:state objects:buffer count:len];
}
@end
