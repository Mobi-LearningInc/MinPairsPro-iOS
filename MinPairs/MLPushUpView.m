//
//  MLSettingsView.m
//  MinPairs
//
//  Created by Brandon on 2014-04-26.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLPushUpView.h"

@implementation MLPushUpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(void) awakeFromNib
{
    [self setNotifications: false];
}

-(void) dealloc
{
    [self setNotifications: true];
}

-(void) setNotifications:(bool)remove
{
    if (remove)
    {
        [[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillShowNotification object: nil];
        [[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillHideNotification object: nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object: nil];
    }
}

-(void) keyboardWillShow:(NSNotification*)notification
{
    float kbdSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;

    CGRect rect = [self frame];
    rect.size.height -= kbdSize;
    
    UIView* view = [self getFirstResponder];
    
    if (view && !CGRectContainsPoint(rect, view.frame.origin))
    {
        [self animate: -rect.size.height + 50];
    }
}

-(void) keyboardWillHide:(NSNotification*)notification
{
    [self animate: 0.0f];
}

-(void)animate:(float)offset
{
    [UIView animateWithDuration: 0.5f animations: ^{
        CGRect rect = [self frame];
        rect.origin.y = offset;
        self.frame = rect;
    }];
}

-(id) getFirstResponder
{
    for (UIView* view in [self subviews])
    {
        if ([view isFirstResponder])
        {
            return view;
        }
    }
    return nil;
}

@end
