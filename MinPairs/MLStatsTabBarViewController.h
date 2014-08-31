//
//  MLStatsTabBarViewController.h
//  MinPairs
//
//  Created by Brandon on 2014-05-25.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLFilterChangeListener.h"
#import "MLMutableSortedDictionary.h"

@interface MLStatsTabBarViewController : UITabBarController<MLFilterChangeListener>
@property (nonatomic, strong) MLMutableSortedDictionary* barGraphResults;
@property (nonatomic, strong) MLMutableSortedDictionary* lineGraphResults;
@property (nonatomic, strong) NSString* filterTitle;
@end
