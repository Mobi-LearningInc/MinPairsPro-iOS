//
//  MLPackageTableViewController.m
//  MinPairsPro
//
//  Created by Oleksiy Martynov on 9/4/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLPackageTableViewController.h"
#import "MLPackageDownloader.h"
@interface MLPackageTableViewController ()
@property(strong, nonatomic) NSArray* availableArr;
@property(strong,nonatomic)NSArray* downloadedArr;
@end

@implementation MLPackageTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    MLPackageDownloader* downLoader=[[MLPackageDownloader alloc]init];
    self.availableArr=[downLoader getDownloadablePackages].packageList;
    self.downloadedArr=[downLoader getInstalledPackages];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIView*)createSectionHeader:(NSString*)titleStr table:(UITableView *)tableView
{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    
    [label setText:titleStr];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    return view;
}

#pragma mark - Table view data source
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *identifier = @"defaultHeader";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    }
    if(section == 0) {
        headerView.textLabel.text = @"Available packages:" ;
    } else {
        headerView.textLabel.text =  @"Downloaded packages:" ;
    }
    
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((section == 0) ? self.availableArr.count : self.downloadedArr.count);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"PackageNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
    }
    NSString* titleStr;
    if(indexPath.section == 0)
    {
        titleStr=  [self.availableArr objectAtIndex:indexPath.row];
        cell.textLabel.text =titleStr;
    }
    else if(indexPath.section == 1)
    {
        titleStr=  [self.downloadedArr objectAtIndex:indexPath.row];
        cell.textLabel.text =titleStr;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *packageName;
    if(indexPath.section == 0)
    {
        packageName=  [self.availableArr objectAtIndex:indexPath.row];
#ifdef DEBUG
        NSLog(@"Downloading data...");
#endif
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        MLPackageDownloader* packDown = [[MLPackageDownloader alloc]init];
        MLPackageList* packages=[packDown getDownloadablePackages];
        if(packages)
        {
#ifdef DEBUG
            NSLog(@"Downloadable packages:%@ \n DetailServlet:%@ \n DetailServletParam:%@", packages.packageList,[packages.detailsServletUrl absoluteString],packages.detailsServletpackageIdParamName);
#endif
            MLPackageFileList* fileServletData=[packDown getFileUrlForPackage:packages packageName:packageName];
            if(fileServletData)
            {
#ifdef DEBUG
                NSLog(@"Files for %@ package :\n %@ \n file servlet name:%@ \n file servlet param names : %@,%@",packageName,fileServletData.list,fileServletData.fileServletUrl.absoluteString,fileServletData.fileServletPackageIdParamName,fileServletData.fileServletFileIdParamName);
#endif
                [packDown saveFilesToDisk:fileServletData];
            }
#ifdef DEBUG
            NSLog(@"Downloads finished...");
#endif
        }
        });
        
    }
    else if(indexPath.section == 1)
    {
        packageName=  [self.downloadedArr objectAtIndex:indexPath.row];
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
