//
//  MLDataProviderBase.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/25/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLDataProviderEventListener.h"
#import "MLCategory.h"
#import "MLItem.h"
/**
 * A protocol all data providers must conform too
 */
@protocol MLDataProviderBase <NSObject>

/*! Loads and then reads the resource and returns array of MLCategory objects
 * \returns array of MLCategory objects
 */
-(NSArray*)getCategories;
/*! Loads and then reads the resource and returns array of MLPair objects
 * \returns array of MLPair objects
 */
-(NSArray*)getCategoryPairs;
/*! Loads and then reads the resource and returns array of MLItem objects
 * \returns array of MLItem objects
 */
-(NSArray*)getItems;
/*! Loads and then reads the resource and returns array of MLPair objects
 * \returns array of MLPair objects
 */
-(NSArray*)getCategoryItemPairs;
/*! Loads and then reads the resource and returns array of MLPair objects
 * \returns array of MLPair objects
 */
-(NSArray*)getPairs;
/*! Loads and then reads the resource and return single MLCategory object with given id, or nil if id doesnt exist
 * \param id
 * \returns instance of MLCategory
 */
-(MLCategory*)getCategoryWithId:(int)categoryId;
/*! Loads and then reads the resource and return single MLItem object with given id, or nil if id doesnt exist
 * \param id
 * \returns instance of MLItem
 */
-(MLItem*)getItemWithId:(int)itemId;



/*! Loads and then reads the resource and returns array of MLCategory objects
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns array of MLCategory objects
 */
-(NSArray*)getCategoriesCallListener:(id<MLDataProviderEventListener>)listener;
/*! Loads and then reads the resource and returns array of MLPair objects
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns array of MLPair objects
 */
-(NSArray*)getCategoryPairsCallListener:(id<MLDataProviderEventListener>)listener;
/*! Loads and then reads the resource and returns array of MLItem objects
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns array of MLItem objects
 */
-(NSArray*)getItemsCallListener:(id<MLDataProviderEventListener>)listener;
/*! Loads and then reads the resource and returns array of MLPair objects
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns array of MLPair objects
 */
-(NSArray*)getCategoryItemPairsCallListener:(id<MLDataProviderEventListener>)listener;
/*! Loads and then reads the resource and returns array of MLPair objects
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns array of MLPair objects
 */
-(NSArray*)getPairsCallListener:(id<MLDataProviderEventListener>)listener;
/*! Loads and then reads the resource and return single MLCategory object with given id, or nil if id doesnt exist
 * \param id
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns instance of MLCategory
 */
-(MLCategory*)getCategoryWithId:(int)categoryId listener:(id<MLDataProviderEventListener>)listener;
/*! Loads and then reads the resource and return single MLItem object with given id, or nil if id doesnt exist
 * \param id
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns instance of MLItem
 */
-(MLItem*)getItemWithId:(int)itemId listener:(id<MLDataProviderEventListener>)listener;
@end
