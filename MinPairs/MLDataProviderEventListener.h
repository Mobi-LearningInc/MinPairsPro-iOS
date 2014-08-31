//
//  MLDataProviderEventListener.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/25/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *Classes that wish to rececieve calls on load start and load finish by the data provider
 *must conform to this protocol
 */
@protocol MLDataProviderEventListener <NSObject>
-(void)onLoadStart;
-(void)onLoadFinish;
@end
