//
//  MLDataProvider.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLCategory.h"
#import "MLItem.h"
#import "MLDataProviderBase.h"
#import "MLDataProviderEventListener.h"
/**
 * @class MLFileDataProvider
 * @discussion MLFileDataProvider reads the resources and return appropriate data structures
 */
@interface MLFileDataProvider : NSObject <MLDataProviderBase>
#define MP_CATEGORIES_FILENAME @"MP_Categories"
#define MP_CATEGORIES_FILETYPE @"dat"

#define MP_CAT_PAIRS_FILENAME @"MP_CatPairs"
#define MP_CAT_PAIRS_FILETYPE @"dat"

#define MP_ITEMS_FILENAME @"MP_Items"
#define MP_ITEMS_FILETYPE @"dat"

#define MP_ITEMS_CATEGORIES_FILENAME @"MP_Items_Categories"
#define MP_ITEMS_CATEGORIES_FILETYPE @"dat"

#define MP_PAIRS_FILENAME @"MP_Pairs"
#define MP_PAIRS_FILETYPE @"dat"

#define MP_LINE_SEPERATOR @"\n"
#define MP_DATA_SEPERATOR @"|"


@end


