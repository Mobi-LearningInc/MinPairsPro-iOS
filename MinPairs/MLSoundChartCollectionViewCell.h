//
//  MLSoundChartCollectionViewCell.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLCategory.h"
/**
 * @class MLSoundChartCollectionViewCell
 * @discussion MLSoundChartCollectionViewCell class stores data for the cell and sets appropriate controls
 */
@interface MLSoundChartCollectionViewCell : UICollectionViewCell
#define SOUND_CHART_CELL_DEFAULT_IMAGE @"na1"
@property int tapCount;
@property BOOL needsToPlayCategorySound;
/*! This method need to be called in order for the cell to display data
 * \param MLCategory object
 * \returns void
 */
-(void)setCellCategory:(MLCategory*)category;

/**
 *  Flip animates an image. Flips from top down.
 *  @param wordFile name of the file to flip to. If the parameter is nil, 
 *         it flips back to its original image.
 */
-(void)flipAnimate:(NSString*) wordFile;
@end
