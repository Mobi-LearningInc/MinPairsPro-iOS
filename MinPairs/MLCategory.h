//
//  MLCategory.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//


#import <Foundation/Foundation.h>
/**
 * @class MLCategory
 * @discussion MLCategory class stores id, description, audio file path, image file path and field seperator for individual category.
 */
@interface MLCategory : NSObject
///integer id of the category
@property int categoryId;
///categoy description, its sound
@property (strong,nonatomic)NSString* categoryDescription;
///audio file path for the category
@property (strong,nonatomic)NSString* categoryAudioFile;
///image file path for the category
@property (strong,nonatomic)NSString* categoryImageFile;
///deperatior string that seperated each item in the original file
@property (strong,nonatomic)NSString* categorySeparator;
/*! Constructs instance of MLCategory class
 * \param catId id of the category
 * \param description description of the category, its sound 
 * \param audioFile path to the audo resource
 * \param imageFile path to the image resource
 * \param deperatior string that seperated each item in the original file
 * \returns instance of MLCategory
 */
-(instancetype)initCategoryWithId:(int)catId description:(NSString*)description audioPath:(NSString*)audioFile imagePath:(NSString*)imageFile seperator:(NSString*)seperator;
@end
