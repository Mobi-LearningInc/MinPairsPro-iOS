//
//  MLPlatform.m
//  MinPairs
//
//  Created by Brandon on 2014-04-30.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLPlatform.h"

@implementation MLPlatform

+(bool) isIPad
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+(bool) isIPhone
{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
}

+(float) getMajorSystemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+(float) getMinorSystemVersion
{
    NSArray* res = [[[UIDevice currentDevice] systemVersion] componentsSeparatedByString: @"."];
    return [res count] > 1 ? [[res objectAtIndex: 1] floatValue] : 0.0f;
}

+(NSString*) getSystemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+(void) setButtonRound:(UIButton*)button withRadius:(float)radius
{
    button.layer.cornerRadius = radius;
}

+(void) setButtonsRound:(UIView*)view withRadius:(float)radius
{
    for (UIView* v in [view subviews])
    {
        if ([v isKindOfClass:[UIButton class]])
        {
            ((UIButton*)v).layer.cornerRadius = radius;
        }
    }
}

+(void) setButtonBorder:(UIButton*)button withBorderWidth:(float)borderWidth withColour:(UIColor*)colour withMask:(bool)mask
{
    button.layer.borderWidth = borderWidth;
    button.layer.borderColor = [colour CGColor];
    button.layer.masksToBounds = mask;
}

+(void) setButtonsBorder:(UIView*)view withBorderWidth:(float)borderWidth withColour:(UIColor*)colour withMask:(bool)mask
{
    for (UIView* v in [view subviews])
    {
        if ([v isKindOfClass:[UIButton class]])
        {
            ((UIButton*)v).layer.borderWidth = borderWidth;
            ((UIButton*)v).layer.borderColor = [colour CGColor];
            ((UIButton*)v).layer.masksToBounds = mask;
        }
    }
}

+(UIImage*)imageWithColor:(UIImage*)img withColour:(UIColor*)colour
{
    UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextClipToMask(context, rect, img.CGImage);
    [colour setFill];
    CGContextFillRect(context, rect);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage*)imageWithInversion:(UIImage*)img
{
    CIFilter* filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setDefaults];
    [filter setValue:img.CIImage forKey:@"inputImage"];
    return [[UIImage alloc] initWithCIImage:filter.outputImage];
}

+(NSMutableAttributedString*)parseBBCodes:(NSMutableAttributedString*)text withFontSize:(CGFloat)fontSize
{
    [MLPlatform parseColourBBCodes:text];
    [MLPlatform parseUnderlineBBCodes:text];
    [MLPlatform parseBoldBBCodes:text withFontSize:fontSize];
    return text;
}

+(NSMutableAttributedString*)parseColourBBCodes:(NSMutableAttributedString*)text
{
    int pos, len, subpos, sublen, colourpos, colourlen;
    
    bool res = [MLPlatform indexColourBBCode:text.string withPos:&pos withLen:&len withSubPos:&subpos withSubLen:&sublen withColourPos:&colourpos withColourLen:&colourlen];
    
    while (res)
    {
        unsigned int hexcolour = 0;
        NSRange group0 = NSMakeRange(pos, len);
        NSRange group1 = NSMakeRange(subpos, sublen);
        NSRange group2 = NSMakeRange(colourpos, colourlen);
        [[NSScanner scannerWithString:[text.string substringWithRange:group2]] scanHexInt:&hexcolour];
        UIColor* colour = [UIColor colorWithRed:((hexcolour & 0xFF0000) >> 16)/255.0 green:((hexcolour & 0xFF00) >> 8)/255.0 blue:(hexcolour & 0xFF)/255.0 alpha:1.0];
        
        [text replaceCharactersInRange:group0 withString: [text.string substringWithRange:group1]];
        
        group0.length -= 0x19;
        [text addAttribute:NSForegroundColorAttributeName value:colour range:group0];
        res = [MLPlatform indexColourBBCode:text.string withPos:&pos withLen:&len withSubPos:&subpos withSubLen:&sublen withColourPos:&colourpos withColourLen:&colourlen];
    }
    return text;
}

