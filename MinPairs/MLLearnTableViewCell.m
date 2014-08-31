//
//  MLLearnTableViewCell.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 5/1/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLLearnTableViewCell.h"
#import "MLItem.h"
#import "MLCategory.h"
#import "MLBasicAudioPlayer.h"
#import "MLFlipButton.h"
@interface MLLearnTableViewCell()
@property (weak, nonatomic) IBOutlet MLFlipButton *btnLeft;
@property (strong,nonatomic) MLPair* itemPair;
@property (strong,nonatomic)MLPair* catPair;
@property (weak, nonatomic) IBOutlet UILabel *labelLeft;
@property (weak, nonatomic) IBOutlet UILabel *labelRight;
@property (weak, nonatomic) IBOutlet MLFlipButton *btnRight;
@property (strong,nonatomic) MLBasicAudioPlayer* audioPlayer;
@end
@implementation MLLearnTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_audioPlayer)
            self.audioPlayer =[[MLBasicAudioPlayer alloc]init];
    }
    return self;
}

- (void)awakeFromNib
{
    if (!_audioPlayer)
        self.audioPlayer = [[MLBasicAudioPlayer alloc]init];
}

-(void)setCellItemPair:(MLPair*)itemPair categoryPair:(MLPair*)catPair
{
    self.itemPair=itemPair;
    self.catPair=catPair;
    MLItem* itemLeft =itemPair.first;
    MLItem* itemRight = itemPair.second;
    MLCategory* catLeft = catPair.first;
    MLCategory* catRight=catPair.second;
    
    self.labelLeft.text=itemLeft.itemDescription;
    self.labelRight.text=itemRight.itemDescription;
    
    UIImage* imgLeft = [UIImage imageNamed:itemLeft.itemImageFile];
    UIImage* imgRight = [UIImage imageNamed:itemRight.itemImageFile];
    
    UIImage* catImgLeft = [UIImage imageNamed:catLeft.categoryImageFile];
    //NSLog(@"%@",catLeft.categoryImageFile);
    UIImage* catImgRight = [UIImage imageNamed:catRight.categoryImageFile];
    //NSLog(@"%@",catRight.categoryImageFile);
    
    if (!imgLeft)
    {
        imgLeft = [UIImage imageNamed:@"na1.png"];
    }
    
    if (!imgRight)
    {
        imgRight = [UIImage imageNamed:@"na1.png"];
    }
    
    if (!catImgLeft)
    {
        catImgLeft = [UIImage imageNamed:@"na1.png"];
    }
    
    if (!catImgRight)
    {
        catImgRight = [UIImage imageNamed:@"na1.png"];
    }
    
    [self.btnLeft setFaceImagesWithFrontFace:imgLeft backFace:catImgLeft];
    [self.btnLeft registerFlipListener:self];
    [self.btnRight setFaceImagesWithFrontFace:imgRight backFace:catImgRight];
    [self.btnRight registerFlipListener:self];
}
- (IBAction)onLeftBtnTap:(id)sender //not used anymore
{
    //[self playItem:self.itemPair.first];
}
- (IBAction)onRightBtnTap:(id)sender //not used anymore
{
    //[self playItem:self.itemPair.second];
}
-(void)playItem:(MLItem*)item
{
    
    [self.audioPlayer loadFileFromResource:item.itemAudioFile withExtension: @"mp3"];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    
    #ifdef DEBUG
    NSLog(@"Played sound for %@",item.itemDescription);
    #endif
}
-(void)playCat:(MLCategory*)cat
{
    [self.audioPlayer loadFileFromResource:cat.categoryAudioFile withExtension: @"mp3"];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    
#ifdef DEBUG
    NSLog(@"Played sound for %@",cat.categoryDescription);
#endif
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) flippedToFront:(id) obj
{
    if(obj==self.btnLeft)
    {
        [self playCat:self.catPair.first];
    }
    else if(obj==self.btnRight)
    {
        [self playCat:self.catPair.second];
    }
}
-(void) flippedToBack:(id) obj
{
    if(obj==self.btnLeft)
    {
        [self playItem:self.itemPair.first];
    }
    else if(obj==self.btnRight)
    {
        [self playItem:self.itemPair.second];
    }
}
@end
