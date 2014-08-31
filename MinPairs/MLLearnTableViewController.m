//
//  MLLearnTableViewController.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 5/1/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLLearnTableViewController.h"
#import "MLHelpViewController.h"
#import "MLLearnTableViewCell.h"
#import "MLMainDataProvider.h"
#import "MLSettingDatabase.h"
#import "MLTheme.h"
#import "MLFilterViewController.h"

@interface MLLearnTableViewController() <UISearchDisplayDelegate, UISearchBarDelegate>
@property NSArray* learnPairsArr;
@property NSArray* learnCatArr;
@property (strong, nonatomic) NSArray* searchResults;
//@property MLPair* filterCategoryPair;
@end

@implementation MLLearnTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)onHomeClicked:(UIBarButtonItem *)sender
{
    [[self navigationController] popViewControllerAnimated:true];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [MLTheme updateTheme];
}

- (void)viewDidLoad
{
    UIBarButtonItem* filterBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mFilter.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(onFilterClicked:)];
    
    UIBarButtonItem* helpBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mHelp.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(onHelpClicked:)];
    
    //[filterBtn setTintColor: [MLTheme navButtonColour]];
    self.navigationItem.rightBarButtonItems = @[helpBtn, filterBtn];
    
    [MLTheme setTheme: self];
    [super viewDidLoad];
    [self loadData];
    
}
-(void)loadData
{
    MLMainDataProvider* dataPro=[[MLMainDataProvider alloc]initMainProvider];
    MLSettingDatabase* settingDb=[[MLSettingDatabase alloc]initSettingDatabase];
    MLSettingsData* setting=[settingDb getSetting];
    MLPair* filterCatPair =setting.settingFilterCatPair;
    //self.filterCategoryPair=filterCatPair;
    MLCategory* filterCatLeft=filterCatPair.first;
    MLCategory* filterCatRight=filterCatPair.second;
    self.title =[NSString stringWithFormat:@"Learn %@ vs %@",filterCatLeft.categoryDescription,filterCatRight.categoryDescription];
    NSArray* pairPairArr = [dataPro getPairs];
    NSMutableArray* filteredArr = [NSMutableArray array];
    NSMutableArray* filteredCatArr= [NSMutableArray array];
    for (int i=0; i<pairPairArr.count; i++)
    {
        MLPair* p=[pairPairArr objectAtIndex:i];
        MLPair * pl=p.first;
        MLPair* pr = p.second;
        MLCategory * cl = pl.first;
        MLItem* il = pl.second;
        MLCategory * cr=pr.first;
        MLItem* ir=pr.second;
        
        
        if (filterCatLeft.categoryId==0)//filter is set to 'all'
        {
            [filteredArr addObject:[[MLPair alloc]initPairWithFirstObject:il secondObject:ir]];
            [filteredCatArr addObject:[[MLPair alloc]initPairWithFirstObject:cl secondObject:cr]];
        }
        else
        {
            if ((filterCatLeft.categoryId==cl.categoryId&&filterCatRight.categoryId==cr.categoryId)||(filterCatLeft.categoryId==cr.categoryId&&filterCatRight.categoryId==cl.categoryId))
            {
                [filteredArr addObject:[[MLPair alloc]initPairWithFirstObject:il secondObject:ir]];
                [filteredCatArr addObject:[[MLPair alloc]initPairWithFirstObject:cl secondObject:cr]];
            }
        }
    }
    
    self.learnPairsArr = filteredArr;
    self.learnCatArr = filteredCatArr;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)onFilterClicked:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"goToFilter" sender:self];
}

- (IBAction)onHelpClicked:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"AppHelp" sender:self];
}

#pragma mark - Table view data source

/** Filters the category array and stores the results in searchResults array. **/
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate* resultPredicate = [NSPredicate predicateWithFormat:@"(SELF.%K.itemDescription contains[cd] %@) OR (SELF.%K.itemDescription contains[cd] %@)", @"first", searchText, @"second", searchText];
    self.searchResults = [self.learnPairsArr filteredArrayUsingPredicate:resultPredicate];
}

/** When the user types something. Called whenever the search string changes. **/
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResults count];
    }
    return self.learnPairsArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /**
        This line is sort of a hackish workaround :l.. 
        It uses self.tableView rather than the tableView parameter. It should not do this
        but there is no other way to use the same storyboard cell for both search and non-search views without
        doing them programatically.
     **/
    MLLearnTableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"LearnCell" forIndexPath: indexPath];
    
    if (!cell)
    {
        cell = [[MLLearnTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LearnCell"];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        MLPair* itemPair = [self.searchResults objectAtIndex:indexPath.row];
        MLPair* catPair = [self.learnCatArr objectAtIndex:indexPath.row];
        [cell setCellItemPair: itemPair categoryPair:catPair];
    }
    else
    {
        MLPair* itemPair = [self.learnPairsArr objectAtIndex:indexPath.row];
        MLPair* catPair = [self.learnCatArr objectAtIndex:indexPath.row];
        [cell setCellItemPair:itemPair categoryPair:catPair];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self tableView] rowHeight];
}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString: @"goToFilter"])
    {
        MLFilterViewController* vc = [segue destinationViewController];
        vc.listener=self;
    }
    else if ([[segue identifier] isEqualToString: @"AppHelp"])
    {
        MLHelpViewController* vc = [segue destinationViewController];
        vc.pageId = 3;
    }
}
-(void)onFilterSelectionChange:(MLPair*)itemPair
{
    //[self.view setNeedsDisplay];
    [self loadData];
    [self.tableView reloadData];
    
    #ifdef DEBUG
    NSLog(@"updated view after filter changed");
    #endif
}

@end
