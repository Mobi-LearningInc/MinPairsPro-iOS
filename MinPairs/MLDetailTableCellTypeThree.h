//
//  MLDetailTableCellTypeThree.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 5/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLItem.h"
@interface MLDetailTableCellTypeThree : UITableViewCell
-(void)setData:(int)index : (MLItem*)correctItem : (MLItem*) wrongItem;
@end
