//
//  MLDetailTableCellTypeThree.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 5/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLDetailTableCellTypeThree.h"
#import "MLBasicAudioPlayer.h"
@interface MLDetailTableCellTypeThree()

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *readLabel;
@property (strong, nonatomic) MLItem* correctItem;
@property (strong, nonatomic) MLItem* userChoiceItem;
@property (strong,nonatomic)MLBasicAudioPlayer* audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation MLDetailTableCellTypeThree

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)onListenLeft:(id)sender
{
    [self playItem:self.correctItem];
}
- (IBAction)onListenRight:(id)sender
{
    [self playItem:self.userChoiceItem];
}
-(void)setData:(int)index : (MLItem*)correctItem : (MLItem*) userChoiceItem
{
    self.audioPlayer=[[MLBasicAudioPlayer alloc]init];
    self.indexLabel.text=[NSString stringWithFormat:@"#%i",index];
    self.correctItem=correctItem;
    self.userChoiceItem=userChoiceItem;
    self.readLabel.text=[correctItem.itemDescription capitalizedString];
    if(correctItem==userChoiceItem)
    {
        [self.rightBtn setHidden:YES];
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
