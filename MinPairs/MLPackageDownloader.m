//
//  MLPackageDownloader.m
//  MinPairsPro
//
//  Created by Oleksiy Martynov on 9/1/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLPackageDownloader.h"

@implementation MLPackageDownloader
-(MLPackageList*)getDownloadablePackages
{
    NSData* data = [NSData dataWithContentsOfURL:
                    [SERVER_ADDRESS URLByAppendingPathComponent:PACKAGELIST_SERVLET_NAME]];
    if(!data)
    {
        #ifdef DEBUG
                NSLog(@"Could not get data from server. Check internet, or try again later.");
        #endif
        return nil;
    }
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    if(!error)
    {
        NSArray* packages ;
        if([[json objectForKey:PACKAGELIST_JSON_KEY_PACKAGELIST] isKindOfClass:[NSArray class]])
        {
            packages =[json objectForKey:PACKAGELIST_JSON_KEY_PACKAGELIST];
        }
        else
        {
            packages = [NSArray arrayWithObject:[json objectForKey:PACKAGELIST_JSON_KEY_PACKAGELIST]];
        }
        NSURL* detailServletUrl=[SERVER_ADDRESS URLByAppendingPathComponent:[json objectForKey:PACKAGELIST_JSON_KEY_DETAIL_SERVLET_NAME]];
        NSString* detailServletParam = [json objectForKey:PACKAGELIST_JSON_KEY_DETAIL_SERVLET_PARAM_NAME_PACKAGE_ID];
        return [[MLPackageList alloc]initWithList:packages detailServletUrl:detailServletUrl paramName:detailServletParam];

    }
    else
    {
        #ifdef DEBUG
            NSLog(@"Error loading data.");
        #endif
        return nil;
    }
}
-(MLPackageFileList*)getFileUrlForPackage:(MLPackageList*)list packageName:(NSString*)packageId
{
    //NSLog(@"%@,%@",list,packageId);
    NSString* queryStr = [NSString stringWithFormat:@"?%@=%@",list.detailsServletpackageIdParamName,packageId];
    NSURL* fullPath = [NSURL URLWithString:[list.detailsServletUrl.absoluteString stringByAppendingString: queryStr]];
    //NSLog(@"%@",fullPath.absoluteString);
    NSData* data = [NSData dataWithContentsOfURL:fullPath];
    if(!data)
    {
        #ifdef DEBUG
            NSLog(@"Could not get data from server. Check internet, or try again later.");
        #endif
        return nil;
    }
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    if(!error)
    {
        NSArray* fileUrlList =[json objectForKey:PACKAGEDETAIL_JSON_KEY_FILELIST];
        NSURL* fileServletUrl=[SERVER_ADDRESS URLByAppendingPathComponent:[json objectForKey:PACKAGEDETAIL_JSON_KEY_FILE_SERVLET_NAME]];
        NSString* packageIdParamName = [json objectForKey:PACKAGEDETAIL_JSON_KEY_FILE_SERVLET_PARAM_NAME_PACKAGE_ID];
        NSString* fileIdParamName = [json objectForKey:PACKAGEDETAIL_JSON_KEY_FILE_SERVLET_PARAM_NAME_FILE_ID];
        NSString* retinalSuffix=[json objectForKey:PACKAGEDETAIL_JSON_KEY_FILE_SERVLET_PARAM_NAME_RETINA_SUFFIX];
        MLPackageFileList* detailServletData = [[MLPackageFileList alloc]initPackageFileList:fileUrlList packageName:packageId fileServletAddress:fileServletUrl paramNamePackageId:packageIdParamName paramNameFileId:fileIdParamName retinaSuffix:retinalSuffix];
        return detailServletData;
    }
    else
    {
        #ifdef DEBUG
            NSLog(@"Error downloading data.");
        #endif
        return nil;
    }
    
}
-(void)saveFilesToDisk:(MLPackageFileList*)files
{
    for(int i =0; i < files.list.count; i++)
    {
        
        NSString* packageIdQuery = [NSString stringWithFormat:@"%@=%@",files.fileServletPackageIdParamName,files.fileServletPackageIdValue];
        NSString* fileIdQuery=[NSString stringWithFormat:@"%@=%@",files.fileServletFileIdParamName,[files.list objectAtIndex:i] ];
        NSString* queryStr = [NSString stringWithFormat:@"?%@&%@",packageIdQuery,fileIdQuery];
        NSURL* fileAddress =[NSURL URLWithString:[files.fileServletUrl.absoluteString stringByAppendingString:queryStr]];
    
        #ifdef DEBUG
                NSLog(@"Loading file from: %@",fileAddress);
        #endif
        NSData* data = [NSData dataWithContentsOfURL:fileAddress];
        if(data)
        {
            #ifdef DEBUG
                NSLog(@"File size:%i",data.length);
            #endif
            //todo: store to disk
        }
        else
        {
            #ifdef DEBUG
                NSLog(@"Could not load file from %@",fileAddress);
            #endif
        }
    }
}
@end
