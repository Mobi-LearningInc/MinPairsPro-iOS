//
//  MLMainDataProvider.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/25/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLDataProviderBase.h"
/**
 * MLMainDataProvider passes the requests to set provider
 */
@interface MLMainDataProvider : NSObject <MLDataProviderBase>

#define ML_PROVIDER_TYPE_FILE @"FILE"
//uncomment on of the following when using different default type of provider
//#define ML_PROVIDER_TYPE_WEB @"WEB"
//#define ML_PROVIDER_TYPE_DATABASE @"DATABASE"
/*! Constructs default instance of MLMainDataProvider class
 * \returns instance of MLMainDataProvider
 */
-(instancetype)initMainProvider;
/*! Constructs  instance of MLMainDataProvider class
 * \param custom provider to use. must conform to MLDataProviderBase protocol
 * \returns instance of MLMainDataProvider
 */
-(instancetype)initMainProviderWithProvider:(id<MLDataProviderBase>)provider;
@end
