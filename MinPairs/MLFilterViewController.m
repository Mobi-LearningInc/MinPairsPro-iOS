//
//  MLFilterViewController.m
//  MinPairs
//
//  Created by Brandon on 2014-04-26.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLFilterViewController.h"
#import "MLSettingDatabase.h"
#import "MLTheme.h"

@interface MLFilterViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView* leftView;
@property (strong, nonatomic) UITableView* rightView;
@property (weak, nonatomic) NSMutableArray* mappedSounds;
@property int catIdLeft;
@end

@implementation MLFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (IBAction)onHomeClicked:(UIBarButtonItem *)sender
{
    [[self navigationController] popViewControllerAnimated:true];
}

- (void)viewDidLoad
{
    [MLTheme setTheme: self];
    [super viewDidLoad];
    _mappedSounds = nil;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UINavigationBar* navBar = [[self navigationController] navigationBar];
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGFloat navHeight = [navBar isHidden] ? 0 : navBar.frame.size.height;
    
    int w = screenRect.size.width;
    int h = screenRect.size.height;
    
    self.leftView = [[UITableView alloc] initWithFrame: CGRectMake(0.0, navHeight + statusHeight, w / 2, h - navHeight - statusHeight)];
    self.rightView = [[UITableView alloc] initWithFrame: CGRectMake(w / 2, navHeight + statusHeight, w / 2, h - navHeight - statusHeight)];
    
    [[self leftView] setDelegate: self];
    [[self rightView] setDelegate: self];
    
    [[self leftView] setDataSource: self];
    [[self rightView] setDataSource: self];
    
    [self.view addSubview: self.leftView];
    [self.view addSubview: self.rightView];
}

-(void)animate:(bool)showLeftFully
{
    [UIView animateWithDuration: 0.5f animations: ^{
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        CGRect rect = self.leftView.frame;
        rect.size.width = showLeftFully ? 500 : screenRect.size.width / 2;
        self.leftView.frame = rect;
        
        rect = self.rightView.frame;
        rect.origin.x = showLeftFully ? screenRect.size.width : screenRect.size.width / 2;
        self.rightView.frame = rect;
    }];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"cell"];
        cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:22];
    }
    
    if (tableView == [self leftView])
    {
        cell.textLabel.text = [[[MLSynchronousFilter getLeft] objectAtIndex: indexPath.row] categoryDescription];
        [self animate: true];
    }
    else
    {
        if ([self mappedSounds])
        {
            [self animate: false];
            cell.textLabel.text = [[[self mappedSounds] objectAtIndex: indexPath.row] categoryDescription];
        }
        else
        {
            [self animate: true];
        }
    }
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == [self leftView])
    {
        return [[MLSynchronousFilter getLeft] count];
    }
    return [[self mappedSounds] count];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == [self leftView])
    {
        MLCategory* ocat = [[MLSynchronousFilter getLeft] objectAtIndex: indexPath.row];
        self.catIdLeft=ocat.categoryId;
        _mappedSounds = [MLSynchronousFilter getCategoriesRight: ocat];
        [[self rightView] reloadData];
        
        if (!_mappedSounds)
        {
            [self animate: true];
        }
    }
    else //rightView then save selected pair to setting table in database and quit filter
    {
        MLCategory* catFromRightTable =[self.mappedSounds objectAtIndex:indexPath.row];
        int catIdRight = catFromRightTable.categoryId;
        MLMainDataProvider* dataProvider =[[MLMainDataProvider alloc]initMainProvider];
        MLCategory* catLeft =[dataProvider getCategoryWithId:self.catIdLeft];
        MLCategory* catRight = [dataProvider getCategoryWithId:catIdRight];
        MLPair* catPair = [[MLPair alloc]initPairWithFirstObject:catLeft secondObject:catRight];
        MLSettingDatabase* settingDb=[[MLSettingDatabase alloc]initSettingDatabase];
        MLSettingsData* currentSetting=[settingDb getSetting];
        currentSetting.settingFilterCatPair=catPair;
        [settingDb saveSetting:currentSetting];
        if(self.listener)
        {
            [self.listener onFilterSelectionChange:catPair];
        }
        [self returnBack];
    }
}
-(void)returnBack
{
    NSInteger index = self.navigationController.viewControllers.count-2; //previous controller index
    UIViewController *back= [self.navigationController.viewControllers objectAtIndex:index];
    [self.navigationController popToViewController:back animated:YES];
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
