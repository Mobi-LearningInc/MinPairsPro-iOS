//
//  MLFlipButton.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 7/25/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLFlipButtonOnFlipProtocol.h"
@interface MLFlipButton : UIButton
-(void)registerFlipListener:(id<MLFlipButtonOnFlipProtocol>) listener;
-(void)setFaceImagesWithFrontFace:(UIImage*)frontFaceImage backFace:(UIImage*) backFaceImage;
@end
