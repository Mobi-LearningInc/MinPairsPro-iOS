//
//  MLLrsCredentialsDatabase.h
//  MinPairs
//
//  Created by MLinc on 2014-05-08.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLDatabase.h"
#import "MLLsrCredentials.h"

@interface MLLrsCredentialsDatabase : MLDatabase
#define ML_DB_CREDENTIALS_TABLE_NAME @"lrs_credentials_table"
#define ML_DB_CREDENTIALS_TABLE_COL_CREDENTIAL_ID @"lrs_credential_id"
#define ML_DB_CREDENTIALS_TABLE_COL_APP_NAME @"lrs_app_name"
#define ML_DB_CREDENTIALS_TABLE_COL_KEY @"lrs_key"
#define ML_DB_CREDENTIALS_TABLE_COL_SECRET @"lrs_secret"
#define ML_DB_CREDENTIALS_TABLE_COL_ADDRESS @"lrs_address"
#define ML_DB_CREDENTIALS_TABLE_COL_USERNAME @"lrs_username"
#define ML_DB_CREDENTIALS_TABLE_COL_PASSWD @"lrs_passwd"
#define ML_DB_CREDENTIALS_TABLE_COL_APP_USER_NAME @"lrs_name"
#define ML_DB_CREDENTIALS_TABLE_COL_EMAIL @"lrs_email"

#define ML_DB_CREDENTIALS_DEFAULT_KEY @"A45CA246836B6A4C641210B11F866996"
#define ML_DB_CREDENTIALS_DEFAULT_SECRET @"aSAydtJ2cW9WdU8TjzFLeG6PL8KCzbWjQ8Q1VoXG"
#define ML_DB_CREDENTIALS_DEFAULT_APPNAME @"MinPairs"
#define ML_DB_CREDENTIALS_DEFAULT_ADDRESS @"https://cloud.scorm.com/tc/I40JG12M9U/"
//@"https://cloud.scorm.com/tc/3454GI76E3/"
//@"https://cloud.scorm.com/ScormEngineInterface/TCAPI/public/"
//@"https://cloud.scorm.com/tc/I40JG12M9U"
#define ML_DB_CREDENTIALS_DEFAULT_USERNAME @"pawluk@gmail.com"
#define ML_DB_CREDENTIALS_DEFAULT_EMAIL @"agaizabella@gmail.com"
#define ML_DB_CREDENTIALS_DEFAULT_APP_USERNAME @"Agnieszka"
//@"agaizabella@rogers.com"
//@"pawluk@gmail.com"
#define ML_DB_CREDENTIALS_DEFAULT_PASSWORD @"mojemyszki"

/** Creates and istance of the SettingDatabase class
 * \return instancetype of MLLrsCredentials
 */
-(instancetype)initLmsCredentialsDatabase;
/**saves credentials to database
 *\return status
 */
-(BOOL)saveLmsCredentials:(MLLsrCredentials*)data;
/**gets the only credentials in the database
 *\return MLSettingsData object
 */
-(MLLsrCredentials*)getLmsCredentials;
/**saves default credentials data to database (for testing only)
 *\return status
 */
-(BOOL)saveDefaultCredentials;
@end
