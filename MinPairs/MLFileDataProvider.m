//
//  MLDataProvider.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLFileDataProvider.h"
#import "MLPair.h"
@implementation MLFileDataProvider
/*! Reads the file resource and returns array of MLCategory objects
 * \returns array of MLCategory objects
 */
-(NSArray*)getCategories
{
    static NSMutableArray* resultArr;
    if (resultArr==nil)
    {
        
    
    NSString* dataStr =[[NSString alloc]initWithContentsOfFile:[self getFilePath:MP_CATEGORIES_FILENAME type: MP_CATEGORIES_FILETYPE ] encoding:NSUTF8StringEncoding error:nil];
    NSArray* dataLinesStrArr =[dataStr componentsSeparatedByString:MP_LINE_SEPERATOR];
    resultArr=[NSMutableArray array];
    for (int i=0; i<[dataLinesStrArr count]; i++)
    {
        NSArray* dataItemsStrArr = [[dataLinesStrArr objectAtIndex:i]componentsSeparatedByString:MP_DATA_SEPERATOR];
        [resultArr addObject:[[MLCategory alloc]initCategoryWithId:[[dataItemsStrArr objectAtIndex:0] intValue] description:[dataItemsStrArr objectAtIndex:1] audioPath:[dataItemsStrArr objectAtIndex:2] imagePath:[dataItemsStrArr objectAtIndex:3] seperator:MP_DATA_SEPERATOR]];
    }
    }
    return resultArr;
}
/*! Reads the file resource and returns array of MLItem objects
 * \returns array of MLItem objects
 */
-(NSArray*)getItems
{
    static NSMutableArray* resultArr;
    if (resultArr==nil)
    {

    NSString* dataStr =[[NSString alloc]initWithContentsOfFile:[self getFilePath:MP_ITEMS_FILENAME type: MP_ITEMS_FILETYPE ] encoding:NSUTF8StringEncoding error:nil];
    NSArray* dataLinesStrArr =[dataStr componentsSeparatedByString:MP_LINE_SEPERATOR];
    resultArr=[NSMutableArray array];
    for (int i=0; i<[dataLinesStrArr count]; i++)
    {
        NSArray* dataItemsStrArr = [[dataLinesStrArr objectAtIndex:i]componentsSeparatedByString:MP_DATA_SEPERATOR];
        [resultArr addObject:[[MLItem alloc]initItemWithId:[[dataItemsStrArr objectAtIndex:0]intValue] description:[dataItemsStrArr objectAtIndex:1] audioPath:[dataItemsStrArr objectAtIndex:2] imagePath:[dataItemsStrArr objectAtIndex:3]  seperator:MP_DATA_SEPERATOR]];
    }
    }
    return resultArr;
}
/*! Reads the file resource and returns array of MLPair objects
 * \returns array of MLPair objects
 */
-(NSArray*)getCategoryPairs
{
    static NSMutableArray* resultArr;
    if (resultArr==nil)
    {
        
    NSString* dataStr =[[NSString alloc]initWithContentsOfFile:[self getFilePath:MP_CAT_PAIRS_FILENAME type: MP_CAT_PAIRS_FILETYPE ] encoding:NSUTF8StringEncoding error:nil];
    NSArray* dataLinesStrArr =[dataStr componentsSeparatedByString:MP_LINE_SEPERATOR];
    resultArr=[NSMutableArray array];
    for (int i=0; i<[dataLinesStrArr count]; i++)
    {
        NSArray* dataItemsStrArr = [[dataLinesStrArr objectAtIndex:i]componentsSeparatedByString:MP_DATA_SEPERATOR];
        MLCategory* one=[self getCategoryWithId:[[dataItemsStrArr objectAtIndex:0]intValue]];
        MLCategory* two=[self getCategoryWithId:[[dataItemsStrArr objectAtIndex:1]intValue]];
        MLPair* pair =[[MLPair alloc]initPairWithFirstObject:one secondObject:two];
        [resultArr addObject:pair];
    }
    }
    return resultArr;
}
/*! Reads the file resource and returns array of MLPair objects
 * \returns array of MLPair objects
 */
-(NSArray*)getCategoryItemPairs
{
    static NSMutableArray* resultArr;
    if(resultArr==nil)
    {
    NSString* dataStr =[[NSString alloc]initWithContentsOfFile:[self getFilePath:MP_ITEMS_CATEGORIES_FILENAME type: MP_ITEMS_CATEGORIES_FILETYPE ] encoding:NSUTF8StringEncoding error:nil];
    NSArray* dataLinesStrArr =[dataStr componentsSeparatedByString:MP_LINE_SEPERATOR];
    resultArr=[NSMutableArray array];
    for (int i=0; i<[dataLinesStrArr count]; i++)
    {
        NSArray* dataItemsStrArr = [[dataLinesStrArr objectAtIndex:i]componentsSeparatedByString:MP_DATA_SEPERATOR];
        MLCategory* one=[self getCategoryWithId:[[dataItemsStrArr objectAtIndex:0]intValue]];
        MLItem* two=[self getItemWithId:[[dataItemsStrArr objectAtIndex:1]intValue]];
        MLPair* pair =[[MLPair alloc]initPairWithFirstObject:one secondObject:two];
        [resultArr addObject:pair];
    }
    }
    return resultArr;
}
/*! Reads the file resource and returns array of MLPair objects
 * \returns array of MLPair objects
 */
