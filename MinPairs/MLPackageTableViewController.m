//
//  MLPackageTableViewController.m
//  MinPairsPro
//
//  Created by Oleksiy Martynov on 9/4/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLPackageTableViewController.h"
#import "MLPackageDownloader.h"
#import "MLPackageDownloadViewController.h"
#import "MLMainDataProvider.h"
#import "MLSettingDatabase.h"
@interface MLPackageTableViewController ()
@property(strong, nonatomic) NSArray* availableArr;
@property(strong,nonatomic)NSArray* downloadedArr;
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation MLPackageTableViewController
static bool firstOpened=true;
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
    //self.availableArr=[MLPackageDownloader getDownloadablePackages].packageList;
    [MLPackageDownloader getDownloadablePackagesWithCompletion:^(BOOL success, MLPackageList* packageList){
        self.availableArr=packageList.packageList;
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
    self.downloadedArr=[MLPackageDownloader getInstalledPackages];
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
    if(section==0)
    {
        if(self.availableArr)
        {
            return self.availableArr.count;
        }
        else
        {
            return 1;
        }
    }
    else
    {
        return self.downloadedArr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.section == 0)
    {
        UITableViewCell *cell ;
        if(self.availableArr)
        {
           cell = [tableView dequeueReusableCellWithIdentifier:@"PackageNameCell" forIndexPath:indexPath];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PackageNameCell"] ;
            }
        cell.textLabel.text=  [self.availableArr objectAtIndex:indexPath.row];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell" forIndexPath:indexPath];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoadingCell"] ;
            }
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    else if(indexPath.section == 1)
    {
        NSString* titleStr;
        NSString* cellIdentifier = @"PackageNameCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
        }
        titleStr=  [self.downloadedArr objectAtIndex:indexPath.row];
        cell.textLabel.text =titleStr;
        if([titleStr isEqual:[MLPackageDownloader getCurrentPackageName]])
        {
            //cell.imageView.image=[UIImage imageNamed:@"fCorrect"];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *packageName;
    if(indexPath.section == 0)
    {
        packageName=  [self.availableArr objectAtIndex:indexPath.row];
        if([[MLPackageDownloader getInstalledPackages] containsObject:packageName])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                            message:@"You already have this package installed."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        MLPackageDownloadViewController*pdvc=[self.storyboard instantiateViewControllerWithIdentifier:@"DownloadViewController"];
        pdvc.packageToDownload=packageName;
        [self presentViewController:pdvc animated:YES completion:nil];
    }
    else if(indexPath.section == 1)
    {
        packageName=  [self.downloadedArr objectAtIndex:indexPath.row];
        [MLPackageDownloader saveCurrentPackageName:packageName];
        [[[MLMainDataProvider alloc]initMainProvider]reloadStaticData];
        [[[MLSettingDatabase alloc]initSettingDatabase]resetFilterData];
    }
    [tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if(firstOpened)
    {
        firstOpened=false;
    }
    else
    {
        [self.mainTableView reloadData]; //refresh because we returned from download controller//[self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1.0];//
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
