//
//  MLPackageDownloadViewController.m
//  MinPairsPro
//
//  Created by Oleksiy Martynov on 9/8/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLPackageDownloadViewController.h"
#import "MLPackageDownloader.h"
#import "MLPackageFileList.h"
@interface MLPackageDownloadViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleString;
@property (weak, nonatomic) IBOutlet UILabel *subTitleString;
@property (weak, nonatomic) IBOutlet UILabel *percentString;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UIButton *buttonDone;

@end

@implementation MLPackageDownloadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.progressBar setProgress:0.0f animated:NO];
    [self startDownload];
    self.buttonDone.hidden=true;
    
}
- (IBAction)onDoneButton:(id)sender {
    //todo:if canceled download then show popup and delete package folder
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)startDownload
{
    if(self.packageToDownload)
    {
#ifdef DEBUG
    NSLog(@"Downloading data...");
#endif
        [MLPackageDownloader getDownloadablePackagesWithCompletion:^(BOOL success, MLPackageList *packageList) {
            #ifdef DEBUG
            NSLog(@"Downloadable packages:%@ \n DetailServlet:%@ \n DetailServletParam:%@", packageList.packageList,[packageList.detailsServletUrl absoluteString],packageList.detailsServletpackageIdParamName);
            #endif
            [MLPackageDownloader getFileUrlForPackage:packageList packageName:self.packageToDownload withCompletion:^(BOOL success, MLPackageFileList *fileList) {
                #ifdef DEBUG
                NSLog(@"Files for %@ package :\n %@ \n file servlet name:%@ \n file servlet param names : %@,%@",self.packageToDownload,fileList.list,fileList.fileServletUrl.absoluteString,fileList.fileServletPackageIdParamName,fileList.fileServletFileIdParamName);
                #endif
                if(fileList)
                {
                    [MLPackageDownloader saveFilesToDisk:fileList withCompletion:^(BOOL success) {
                        [self performSelectorOnMainThread:@selector(setTitle:) withObject:@"Finished." waitUntilDone:NO];
                        [self performSelectorOnMainThread:@selector(setSubTitle:) withObject:@"Done." waitUntilDone:NO];
                        [self performSelectorOnMainThread:@selector(setPercent:) withObject:[NSNumber numberWithFloat:1.0f] waitUntilDone:NO];
                        NSLog(@"Finished download. Status:%hhd",success);
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                    } withUpdate:^(float percent, NSString *fileName, BOOL status) {
                        [self performSelectorOnMainThread:@selector(setSubTitle:) withObject:[NSString stringWithFormat:@"Download:%@ Status:%@",fileName,status?@"OK":@"FAILED"] waitUntilDone:NO];
                        [self performSelectorOnMainThread:@selector(setPercent:) withObject:[NSNumber numberWithFloat:percent] waitUntilDone:NO];
                        
                    }];
                    #ifdef DEBUG
                    NSLog(@"Finished downloading data...");
                    #endif
                }
                else
                {
                    #ifdef DEBUG
                    NSLog(@"Nil FileList object.");
                    #endif
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network problem!"
                                                                    message:@"Could not download package. Check internet connection or try again later."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }];
    }
}
-(void)setTitle:(NSString*)str
{
    self.titleString.text=str;
}
-(void)setSubTitle:(NSString*)str
{
    self.subTitleString.text = str;
}
-(void)setPercent:(NSNumber*) number
{
    [self.progressBar setProgress:[number floatValue]  animated:YES];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    self.percentString.text=[NSString stringWithFormat:@"%@%%",[formatter stringFromNumber:[NSNumber numberWithFloat:[number floatValue]*100.0f]]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
