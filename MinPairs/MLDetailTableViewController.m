//
//  MLDetailTableViewController.m
//  MinPairs
//
//  Created by Oleksiy Martynov on 5/24/14.
//  Copyright (c) 2014 MobiLearning. All rights reserved.
//

#import "MLDetailTableViewController.h"
#import "MLDetailsItem.h"
#import "MLDetailTableCellTypeOne.h"
#import "MLDetailTableCellTypeTwo.h"
#import "MLDetailTableCellTypeThree.h"
#import "MLTheme.h"
#import "MLPlatform.h"

@interface MLDetailTableViewController ()
@property NSMutableArray* cellDataArr;
@property (weak, nonatomic) IBOutlet UIButton *DoneButton;
@end

@implementation MLDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [MLTheme setTheme:self];
    [MLPlatform setButtonRound:[self DoneButton] withRadius: 10.0f];
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.cellDataArr=[NSMutableArray array];
    for(int i=0; i<self.array.count;i++)
    {
        MLDetailsItem* item = [self.array objectAtIndex:i];
        [self.cellDataArr addObject:item];//can be filtered by detailCorrect property
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.cellDataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //available reuseItentifiers: detailCellTypeOne, detailCellTypeTwo, detailCellTypeTree
    MLDetailsItem* item=[self.cellDataArr objectAtIndex:indexPath.row];
    UITableViewCell *cell;
    switch (item.detailType) {
        case DETAIL_TYPE_ONE:
        {
           MLDetailTableCellTypeOne* tempCell = [tableView dequeueReusableCellWithIdentifier:@"detailCellTypeOne" forIndexPath:indexPath];
            [tempCell setData:item.detailNumber :item.correctItem :item.userItem];
            cell = tempCell;
            break;
        }
            
        case DETAIL_TYPE_TWO:
        {
            MLDetailTableCellTypeTwo* tempCell = [tableView dequeueReusableCellWithIdentifier:@"detailCellTypeTwo" forIndexPath:indexPath];
            [tempCell setData:item.detailNumber:item.correctItem :item.userItem];
            cell = tempCell;
            break;
        }
            
        case DETAIL_TYPE_THREE:
        {
            MLDetailTableCellTypeThree* tempCell = [tableView dequeueReusableCellWithIdentifier:@"detailCellTypeThree" forIndexPath:indexPath];
            [tempCell setData:item.detailNumber :item.correctItem :item.userItem];
            cell = tempCell;
            break;
        }
        default:
            #ifdef DEBUG
            NSLog(@"unknown detail type");
            #endif
            break;
    }
    
    
    
    return cell;
}
- (IBAction)onDoneBtn:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
