//
//  MLLrsCredentialsDatabase.m
//  MinPairs
//
//  Created by MLinc on 2014-05-08.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLLrsCredentialsDatabase.h"

@implementation MLLrsCredentialsDatabase






/** Creates and istance of the SettingDatabase class
 * \return instancetype of MLLrsCredentials
 */
-(instancetype)initLmsCredentialsDatabase
{
    NSString* query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT, %@ TEXT);",
                       ML_DB_CREDENTIALS_TABLE_NAME,
                       ML_DB_CREDENTIALS_TABLE_COL_CREDENTIAL_ID,
                       ML_DB_CREDENTIALS_TABLE_COL_APP_NAME,
                       ML_DB_CREDENTIALS_TABLE_COL_KEY,
                       ML_DB_CREDENTIALS_TABLE_COL_SECRET,
                       ML_DB_CREDENTIALS_TABLE_COL_ADDRESS,
                       ML_DB_CREDENTIALS_TABLE_COL_USERNAME,
                       ML_DB_CREDENTIALS_TABLE_COL_PASSWD,
                       ML_DB_CREDENTIALS_TABLE_COL_APP_USER_NAME,
                       ML_DB_CREDENTIALS_TABLE_COL_EMAIL];
    self=[super initDatabaseWithCreateQuery:query];
    return self;
}

/**saves credentials to database
 *\return status
 */
-(BOOL)saveLmsCredentials:(MLLsrCredentials*)data
{
    NSString* query;
    if ([self countSettings]==0)
    {
        query = [NSString stringWithFormat:@"INSERT INTO %@ (%@,%@,%@, %@,%@, %@,%@, %@) VALUES('%@','%@','%@', '%@', '%@', '%@', '%@', '%@');",
                 ML_DB_CREDENTIALS_TABLE_NAME,
                 ML_DB_CREDENTIALS_TABLE_COL_APP_NAME,
                 ML_DB_CREDENTIALS_TABLE_COL_KEY,
                 ML_DB_CREDENTIALS_TABLE_COL_SECRET,
                 ML_DB_CREDENTIALS_TABLE_COL_ADDRESS,
                 ML_DB_CREDENTIALS_TABLE_COL_USERNAME,
                 ML_DB_CREDENTIALS_TABLE_COL_PASSWD,
                 ML_DB_CREDENTIALS_TABLE_COL_APP_USER_NAME,
                 ML_DB_CREDENTIALS_TABLE_COL_EMAIL,
                 data.appName,data.key,data.secret,data.address, data.userName, data.password,data.name, data.email];
    }
    else
    {
        query = [NSString stringWithFormat:@"UPDATE %@ SET %@='%@',%@='%@',%@='%@', %@='%@', %@='%@', %@='%@', %@='%@', %@='%@' WHERE %@=%i;" ,
                 ML_DB_CREDENTIALS_TABLE_NAME,
                 ML_DB_CREDENTIALS_TABLE_COL_APP_NAME,
                 data.appName,
                 ML_DB_CREDENTIALS_TABLE_COL_KEY,
                 data.key,
                 ML_DB_CREDENTIALS_TABLE_COL_SECRET,
                 data.secret,
                 ML_DB_CREDENTIALS_TABLE_COL_ADDRESS,
                 data.address,
                 ML_DB_CREDENTIALS_TABLE_COL_USERNAME,
                 data.userName,
                 ML_DB_CREDENTIALS_TABLE_COL_PASSWD,
                 data.password,
                 ML_DB_CREDENTIALS_TABLE_COL_APP_USER_NAME,
                 data.name,
                 ML_DB_CREDENTIALS_TABLE_COL_EMAIL,
                 data.email,
                 ML_DB_CREDENTIALS_TABLE_COL_CREDENTIAL_ID,
                 1];
    }
    NSString* errorStr;
    if(![self runQuery:query errorString:&errorStr])
    {
        #ifdef DEBUG
        NSLog(@"%@",errorStr);
        #endif
        return NO;
    }
    return YES;
}

/**gets the only credentials in the database
 *\return MLSettingsData object
 */
-(MLLsrCredentials*)getLmsCredentials
{
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = 1 ;",
                       ML_DB_CREDENTIALS_TABLE_NAME,
                       ML_DB_CREDENTIALS_TABLE_COL_CREDENTIAL_ID];
    NSString* errorStr =@"";
    NSMutableArray* dataArr = [NSMutableArray array];
    
    if ([self runQuery:query errorString:&errorStr returnArray:&dataArr])
    {
        MLLsrCredentials* dataItem;
        if ([dataArr count]!=0)
        {
            
            for(int i =0; i<[dataArr count];i++)
            {
                NSMutableArray* rowDataArr = [dataArr objectAtIndex:i];
                dataItem=[
                          [MLLsrCredentials alloc]initCredentialsWithId:
                          [[rowDataArr objectAtIndex:0]intValue]
                          appName:[rowDataArr objectAtIndex:1]
                          key:[rowDataArr objectAtIndex:2]
                          secret:[rowDataArr objectAtIndex:3]
                          address:[rowDataArr objectAtIndex:4]
                          appUserName:[rowDataArr objectAtIndex:7]
                          email:[rowDataArr objectAtIndex:8]
                         ];
                dataItem.userName = [rowDataArr objectAtIndex:5];
                dataItem.password = [rowDataArr objectAtIndex:6];
            }
        }
        else
        {
            [self saveDefaultCredentials];
            return [self getLmsCredentials];
        }
        return dataItem;
    }
    
    return nil;
}

/**saves default credentials data to database (for testing only)
 *\return status
 */
-(BOOL)saveDefaultCredentials
{
   /* MLLsrCredentials* deffaultSetting =[[MLLsrCredentials alloc] initCredentialsWithId:1
                                    appName:ML_DB_CREDENTIALS_DEFAULT_APPNAME
                                    key:ML_DB_CREDENTIALS_DEFAULT_KEY
                                    secret:ML_DB_CREDENTIALS_DEFAULT_SECRET
                                    address:ML_DB_CREDENTIALS_DEFAULT_ADDRESS];
    */
    MLLsrCredentials* deffaultSetting =[[MLLsrCredentials alloc] initCredentialsWithId:1
        appName:ML_DB_CREDENTIALS_DEFAULT_APPNAME
        userName:ML_DB_CREDENTIALS_DEFAULT_USERNAME
        password:ML_DB_CREDENTIALS_DEFAULT_PASSWORD
        address:ML_DB_CREDENTIALS_DEFAULT_ADDRESS
        appUserName:ML_DB_CREDENTIALS_DEFAULT_APP_USERNAME email:ML_DB_CREDENTIALS_DEFAULT_EMAIL];
                                        
    return [self saveLmsCredentials:deffaultSetting ];
}

-(int)countSettings
{
    NSString* query = [NSString stringWithFormat:@"SELECT COUNT(%@) FROM %@ ;",
                       ML_DB_CREDENTIALS_TABLE_COL_CREDENTIAL_ID,
                       ML_DB_CREDENTIALS_TABLE_NAME];
    
    NSString* errorStr =@"";
    NSMutableArray* dataArr = [NSMutableArray array];
    
    if ([self runQuery:query errorString:&errorStr returnArray:&dataArr])
    {
        for(int i =0; i<[dataArr count];i++)
        {
            NSMutableArray* rowDataArr = [dataArr objectAtIndex:i];
            return [[rowDataArr objectAtIndex:0]intValue];
        }
    }
    
    
    return 0;
}


@end