-(NSArray*)getPairs
{
    static NSMutableArray* resultArr;
    if(resultArr==nil)
    {
    NSString* dataStr =[[NSString alloc]initWithContentsOfFile:[self getFilePath:MP_PAIRS_FILENAME type: MP_PAIRS_FILETYPE ] encoding:NSUTF8StringEncoding error:nil];
    NSArray* dataLinesStrArr =[dataStr componentsSeparatedByString:MP_LINE_SEPERATOR];
    resultArr=[NSMutableArray array];
    
    for (int i=0; i<[dataLinesStrArr count]; i++)
    {
        NSArray* dataItemsStrArr = [[dataLinesStrArr objectAtIndex:i]componentsSeparatedByString:MP_DATA_SEPERATOR];
        if ([dataItemsStrArr count]==4)
        {
        
            MLCategory* one=[self getCategoryWithId:[[dataItemsStrArr objectAtIndex:1]intValue]];
            MLItem* two=[self getItemWithId:[[dataItemsStrArr objectAtIndex:0]intValue]];
            MLCategory* three=[self getCategoryWithId:[[dataItemsStrArr objectAtIndex:3]intValue]];
            MLItem* four=[self getItemWithId:[[dataItemsStrArr objectAtIndex:2]intValue]];
            MLPair* pairL =[[MLPair alloc]initPairWithFirstObject:one secondObject:two];
            MLPair* pairR =[[MLPair alloc]initPairWithFirstObject:three secondObject:four];
            MLPair* pair =[[MLPair alloc]initPairWithFirstObject:pairL secondObject:pairR];
            [resultArr addObject:pair];
        }
    }
    }
    return resultArr;
}
/*! Reads the file resource and return single MLCategory object with given id, or nil if id doesnt exist
 * \param id
 * \returns instance of MLCategory
 */
-(MLCategory*)getCategoryWithId:(int)categoryId //performance?
{
    NSArray* arrCat=[self getCategories];
    for (int i=0; i<[arrCat count]; i++)
    {
        MLCategory* cat = [arrCat objectAtIndex:i];
        if(cat.categoryId==categoryId)
        {
            return cat;
        }
    }
    return nil;
}
/*! Reads the file resource and return single MLItem object with given id, or nil if id doesnt exist
 * \param id
 * \returns instance of MLItem
 */
-(MLItem*)getItemWithId:(int)itemId //performance?
{
    NSArray* arrItem=[self getItems];
    for (int i=0; i<[arrItem count]; i++)
    {
        MLItem* item = [arrItem objectAtIndex:i];
        if(item.itemId==itemId)
        {
            return item;
        }
    }
    return nil;
}
/*! Loads and then reads the resource and returns array of MLCategory objects
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns array of MLCategory objects
 */
-(NSArray*)getCategoriesCallListener:(id<MLDataProviderEventListener>)listener
{
    [listener onLoadStart];
    NSArray* arr=[self getCategories];
    [listener onLoadFinish];
    return arr;
}
/*! Loads and then reads the resource and returns array of MLPair objects
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns array of MLPair objects
 */
-(NSArray*)getCategoryPairsCallListener:(id<MLDataProviderEventListener>)listener
{
    [listener onLoadStart];
    NSArray* arr=[self getCategoryPairs];
    [listener onLoadFinish];
    return arr;
}
/*! Loads and then reads the resource and returns array of MLItem objects
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns array of MLItem objects
 */
-(NSArray*)getItemsCallListener:(id<MLDataProviderEventListener>)listener
{
    [listener onLoadStart];
    NSArray* arr=[self getItems];
    [listener onLoadFinish];
    return arr;
}
/*! Loads and then reads the resource and returns array of MLPair objects
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns array of MLPair objects
 */
-(NSArray*)getCategoryItemPairsCallListener:(id<MLDataProviderEventListener>)listener
{
    [listener onLoadStart];
    NSArray* arr=[self getCategoryItemPairs];
    [listener onLoadFinish];
    return arr;
}
/*! Loads and then reads the resource and returns array of MLPair objects
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns array of MLPair objects
 */
-(NSArray*)getPairsCallListener:(id<MLDataProviderEventListener>)listener
{
    [listener onLoadStart];
    NSArray* arr=[self getPairs];
    [listener onLoadFinish];
    return arr;
}
/*! Loads and then reads the resource and return single MLCategory object with given id, or nil if id doesnt exist
 * \param id
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns instance of MLCategory
 */
-(MLCategory*)getCategoryWithId:(int)categoryId listener:(id<MLDataProviderEventListener>)listener
{
    [listener onLoadStart];
    MLCategory* category=[self getCategoryWithId:categoryId];
    [listener onLoadFinish];
    return category;
}
/*! Loads and then reads the resource and return single MLItem object with given id, or nil if id doesnt exist
 * \param id
 * \param listener that conforms to MLDataProviderEventListener protocol
 * \returns instance of MLItem
 */
-(MLItem*)getItemWithId:(int)itemId listener:(id<MLDataProviderEventListener>)listener
{
    [listener onLoadStart];
    MLItem* item=[self getItemWithId:itemId];
    [listener onLoadFinish];
    return item;
}
-(NSString*)getFilePath:(NSString*)fileName type:(NSString*)fileType
{
    return [[NSBundle mainBundle]pathForResource:fileName ofType:fileType];
}
@end
