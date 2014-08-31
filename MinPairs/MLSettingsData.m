//
//  MLSettingsData.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 4/26/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLSettingsData.h"

@implementation MLSettingsData
-(instancetype)initSettingWithId:(int)settingId timeSelect:(int)settingTimeSelect timeRead:(int)settingTimeRead timeType:(int)settingTimeType filterSelection:(MLPair*)categoryPair;
{
    self=[super init];
    if(self)
    {
        self.settingId=settingId;
        self.settingTimeSelect=settingTimeSelect;
        self.settingTimeRead=settingTimeRead;
        self.settingTimeType=settingTimeType;
        self.settingFilterCatPair=categoryPair;
    }
    return self;
}
-(instancetype)initSettingWithTimeSelect:(int)settingTimeSelect timeRead:(int)settingTimeRead timeType:(int)settingTimeType filterSelection:(MLPair*)categoryPair;
{
    self=[super init];
    if(self)
    {
        self.settingId=-1;
        self.settingTimeSelect=settingTimeSelect;
        self.settingTimeRead=settingTimeRead;
        self.settingTimeType=settingTimeType;
        self.settingFilterCatPair=categoryPair;
    }
    return self;
}
@end
