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
            NSString* folderPath;
            if([[files.list objectAtIndex:i]hasSuffix:@".png"])
            {
                 folderPath= [self createDirectory:@"Images"];
                if(!folderPath)
                {
                    #ifdef DEBUG
                        NSLog(@"Could not create Images folder");
                    #endif
                }
            }
            else if([[files.list objectAtIndex:i]hasSuffix:@".mp3"])
            {
                folderPath = [self createDirectory:@"Sounds"];
                if(!folderPath)
                {
                    #ifdef DEBUG
                        NSLog(@"Could not create Sounds folder");
                    #endif
                }
            }
            else if([[files.list objectAtIndex:i]hasSuffix:@".dat"])
            {
                NSString* outerPath = [self createDirectory:@"Data"];
                if(outerPath)
                {
                    folderPath=[self createDirectoryWithPath:outerPath folderName:files.fileServletPackageIdValue];
                    if(!folderPath)
                    {
                        #ifdef DEBUG
                            NSLog(@"Could not create [%@] folder",files.fileServletPackageIdValue);
                        #endif
                    }
                }
                else
                {
                    #ifdef DEBUG
                        NSLog(@"Could not create Data folder");
                    #endif
                }
            }
            else
            {
                #ifdef DEBUG
                    NSLog(@"Unknown file format.");
                #endif
            }
            if(folderPath)
            {
            //saving to created folder
            NSString* filePath= [folderPath stringByAppendingPathComponent:[files.list objectAtIndex:i]];
            if([self writeDataToDisk:data path:filePath])
            {
                #ifdef DEBUG
                    NSLog(@"Saved file to %@",filePath);
                #endif
            }
            else
            {
                #ifdef DEBUG
                    NSLog(@"Could not save %@",filePath);
                #endif
            }
            }
        }
        else
        {
            #ifdef DEBUG
                NSLog(@">>>>>>>Could not load file from %@",fileAddress);
            #endif
        }
        
    }
}
-(NSString*)createDirectory:(NSString*)folderName
{
    NSFileManager *filemgr;
    NSArray *dirPaths;
    NSString *docsDir;
    NSString *newDir;
    
    filemgr =[NSFileManager defaultManager];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    
    docsDir = [dirPaths lastObject];
    newDir = [docsDir stringByAppendingPathComponent:folderName];
    
    BOOL isDir;
    BOOL exists = [filemgr fileExistsAtPath:newDir isDirectory:&isDir];
    if(!exists)
    {
    if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES
                            attributes:nil error: NULL] == NO)
    {
        return nil;
    }
    else
    {
        return newDir;
    }
    }
    else
    {
        return newDir;
    }

}
-(NSString*)createDirectoryWithPath:(NSString*)path folderName:(NSString*)name
{
    NSFileManager *filemgr;
    NSString *docsDir;
    NSString *newDir;
    
    filemgr =[NSFileManager defaultManager];
    
    docsDir = path;
    newDir = [docsDir stringByAppendingPathComponent:name];
    
    BOOL isDir;
    BOOL exists = [filemgr fileExistsAtPath:newDir isDirectory:&isDir];
    if(!exists)
    {
        if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES
                                attributes:nil error: NULL] == NO)
        {
            return nil;
        }
        else
        {
            return newDir;
        }
    }
    else
    {
        return newDir;
    }
}
-(bool)writeDataToDisk:(NSData*)data path:(NSString*)filePath
{
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        return true;
    }
    else
    {
        return [data writeToFile:filePath atomically:YES];
    }
}
@end
