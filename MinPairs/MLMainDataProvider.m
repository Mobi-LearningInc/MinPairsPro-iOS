//
//  MLMainDataProvider.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/25/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLMainDataProvider.h"
#import "MLFileDataProvider.h"
@interface MLMainDataProvider()
@property id<MLDataProviderBase>provider;
@end
@implementation MLMainDataProvider
-(instancetype)initMainProvider
{
    self=[super init];
    if (self)
    {
        
    #ifdef ML_PROVIDER_TYPE_FILE
        self.provider=[[MLFileDataProvider alloc]init];
    #endif
    #ifdef ML_PROVIDER_TYPE_WEB
        //NOTE: set self.provider to instance of class that provides resourses from the internet, class must conform to MLDataProviderBase protocol
    #endif
    #ifdef ML_PROVIDER_TYPE_DATABASE
        //NOTE: set self.provider to instance of class that provides resourses from the database, class must conform to MLDataProviderBase protocol
    #endif
    }
    return self;
}
-(instancetype)initMainProviderWithProvider:(id<MLDataProviderBase>)provider
{
    self=[super init];
    if(self)
    {
        self.provider=provider;
    }
    return self;
}
/*! Passes the request to provider and returns array of MLCategory objects
 * \returns array of MLCategory objects
 */
-(NSArray*)getCategories
{
    return [self.provider getCategories];
}
/*! Passes the request to provider and returns array of MLPair objects
 * \returns array of MLPair objects
 */
-(NSArray*)getCategoryPairs
{
    return [self.provider getCategoryPairs];
}
/*! Passes the request to provider and returns array of MLItem objects
 * \returns array of MLItem objects
 */
-(NSArray*)getItems
{
    return [self.provider getItems];
}
/*! Passes the request to provider and returns array of MLPair objects
 * \returns array of MLPair objects
 */
-(NSArray*)getCategoryItemPairs
{
    return [self.provider getCategoryItemPairs];
}
/*! Passes the request to provider and returns array of MLPair objects
 * \returns array of MLPair objects
 */
-(NSArray*)getPairs
{
    return [self.provider getPairs];
}
/*! Passes the request to provider and return single MLCategory object with given id, or nil if id doesnt exist
 * \param id
 * \returns instance of MLCategory
 */
-(MLCategory*)getCategoryWithId:(int)categoryId
{
    return [self.provider getCategoryWithId:categoryId];
}
/*! Passes the request to provider and return single MLItem object with given id, or nil if id doesnt exist
 * \param id
 * \returns instance of MLItem
 */
-(MLItem*)getItemWithId:(int)itemId
{
    return [self.provider getItemWithId:itemId];
}



/*! Passes the request to provider and returns array of MLCategory objects
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns array of MLCategory objects
 */
-(NSArray*)getCategoriesCallListener:(id<MLDataProviderEventListener>)listener
{
    return [self.provider getCategoriesCallListener:listener];
}
/*! Passes the request to provider and returns array of MLPair objects
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns array of MLPair objects
 */
-(NSArray*)getCategoryPairsCallListener:(id<MLDataProviderEventListener>)listener
{
    return [self.provider getCategoryPairsCallListener:listener];
}
/*! Passes the request to provider and returns array of MLItem objects
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns array of MLItem objects
 */
-(NSArray*)getItemsCallListener:(id<MLDataProviderEventListener>)listener
{
    return [self.provider getItemsCallListener:listener];
}
/*! Passes the request to provider and returns array of MLPair objects
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns array of MLPair objects
 */
-(NSArray*)getCategoryItemPairsCallListener:(id<MLDataProviderEventListener>)listener
{
    return [self.provider getCategoryItemPairsCallListener:listener];
}
/*! Passes the request to provider and returns array of MLPair objects
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns array of MLPair objects
 */
-(NSArray*)getPairsCallListener:(id<MLDataProviderEventListener>)listener
{
    return [self.provider getCategoryItemPairsCallListener:listener];
}
/*! Passes the request to provider and return single MLCategory object with given id, or nil if id doesnt exist
 * \param id
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns instance of MLCategory
 */
-(MLCategory*)getCategoryWithId:(int)categoryId listener:(id<MLDataProviderEventListener>)listener
{
    return [self.provider getCategoryWithId:categoryId listener:listener];
}
/*! Passes the request to provider and return single MLItem object with given id, or nil if id doesnt exist
 * \param id
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns instance of MLItem
 */
-(MLItem*)getItemWithId:(int)itemId listener:(id<MLDataProviderEventListener>)listener
{
    return [self.provider getItemWithId:itemId listener:listener];
}
@end
