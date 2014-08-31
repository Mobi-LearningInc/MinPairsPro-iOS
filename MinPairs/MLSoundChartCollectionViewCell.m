//
//  MLSoundChartCollectionViewCell.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLSoundChartCollectionViewCell.h"

@interface MLSoundChartCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) MLCategory* category;

@end
@implementation MLSoundChartCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)flipAnimate:(NSString*) wordFile
{
    UIImage* image = nil;
    
    if (wordFile)
    {
        image = [UIImage imageNamed: wordFile];
    }
    else
    {
        image = [UIImage imageNamed: self.category.categoryImageFile];
    }
    
    if (!image)
    {
        image = [UIImage imageNamed:SOUND_CHART_CELL_DEFAULT_IMAGE];
    }
    
    [UIView transitionWithView:[self imageView] duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [self.imageView setImage:image];
    } completion: nil];
}

-(void)setCellCategory:(MLCategory*)category
{
    self.category=category;
    UIImage *image = [UIImage imageNamed: category.categoryImageFile];
    if(!image)
    {
        image = [UIImage imageNamed:SOUND_CHART_CELL_DEFAULT_IMAGE];
    }
    [self.imageView setImage:image];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
