//
//  JRAboutViewController.m
//  jTLC
//
//  Created by John Heaton on 9/17/13.
//  Copyright (c) 2013 John Heaton. All rights reserved.
//

#import "JRAboutViewController.h"
#import "JRMasterController.h"
#import "JRAboutMeCell.h"
#import "UIImage+RoundedImage.h"
#import "JRTextViewCell.h"
#import "JRProperImageCell.h"

#define CELL_IMAGES 1

@interface JRAboutViewController ()

@end

@implementation JRAboutViewController {
    JRMasterController *master;
    
    // my image
    UIImage *myImage;
    UIImage *twitterImage;
    UIImage *gitHubImage;
}

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        master = [JRMasterController sharedInstance];
        self.title = @"About";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView scrollRectToVisible:CGRectZero animated:NO];
}

- (void)loadView {
    [super loadView];
    
    myImage = [UIImage roundedImageWithImage:[UIImage imageNamed:@"myfatface.png"]];
#if CELL_IMAGES == 1
    twitterImage = [UIImage imageNamed:@"twitter-bird-white-on-blue.png"];
    gitHubImage = [UIImage imageNamed:@"GitHub.png"];
#endif
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = master.colorTheme.tableSeparatorColor;
    self.tableView.backgroundColor = master.colorTheme.backgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"AboutCell" bundle:nil] forCellReuseIdentifier:@"About"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AboutTheAppCell" bundle:Nil] forCellReuseIdentifier:@"AboutTheApp"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProperImageCell" bundle:nil] forCellReuseIdentifier:@"ProperImage"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissSelf)];
}

- (void)dismissSelf {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 2: return @"About The App"; break;
        case 1: return nil;
        case 0: return @"About The Developer"; break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 2: {
            switch (indexPath.row) {
                case 0: return 212; break;
            }
        } break;
        case 0: {
            switch (indexPath.row) {
                case 0: return 112; break;
            }
        } break;
    }
    
    return 65;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return 1; break;
        case 1: return 2; break;
        case 2: return 1; break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AboutMeCellIdentifier = @"About";
    
    UITableViewCell *c = nil;
    
    switch (indexPath.section) {
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    JRTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutTheApp" forIndexPath:indexPath];
                    
                    cell.textView.backgroundColor = cell.backgroundColor = master.colorTheme.foregroundColor;
                    cell.textView.textColor = master.colorTheme.subtitleTextColor;
                    cell.textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
                    cell.textView.scrollEnabled = NO;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    c = cell;
                } break;
            }
        } break;
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    JRAboutMeCell *cell = [tableView dequeueReusableCellWithIdentifier:AboutMeCellIdentifier forIndexPath:indexPath];
                    cell.myImage.image = myImage;
                    cell.myImage.backgroundColor = [UIColor clearColor];
                    cell.separatorInset = UIEdgeInsetsZero;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    c = cell;
                } break;
            }
        } break;
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    JRProperImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProperImage" forIndexPath:indexPath];
                    cell.properLabel.text = @"Twitter";
                    //                    cell.textLabel.font = [UIFont fontWithDescriptor:[UIFontDescriptor fontDescriptorWithName:@"Helvetica Neue Thin" size:17] size:17];
                    cell.properLabel.textColor = master.colorTheme.labelColor;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.backgroundColor = master.colorTheme.foregroundColor;
                    cell.properSubLabel.text = @"@JohnRHeaton";
                    cell.properSubLabel.textColor = master.colorTheme.accentColor;
                    cell.separatorInset = UIEdgeInsetsMake(0, 65+14, 0, 0);
#if CELL_IMAGES == 1
                    cell.properImageView.image = twitterImage;
#endif
                    c = cell;
                } break;
                case 1: {
                    JRProperImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProperImage" forIndexPath:indexPath];
                    cell.properLabel.text = @"GitHub";
                    //                    cell.textLabel.font = [UIFont fontWithDescriptor:[UIFontDescriptor fontDescriptorWithName:@"Helvetica Neue Thin" size:17] size:17];
                    cell.properLabel.textColor = master.colorTheme.labelColor;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.backgroundColor = master.colorTheme.foregroundColor;
                    cell.properSubLabel.text = @"JRHeaton";
                    cell.properSubLabel.textColor = master.colorTheme.accentColor;
                    
#if CELL_IMAGES == 1
                    cell.properImageView.backgroundColor = [UIColor whiteColor];
                    cell.properImageView.image = cell.properImageView.highlightedImage = gitHubImage;
                    //                    cell.properImageView.contentMode = UIViewContentModeScaleAspectFill;
#endif
                    
                    c = cell;
                } break;
            }
        } break;
    }
    
    return c;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
