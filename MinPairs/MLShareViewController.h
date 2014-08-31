//
//  MLShareViewController.h
//  MinPairs
//
//  Created by Oleksiy Martynov on 5/12/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface MLShareViewController : UIViewController<MFMailComposeViewControllerDelegate>
@property (strong,nonatomic) NSString* socialMessage;
@property (strong,nonatomic) UIImage* socialImage;
@property BOOL isModal;
@end
