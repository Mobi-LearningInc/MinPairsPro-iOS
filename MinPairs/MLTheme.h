//
//  MLTheme.h
//  MinPairs
//
//  Created by Brandon on 2014-05-17.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLTheme : NSObject
+(MLTheme*) sharedInstance;
+(void)setButtonRadius:(CGFloat)radius;
+(void)setButtonBackground:(UIColor*)colour;
+(void)setButtonBackground:(CGFloat)R withGreen:(CGFloat)G withBlue:(CGFloat)B withAlpha:(CGFloat)A;
+(void)setNavigationBarColour:(UIColor*)colour;
+(void)setNavigationBarColour:(CGFloat)R withGreen:(CGFloat)G withBlue:(CGFloat)B withAlpha:(CGFloat)A;
+(UIColor*)navButtonColour;
+(void)setTheme:(UIViewController*)controller;
+(void)updateTheme;
@end
