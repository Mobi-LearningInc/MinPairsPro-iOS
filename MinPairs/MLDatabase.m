//
//  MLDatabase.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/25/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLDatabase.h"
#import <sqlite3.h>
@interface MLDatabase()
@property (strong, nonatomic)NSString* databaseName;
@property (strong,nonatomic)NSString* databasePath;
@property sqlite3* sqliteDatabase;
@end
@implementation MLDatabase
-(NSString*)databaseName
{
    if (!_databaseName)
    {
        return @"AppDataBase1";
    }
    return _databaseName;
}
-(instancetype)initDatabaseWithCreateQuery:(NSString*)createQueryString
{
    self=[super init];
    if(self)
    {
        NSString* appDataDir;
        NSArray* allAppDataDirs;
        allAppDataDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        appDataDir=[allAppDataDirs lastObject];
        
        self.databasePath=[appDataDir stringByAppendingPathComponent: self.databaseName];
        
        NSString * msg;
        [self runQuery:createQueryString errorString:&msg];
        #ifdef DEBUG
        NSLog(@"%@\n", msg);
        #endif
    }
    return self;
}
-(BOOL)runQuery:(NSString*) query errorString: (NSString**)errorStr returnArray:(NSMutableArray**)array
{
    if (sqlite3_open([self.databasePath UTF8String], &_sqliteDatabase)==SQLITE_OK)
    {
        BOOL result = NO;
        sqlite3_stmt * sqlResult;
        if (sqlite3_prepare_v2(self.sqliteDatabase, [query UTF8String], -1, &sqlResult, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(sqlResult) == SQLITE_ROW)
            {
                NSMutableArray*rowDataArr=[NSMutableArray array];
                for (int i=0; i<sqlite3_column_count(sqlResult); i++)
                {
                    [rowDataArr addObject:[NSString stringWithUTF8String:(const char *)sqlite3_column_text(sqlResult, i)]];
                }
                [*array addObject:rowDataArr];
            }
            sqlite3_finalize(sqlResult);
            *errorStr=@"SQL QUERY SUCCESSFULY EXECUTED.";
            result= YES;
        }
        else
        {
            *errorStr=@"SQL QUERY FAILED.";
            result= NO;
        }
        sqlite3_close(self.sqliteDatabase);
        return result;
    }
    else
    {
        *errorStr=@"SQL FAILED TO OPEN OR CREATE DATABASE.";
        return NO;
    }
}
-(BOOL)runQuery:(NSString*) query errorString: (NSString**)errorStr //use for queries that dont return data
{
    if (sqlite3_open([self.databasePath UTF8String], &_sqliteDatabase)==SQLITE_OK)
    {
        BOOL result = NO;
        char *errorMsg ;
        if (sqlite3_exec(self.sqliteDatabase, [query UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK)
        {
            *errorStr=@"SQL QUERY SUCCESSFULY EXECUTED.";
            result= YES;
        }
        else
        {
            *errorStr=@"SQL QUERY FAILED.";
            result= NO;
        }
        sqlite3_close(self.sqliteDatabase);
        return result;
    }
    else
    {
        *errorStr=@"SQL FAILED TO OPEN OR CREATE DATABASE.";
        return NO;
    }
    
}

@end
