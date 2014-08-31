//
//  MLPair.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * @class MLPair
 * @discussion MLPair class stores pairs of any type
 */

@interface MLPair : NSObject
///first item
@property (strong,nonatomic)id first;
///second item
@property (strong,nonatomic)id second;
/*! Constructs instance of MLPair class
 * \param first object
 * \param second object
 * \returns instance of MLPair
 */
-(instancetype)initPairWithFirstObject:(id)firstObject secondObject:(id)secondObject;
@end
