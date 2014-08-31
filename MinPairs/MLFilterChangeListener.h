//
//  MLFilterChangeListener.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 5/30/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLPair.h"
@protocol MLFilterChangeListener <NSObject>
-(void)onFilterSelectionChange:(MLPair*)itemPair;
@end
