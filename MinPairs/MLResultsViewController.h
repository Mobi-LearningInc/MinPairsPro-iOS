//
//  MLResultsViewController.h
//  MinPairs
//
//  Created by Brandon on 2014-05-09.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLResultsViewController : UIViewController
@property (assign, nonatomic) bool mode;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* correct;
@property (strong, nonatomic) NSString* wrong;
@property (strong, nonatomic) NSString* total;
@property (strong, nonatomic) NSString* time;
@property (strong, nonatomic) NSMutableArray* detailsArray;
@end
