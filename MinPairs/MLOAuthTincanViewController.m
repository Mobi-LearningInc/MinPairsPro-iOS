//
//  MLOAuthTincanViewController.m
//  MinPairs
//
//  Created by Brandon on 2014-07-31.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLOAuthTincanViewController.h"
#import "MLOAuthWebView.h"
#import "MLXAPIOAuth.h"
#import "MLAuthWebViewController.h"

@interface MLOAuthTincanViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *lrsKey;
@property (weak, nonatomic) IBOutlet UITextField *lrsSecret;
@property (weak, nonatomic) IBOutlet UITextField *lrsURL;
@property (strong, nonatomic) MLXAPIOAuth* api;
@property (strong, nonatomic) MLOAuthWebView* webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (assign, nonatomic) bool webViewShown;
@property (strong, atomic) UIColor* btnColour;
@property (assign, nonatomic) bool cancel;
@end

@implementation MLOAuthTincanViewController

-(MLXAPIOAuth *)api
{
    if (!_api)
    {
        _api = [[MLXAPIOAuth alloc] init];
    }
    return _api;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self indicator] setHidden: true];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [[self view] endEditing:YES];
    return YES;
}

- (void)doCancel:(UIButton* )sender
{
    [[self webView] stopLoading];
    [[self indicator] stopAnimating];
    [[self indicator] setHidden: true];
    [sender setTag:0];
    [sender setTitle:@"Login" forState:UIControlStateNormal];
    [sender setBackgroundColor:_btnColour];
}

- (void)doLogin:(UIButton* )loginBtn
{
    [[self indicator] setHidesWhenStopped:true];
    [[self indicator] setHidden:false];
    [[self indicator] startAnimating];
    
    [[self api] setOnErrorCallback:^(NSError *error) {
        NSLog(@"Error %d: %@", [error code], [error localizedDescription]);
        
        _cancel = false;
        [self doCancel:loginBtn];
        
        if (self.webViewShown)
        {
            [self dismissViewControllerAnimated:true completion:^{
                self.webViewShown = false;
            }];
        }
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error: %d.", [error code]] message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [message show];
    }];
    
    [[self api] setOnLoginReadyCallback:^(MLOAuthWebView *webView) {
        [webView removeFromSuperview];
        [webView setHidden: false];
        if (self.cancel)
        {
            _cancel = false;
            self.webViewShown = false;
            [self doCancel:loginBtn];
        }
        else
        {
            self.webViewShown = true;
            [self performSegueWithIdentifier:@"AuthWeb" sender:webView];
        }
    }];
    
    [[self api] setOnFlowCompleteCallback:^(OAConsumer *consumer, OAToken *accessToken) {
        _cancel = false;
        [self doCancel:loginBtn];
        
        [self dismissViewControllerAnimated:true completion:^{
            [[self indicator] setHidden: true];
            [[self indicator] stopAnimating];
        }];
        
        [[self api] saveConsumer:consumer];
        [[self api] saveTokenToKeychain:accessToken];
    }];
    
    _webView = [[self api] startWorkflow:[[self lrsURL] text] withKey:[[self lrsKey] text] withSecret:[[self lrsSecret] text]];
    [[self webView] setHidden:true];
    [[self view] addSubview:[self webView]];
}

- (IBAction)onHomeClicked:(UIBarButtonItem *)sender
{
    [[self navigationController] popViewControllerAnimated:true];
}

- (IBAction)onLoginPressed:(UIButton *)sender
{
    if (![sender tag])
    {
        _cancel = false;
        _btnColour = [sender backgroundColor];
        [sender setTag:0xFF];
        [sender setTitle:@"Cancel" forState:UIControlStateNormal];
        [sender setBackgroundColor:[UIColor redColor]];
        [self doLogin: sender];
    }
    else
    {
        _cancel = true;
        [self doCancel:sender];
    }
}

- (IBAction)onResetPressed:(UIButton *)sender
{
    [[self api] removeTokenFromKeychain];
    if ([[[self lrsURL] text] length])
    {
        NSURL* url = [[NSURL alloc] initWithString:[[self lrsURL] text]];
        [[self api] clearDomainCookies:[url host]];
    }
    else
    {
        [[self api] clearAllCookies];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AuthWeb"])
    {
        [[segue destinationViewController] setView: sender];
    }
}

@end
