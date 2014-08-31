//
//  MLFilterViewController.h
//  MinPairs
//
//  Created by Brandon on 2014-04-26.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLSynchronousFilter.h"
#import "MLPair.h"
#import "MLFilterChangeListener.h"
@interface MLFilterViewController : UIViewController
@property id<MLFilterChangeListener> listener;
@end
