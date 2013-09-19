//
//  JRScheduleViewController.m
//  jTLC
//
//  Created by John Heaton on 9/18/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRScheduleViewController.h"
#import "JRInterfaceTheme.h"
#import "JRShiftTableCell.h"

@interface JRScheduleViewController ()

@end

@implementation JRScheduleViewController

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
    
    self.tableView.rowHeight = 129;
    [self.tableView registerNib:[UINib nibWithNibName:@"JRShiftTableCell" bundle:nil] forCellReuseIdentifier:@"ShiftCell"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyCurrentInterfaceTheme) name:JRInterfaceThemeChangedNotification object:nil];
    [self applyCurrentInterfaceTheme];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[JRInterfaceTheme currentTheme] statusBarStyle];
}

- (void)applyCurrentInterfaceTheme {
    JRInterfaceTheme *theme = [JRInterfaceTheme currentTheme];
    
    self.tableView.separatorColor = [theme colorForType:JRInterfaceColorTypeTableSeparator];
    self.tableView.backgroundColor = [theme colorForType:JRInterfaceColorTypeBackground];
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShiftCell";
    JRShiftTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    JRInterfaceTheme *theme = [JRInterfaceTheme currentTheme];
    
    cell.roundedRectView.cornerRadius = 20;
    cell.roundedRectView.backgroundColor = [UIColor clearColor];
    cell.roundedRectView.tintColor = [theme colorForType:JRInterfaceColorTypeAccentPrimary];
    
    cell.dayOfMonthLabel.textColor = cell.hourLabel.textColor = cell.dateLabel.textColor = [theme colorForType:JRInterfaceColorTypeTitleText];
    
    
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
