//
//  JRScheduleTableViewController.m
//  jTLC
//
//  Created by John Heaton on 9/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRScheduleTableViewController.h"
#import "GJB.h"
#import "JRMasterController.h"

@interface JRScheduleTableViewController ()

@end

@implementation JRScheduleTableViewController {
    NSInteger status;
#define STATUS_NEEDS_NEW_LOGIN 1
#define STATUS_NO_INTERNET_CONNECTION 2
#define STATUS_TLC_DOWN 3
#define STATUS_SMOOTH 0
    
    JRMasterController *master;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    master = [JRMasterController sharedInstance];
    
    status = STATUS_SMOOTH;
    
    self.tableView.separatorColor = master.colorTheme.tableSeparatorColor;
    self.tableView.backgroundColor = master.colorTheme.backgroundColor;
    self.tableView.rowHeight = 122;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShiftCell" bundle:nil] forCellReuseIdentifier:@"Shift"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *control = [[UIRefreshControl alloc] init];
    control.tintColor = master.colorTheme.accentColor;
    [control addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)refresh {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Shift";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end