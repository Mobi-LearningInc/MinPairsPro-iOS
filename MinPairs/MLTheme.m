//
//  MLTheme.m
//  MinPairs
//
//  Created by Brandon on 2014-05-17.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLTheme.h"
#import "MLPlatform.h"

@interface MLTheme()
@property (nonatomic, assign) CGFloat btnRadius;
@property (nonatomic, strong) UIColor* navBarColour;
@property (nonatomic, strong) UIColor* btnBackground;
@property (nonatomic, weak) UIViewController* mainController;
@end

@implementation MLTheme
+(MLTheme*) sharedInstance
{
    static dispatch_once_t onceToken = 0;
    static MLTheme* instance = nil;
    
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone: nil] init];

    });
    
    return instance;
}

+(id) allocWithZone:(NSZone*)zone
{
    return [self sharedInstance];
}

-(id) copyWithZone:(NSZone*)zone
{
    return self;
}

+(void)setButtonRadius:(CGFloat)radius
{
    [[self sharedInstance] setBtnRadius: radius];
}

+(void)setButtonBackground:(UIColor*)colour
{
    [[self sharedInstance] setBtnBackground: colour];
}

+(void)setButtonBackground:(CGFloat)R withGreen:(CGFloat)G withBlue:(CGFloat)B withAlpha:(CGFloat)A
{
    [self setButtonBackground: [UIColor colorWithRed:R green:G blue:B alpha:A]];
}

+(void)setNavigationBarColour:(UIColor*)colour
{
    [[self sharedInstance] setNavBarColour: colour];
}

+(void)setNavigationBarColour:(CGFloat)R withGreen:(CGFloat)G withBlue:(CGFloat)B withAlpha:(CGFloat)A
{
    [MLTheme setNavigationBarColour: [UIColor colorWithRed:R green:G blue:B alpha:A]];
}

+(void)updateTheme
{
    [[[[[self sharedInstance] mainController] navigationController] navigationBar] setBarTintColor: [[self sharedInstance] navBarColour]];
}

+(void)setBarButtonTints:(UIViewController*) controller withColour:(UIColor*)colour
{
    NSArray* leftBarButtons = [[controller navigationItem] leftBarButtonItems];
    NSArray* rightBarButtons = [[controller navigationItem] rightBarButtonItems];
    
    for (UIBarButtonItem* item in leftBarButtons)
    {
        [item setTintColor:colour];
        
        UIView* view = [item valueForKey:@"view"]; //questionable.
        for (UIView* v in [view subviews])
        {
            [v setTintColor:colour];
        }
    }
    
    for (UIBarButtonItem* item in rightBarButtons)
    {
        [item setTintColor:colour];
        
        UIView* view = [item valueForKey:@"view"]; //questionable.
        for (UIView* v in [view subviews])
        {
            [v setTintColor:colour];
        }
    }
}

+(UIColor*)navButtonColour
{
    return [[self sharedInstance] btnBackground];
}

+(void) setTheme:(UIViewController*)controller
{
    UIView* view = [controller view];
    
    [[[controller navigationController] navigationBar] setBarTintColor: [[self sharedInstance] navBarColour]];
    
    [MLPlatform setButtonsRound: view withRadius: [[self sharedInstance] btnRadius]];
    [self setBarButtonTints:controller withColour: [self navButtonColour]];
    
    for (UIView* v in [view subviews])
    {
        if ([v isKindOfClass:[UIButton class]])
        {
            ((UIButton*)v).backgroundColor = [[self sharedInstance] btnBackground];
        }
    }
    
    if (view && ([view tag] != 1))
    {
        UIColor* colour = [UIColor colorWithRed:0xFF/0xFF green:0xFF/0xFF blue:0xFF/0xFF alpha:1.0f];
        [[[controller navigationController] navigationBar] setBarTintColor: colour];
    }
    else
    {
        [[self sharedInstance] setMainController: controller];
    }
    
    [[[controller navigationController] navigationBar] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Avenir" size:20], NSFontAttributeName, [[self sharedInstance] btnBackground], NSForegroundColorAttributeName, nil]];
}
@end
