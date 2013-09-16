//
//  JRScheduleViewController.m
//  jTLC
//
//  Created by John Heaton on 8/2/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRScheduleViewController.h"
#import "JRDarkCell.h"
#import "JRLoginTableViewController.h"

@interface JRScheduleViewController ()

@end

@implementation JRScheduleViewController

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
    
//    self.navigationController.navigationBar.translucent = NO;
    self.tableView.separatorColor = [UIColor colorWithWhite:0.3 alpha:1];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DarkCell2" bundle:nil] forCellReuseIdentifier:@"Dark"];
//    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.layer.opacity = 0.1;
    
//    self.title = @"Schedule";
    self.tableView.rowHeight = 188;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionButton)];
    
    UIRefreshControl *c = [[UIRefreshControl alloc] init];
    c.tintColor = [UIColor redColor];
    [c addTarget:self action:@selector(refreshPulled) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = c;
}

- (void)refreshPulled {
    [self.session fetchShifts:^(BOOL success) {
        if(success) {
            [self performSelectorOnMainThread:@selector(endRefresh) withObject:nil waitUntilDone:NO];
        }
    }];
}

- (void)endRefresh {
    [self parseTableData];
    [self.refreshControl endRefreshing];

    [self.tableView reloadData];
}

- (void)actionButton {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Log Out" otherButtonTitles:nil];
    [sheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Log Out"]) {
        [self clearUserDefaults];
//        [((JRLoginViewController *)(self.presentingViewController)) setDismissingChild:YES];
        [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)clearUserDefaults {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"employeeID"];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setSession:(TKSession *)session {
    _session = session;
    
    self.title = session.employee.name;
    [self parseTableData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    __block CGRect f = self.navigationController.navigationBar.frame;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        f.size.height = 100;
//    });
    
    self.navigationController.navigationBar.frame = f;
}

- (void)parseTableData {
    shifts = self.session.shifts;
    
    for(TKShift *s in shifts) {
        // find if has today
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return shifts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    JRDarkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Dark" forIndexPath:indexPath];
    
    TKShift *s = shifts[indexPath.row];
    
    NSInteger hour = s.startTime.hour;
    BOOL pm = NO;
    if(hour > 12) {
        hour -= 12;
        pm = YES;
    }
    
    cell.fromTime.text = [NSString stringWithFormat:@"%d:%02d %@", hour, s.startTime.minute, pm ? @"PM" : @"AM" ];
    

    hour = s.endTime.hour;
    pm = NO;
    if(hour > 12) {
        hour -= 12;
        pm = YES;
    }
    
    cell.toTime.text = [NSString stringWithFormat:@"%d:%02d %@", hour, s.endTime.minute, pm ? @"PM" : @"AM" ];
    
    NSString *day;
    
    if(s.dayOfMonth == 1 || s.dayOfMonth == 21)
        day = @"%dst";
    else if(s.dayOfMonth == 2 || s.dayOfMonth == 22)
        day = @"%dnd";
    else if(s.dayOfMonth == 3 || s.dayOfMonth == 23)
        day = @"%drd";
    else
        day = @"%dth";
    
//    NSLog(@"%@", day);
//
    NSLog(@"%@", [TKStore storeWithStoreNumber:286].address);
    cell.dayLabel.text = @[ @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday" ][s.dayOfWeek];
    cell.dateLabel.text = [NSString stringWithFormat:day, s.dayOfMonth];
    
//    cell.deptLabel.text = @"Home & Mobile Entertainment";
    cell.deptLabel.text = [NSString stringWithFormat:@"%@", s.department.name];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

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
