//
//  MLFlipButton.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 7/25/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLFlipButton.h"
@interface MLFlipButton()
@property id<MLFlipButtonOnFlipProtocol> listener;
@property bool faceUp;//true if button's face is up, false if back is up
@property UIImage* frontImg;
@property UIImage* backImg;
@end
@implementation MLFlipButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
        self.faceUp=true;
        
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addTarget:self action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
        self.faceUp=true;
        
    }
    return self;
}
-(id)init
{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
        self.faceUp=true;
        
    }
    return self;
}
-(void)registerFlipListener:(id<MLFlipButtonOnFlipProtocol>) listener
{
    self.listener=listener;
}
-(void)setFaceImagesWithFrontFace:(UIImage*)frontFaceImage backFace:(UIImage*) backFaceImage
{
    self.frontImg=frontFaceImage;
    self.backImg=backFaceImage;
    if(self.faceUp)
    {
        [self setImage:self.frontImg forState:UIControlStateNormal];
    }
    else
    {
        [self setImage:self.backImg forState:UIControlStateNormal];
    }
    
    
}
- (void)didTouchButton
{    
    self.faceUp=!self.faceUp;
    
        if(self.faceUp)
        {
            
            [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
                if(self.frontImg)
                {
                    [self setImage:self.frontImg forState:UIControlStateNormal];
                }
            } completion: ^(BOOL done){if(self.listener)
            {
                [self.listener flippedToFront:self];
            }}];
            
        }
        else
        {
            [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
                if(self.backImg)
                {
                    [self setImage:self.backImg forState:UIControlStateNormal];
                }
            } completion: ^(BOOL done){
                if(self.listener)
                {
                    [self.listener flippedToBack:self];
                }}];
            
        }
    
    
}
@end
