//
//  MLPackageFileDataProvider.m
//  MinPairsPro
//
//  Created by Oleksiy Martynov on 9/10/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLPackageFileDataProvider.h"
#import "MLPackageDownloader.h"

@implementation MLPackageFileDataProvider
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
-(NSString*)getImageFilePath:(NSString*)fileName
{
    NSFileManager *filemgr;
    NSArray *dirPaths;
    NSString *docsDir;
    NSString *fullPath;
    
    filemgr =[NSFileManager defaultManager];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    
    docsDir = [dirPaths lastObject];
    fullPath = [docsDir stringByAppendingPathComponent:@"Images"];
    fullPath=[fullPath stringByAppendingPathComponent:fileName];
    #ifdef DEBUG
    NSLog(@"FullPath %@",fullPath);
    #endif
    return fullPath;
    
}
-(NSString*)getFilePath:(NSString*)fileName type:(NSString*)fileType
{
    NSFileManager *filemgr;
    NSArray *dirPaths;
    NSString *docsDir;
    NSString *fullPath;
    
    filemgr =[NSFileManager defaultManager];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    
    docsDir = [dirPaths lastObject];
    
    if([fileType hasSuffix:@"dat"])
    {
        fullPath = [docsDir stringByAppendingPathComponent:@"Data"];
        NSString* packageName = [MLPackageDownloader getCurrentPackageName];
        #ifdef DEBUG
            NSLog(@"Selected package %@",packageName);
        #endif
        fullPath=[fullPath stringByAppendingPathComponent:packageName];
        fullPath=[fullPath stringByAppendingPathComponent:fileName];
        fullPath=[fullPath stringByAppendingPathExtension:fileType];
        #ifdef DEBUG
        NSLog(@"FullPath %@",fullPath);
        #endif
        return fullPath;
        
    }
    
    return [[NSBundle mainBundle]pathForResource:fileName ofType:fileType];
}
@end
