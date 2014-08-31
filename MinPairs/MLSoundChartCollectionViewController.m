//
//  MLSoundChartCollectionViewController.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLSoundChartCollectionViewController.h"
#import "MLHelpViewController.h"
#import "MLMainDataProvider.h"
#import "MLSoundChartCollectionViewCell.h"
#import "MLBasicAudioPlayer.h"
#import "MLPair.h"
#import "MLTheme.h"

@interface MLSoundChartCollectionViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property NSArray* catArr;
@property (nonatomic, strong) MLBasicAudioPlayer* audioPlayer;
@end

@implementation MLSoundChartCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)onLoadStart
{
    [self.loadingIndicator startAnimating];
    [self.loadingIndicator setHidesWhenStopped:YES];
}

-(void)onLoadFinish
{
    [self.loadingIndicator stopAnimating];
}

- (IBAction)onHomeClicked:(UIBarButtonItem *)sender
{
    [[self navigationController] popViewControllerAnimated:true];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [MLTheme updateTheme];
}

- (void)viewDidLoad
{
    [MLTheme setTheme: self];
    [super viewDidLoad];
    MLMainDataProvider* dataProvider=[[MLMainDataProvider alloc]initMainProvider];
    NSArray* catArr=[dataProvider getCategoriesCallListener:self];
    self.catArr =[catArr subarrayWithRange:NSMakeRange(1, catArr.count-1)];//removes the 'All' item
    self.audioPlayer = [[MLBasicAudioPlayer alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Collection View Data Sources

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.catArr count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MLSoundChartCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"soundChartCellIdentifier" forIndexPath:indexPath];
    [cell setCellCategory:[self.catArr objectAtIndex:indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MLSoundChartCollectionViewCell *cell = (MLSoundChartCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSString* soundFileName = @"";
    MLCategory* selectedCategory = [self.catArr objectAtIndex:indexPath.row];
    if(cell.tapCount==0)
    {
        cell.needsToPlayCategorySound=false;
        soundFileName=selectedCategory.categoryAudioFile;
        cell.tapCount++;
    }
    else
    {
        if(cell.needsToPlayCategorySound)
        {
            soundFileName = selectedCategory.categoryAudioFile;
            cell.needsToPlayCategorySound=false;
            [cell flipAnimate: nil];
        }
        else
        {
            MLCategory* selectedCategory = [self.catArr objectAtIndex:indexPath.row];
            MLMainDataProvider* provider = [[MLMainDataProvider alloc]initMainProvider];
            NSArray* catItemPairs = [provider getCategoryItemPairs];
            NSMutableArray* wordArr = [NSMutableArray array];
            
            for(int i = 0; i < catItemPairs.count; i++)
            {
                MLPair* pair = [catItemPairs objectAtIndex:i];
                MLCategory* cat = pair.first;
                if(cat.categoryId == selectedCategory.categoryId)
                {
                    MLItem* word = pair.second;
                    [wordArr addObject: word];
                }
            }
            
            int tapCount = cell.tapCount;
            int index;
            
            if(tapCount < wordArr.count)
            {
                index = tapCount;
            }
            else
            {
                int t=tapCount/wordArr.count;
                int i = (int)(tapCount - t * wordArr.count);
                index = i;
            }

            MLItem* word = [wordArr objectAtIndex:index];
            soundFileName = word.itemAudioFile;
            
            #ifdef DEBUG
            NSLog(@"playing sound for item %@ from %@", word.itemDescription, word.itemAudioFile);
            NSLog(@"word arr size : %lu get item at index %i", (unsigned long)wordArr.count,index);
            #endif

            cell.needsToPlayCategorySound = true;
            cell.tapCount++;
            
            [cell flipAnimate: [word itemImageFile]];
        }
    }
    [self.audioPlayer loadFileFromResource:soundFileName withExtension: @"mp3"];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"AppHelp"])
    {
        MLHelpViewController* vc = [segue destinationViewController];
        vc.pageId = 2;
    }
}

@end
