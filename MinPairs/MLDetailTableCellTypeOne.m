//
//  MLDetailTableCellTypeOne.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 5/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLDetailTableCellTypeOne.h"
#import "MLBasicAudioPlayer.h"
@interface MLDetailTableCellTypeOne()
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewLeft;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewRight;
@property (strong, nonatomic) MLItem* correctItem;
@property (strong,nonatomic)MLBasicAudioPlayer* audioPlayer;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation MLDetailTableCellTypeOne

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)onListenBtn:(id)sender
{
    [self playItem:self.correctItem];
}
-(void)setData:(int)index : (MLItem*)correctItem : (MLItem*) userChoiceItem
{
    self.audioPlayer=[[MLBasicAudioPlayer alloc]init];
    self.indexLabel.text=[NSString stringWithFormat:@"#%i",index];
    UIImage* imgLeft =[UIImage imageNamed:correctItem.itemImageFile];
    if(imgLeft)
    {
        self.imgViewLeft.image=imgLeft;
    }
    UIImage* imgRight =[UIImage imageNamed:userChoiceItem.itemImageFile];
    if(imgRight)
    {
        self.imgViewRight.image=imgRight;
    }
    self.correctItem=correctItem;
    if(correctItem==userChoiceItem)
    {
        [self.imgViewRight setHidden:YES];
        self.bgView.backgroundColor=[UIColor colorWithRed:158.0f/255.0f green:255.0f/255.0f blue:177.0f/255.0f alpha:1.0f];
    }
    else
    {
        self.bgView.backgroundColor=[UIColor colorWithRed:255.0f/255.0f green:177.0f/255.0f blue:158.0f/255.0f alpha:1.0f];
    }
}
-(void)playItem:(MLItem*)item
{
    
    [self.audioPlayer loadFileFromResource:item.itemAudioFile withExtension: @"mp3"];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
