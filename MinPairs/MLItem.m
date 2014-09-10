//
//  MLItem.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLItem.h"

@implementation MLItem
-(instancetype)initItemWithId:(int)itemId description:(NSString*)description audioPath:(NSString*)audioFile imagePath:(NSString*)imageFile seperator:(NSString*)seperator
{
    self=[super init];
    if(self)
    {
        self.itemId=itemId;
        self.itemDescription=description;
        self.itemAudioFile=audioFile;
        NSLog(@"audio filename %@",audioFile);
        self.itemImageFile=[imageFile stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.itemSeparator=seperator;
    }
    return self;
}
-(UIImage*)getItemImage
{
    NSFileManager *filemgr;
    NSArray *dirPaths;
    NSString *docsDir;
    NSString *fullImagePath;
    
    filemgr =[NSFileManager defaultManager];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    
    docsDir = [dirPaths lastObject];
    fullImagePath = [docsDir stringByAppendingPathComponent:@"Images"];
    
    fullImagePath =[fullImagePath stringByAppendingPathComponent:self.itemImageFile];
    
    UIImage* image =[UIImage imageWithContentsOfFile:fullImagePath];
    return image?image:[UIImage imageNamed:@"na1"];
  

}
-(NSString*)getAudioFilePath
{
    NSFileManager *filemgr;
    NSArray *dirPaths;
    NSString *docsDir;
    NSString *fullAudioPath;
    
    filemgr =[NSFileManager defaultManager];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                   NSUserDomainMask, YES);
    
    docsDir = [dirPaths lastObject];
    fullAudioPath = [docsDir stringByAppendingPathComponent:@"Sounds"];
    
    fullAudioPath =[fullAudioPath stringByAppendingPathComponent:self.itemAudioFile];
    return fullAudioPath;
}
@end
