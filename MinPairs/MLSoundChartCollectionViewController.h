//
//  MLSoundChartCollectionViewController.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLDataProviderEventListener.h"
/**
 * @class MLSoundChartCollectionViewController
 * @discussion MLSoundChartCollectionViewController class provides data for each cell and listens to taps (selections)
 */
@interface MLSoundChartCollectionViewController : UICollectionViewController <UICollectionViewDataSource,UICollectionViewDelegate,MLDataProviderEventListener>

@end
