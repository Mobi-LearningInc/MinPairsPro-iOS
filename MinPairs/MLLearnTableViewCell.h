//
//  MLLearnTableViewCell.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 5/1/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPair.h"
#import "MLFlipButtonOnFlipProtocol.h"
@interface MLLearnTableViewCell : UITableViewCell <MLFlipButtonOnFlipProtocol>

-(void)setCellItemPair:(MLPair*)itemPair categoryPair:(MLPair*)catPair;
@end
