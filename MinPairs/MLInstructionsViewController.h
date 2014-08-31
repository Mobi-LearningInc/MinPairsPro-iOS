//
//  MLInstructionsViewController.h
//  MinPairs
//
//  Created by Brandon on 2014-05-10.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLFilterChangeListener.h"

@interface MLInstructionsViewController : UIViewController<MLFilterChangeListener>
@property (nonatomic, strong) NSNumber* mode;
@end