+(NSMutableAttributedString*)parseUnderlineBBCodes:(NSMutableAttributedString*)text
{
    int pos, len, subpos, sublen;
    
    bool res = [MLPlatform indexSimpleBBCode:text.string withBegin:@"[u]" withEnd:@"[/u]" withPos:&pos withLen:&len withSubPos:&subpos withSubLen:&sublen];
    
    while (res)
    {
        NSRange group0 = NSMakeRange(pos, len);
        NSRange group1 = NSMakeRange(subpos, sublen);
        
        [text replaceCharactersInRange:group0 withString: [text.string substringWithRange:group1]];
        group0.length -= 0x07;
        
        [text addAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:group0];
        res = [MLPlatform indexSimpleBBCode:text.string withBegin:@"[u]" withEnd:@"[/u]" withPos:&pos withLen:&len withSubPos:&subpos withSubLen:&sublen];
    }
    return text;
}

+(NSMutableAttributedString*)parseBoldBBCodes:(NSMutableAttributedString*)text withFontSize:(CGFloat)fontSize
{
    int pos, len, subpos, sublen;
    
    bool res = [MLPlatform indexSimpleBBCode:text.string withBegin:@"[b]" withEnd:@"[/b]" withPos:&pos withLen:&len withSubPos:&subpos withSubLen:&sublen];
    
    while (res)
    {
        NSRange group0 = NSMakeRange(pos, len);
        NSRange group1 = NSMakeRange(subpos, sublen);
        
        [text replaceCharactersInRange:group0 withString: [text.string substringWithRange:group1]];
        group0.length -= 0x07;
        
        [text setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize: fontSize]} range:group0];
        res = [MLPlatform indexSimpleBBCode:text.string withBegin:@"[b]" withEnd:@"[/b]" withPos:&pos withLen:&len withSubPos:&subpos withSubLen:&sublen];
    }
    
    return text;
}

+(bool) indexSimpleBBCode:(NSString*)str withBegin:(NSString*)bb_first withEnd:(NSString*)bb_last withPos:(int*)pos withLen:(int*)len withSubPos:(int*)subpos withSubLen:(int*)sublen
{
    NSRange first = [str rangeOfString:bb_first options:NSCaseInsensitiveSearch];
    if (first.location != NSNotFound)
    {
        NSRange offset = NSMakeRange(first.location + [bb_first length], [str length] - (first.location + [bb_first length]));
        NSRange last = [str rangeOfString:bb_last options:NSCaseInsensitiveSearch range: offset];
        
        if (last.location != NSNotFound)
        {
            *sublen = (int)last.location - (int)offset.location;
            *subpos = (int)offset.location;
            
            *len = (int)(last.location - first.location) + (int)[bb_last length];
            *pos = (int)first.location;
            return true;
        }
    }
    
    *subpos = *pos = -1;
    *sublen = *len = 0;
    return false;
}

+(bool) indexColourBBCode:(NSString*)str withPos:(int*)pos withLen:(int*)len withSubPos:(int*)subpos withSubLen:(int*)sublen withColourPos:(int*)colourpos withColourLen:(int*)colourlen
{
    NSString* bb_first = @"[colour=#";
    NSString* bb_colour = @"]";
    NSString* bb_last = @"[/colour]";
    
    
    NSRange first = [str rangeOfString:bb_first options:NSCaseInsensitiveSearch];
    if (first.location != NSNotFound)
    {
        NSRange offset = NSMakeRange(first.location + [bb_first length], [str length] - (first.location + [bb_first length]));
        NSRange second = [str rangeOfString:bb_colour options:NSCaseInsensitiveSearch range:offset];
        
        if (second.location != NSNotFound)
        {
            NSRange last = [str rangeOfString:bb_last options:NSCaseInsensitiveSearch range:offset];
            if (last.location != NSNotFound)
            {
                *colourlen = (int)last.location - (int)offset.location;
                *colourpos = (int)offset.location;
                
                *sublen = (int)(last.location - (second.location + [bb_colour length]));
                *subpos = (int)second.location + (int)[bb_colour length];
                
                *len = (int)(last.location - first.location) + (int)[bb_last length];
                *pos = (int)first.location;
                return true;
            }
        }
    }
    
    *subpos = *pos = *colourpos = -1;
    *sublen = *len = *colourlen = 0;
    return false;
}
@end
