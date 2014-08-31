//
//  MLFlipButtonOnFlipProtocol.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 7/25/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MLFlipButtonOnFlipProtocol <NSObject>
-(void) flippedToFront:(id) obj;
-(void) flippedToBack:(id) obj;
@end
