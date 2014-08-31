//
//  MLItem.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * @class MLItem
 * @discussion MLItem class stores id, word, audio file path, image file path and field seperator for individual item. 
 */
@interface MLItem : NSObject
///integer id of the item
@property int itemId;
///string used to display the word
@property (strong,nonatomic)NSString* itemDescription;
///audio file path for the item
@property (strong,nonatomic)NSString* itemAudioFile;
///image file path for the item
@property (strong,nonatomic)NSString* itemImageFile;
///deperatior string that seperated each item in the original file
@property (strong,nonatomic)NSString* itemSeparator;
/*! Constructs instance of MLItem class
 * \param itemId id of the category
 * \param description string field used to display the word
 * \param audioFile path to the audo resource
 * \param imageFile path to the image resource
 * \param deperatior string that seperated each item in the original file
 * \returns instance of MLItem
 */
-(instancetype)initItemWithId:(int)itemId description:(NSString*)description audioPath:(NSString*)audioFile imagePath:(NSString*)imageFile seperator:(NSString*)seperator;
@end
